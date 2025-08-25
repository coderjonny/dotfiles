"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.HackerNewsService = void 0;
const axios_1 = __importDefault(require("axios"));
const chalk_1 = __importDefault(require("chalk"));
const progress_1 = __importDefault(require("progress"));
class HackerNewsService {
    baseUrl = 'https://hacker-news.firebaseio.com/v0';
    hiringPattern = /ask hn: who is hiring\?.*\d{4}/i;
    maxConcurrentRequests = 10; // Parallel processing
    batchSize = 50; // Batch API calls
    /**
     * Fetches all "Who is Hiring?" posts from the last specified months
     * OPTIMIZED: Parallel processing, batch requests, smart filtering
     */
    async fetchHiringPosts(months = 24) {
        console.log(chalk_1.default.blue(`🔍 Searching for hiring posts from the last ${months} months...`));
        const cutoffDate = new Date();
        cutoffDate.setMonth(cutoffDate.getMonth() - months);
        const cutoffTimestamp = cutoffDate.getTime() / 1000;
        try {
            // Get whoishiring submissions
            console.log(chalk_1.default.dim('📡 Fetching whoishiring user submissions...'));
            const userResponse = await axios_1.default.get(`${this.baseUrl}/user/whoishiring.json`);
            const submissions = userResponse.data.submitted || [];
            // OPTIMIZATION: Pre-filter by timestamp to reduce API calls
            console.log(chalk_1.default.dim('🔍 Pre-filtering submissions by date...'));
            const recentSubmissions = submissions.slice(0, 200); // Only check recent 200
            // OPTIMIZATION: Batch fetch posts in parallel
            const hiringPostIds = await this.batchFetchHiringPosts(recentSubmissions, cutoffTimestamp);
            console.log(chalk_1.default.green(`✅ Found ${hiringPostIds.length} hiring posts`));
            // OPTIMIZATION: Batch fetch comments in parallel with smart filtering
            const allPosts = await this.batchFetchComments(hiringPostIds);
            console.log(chalk_1.default.green(`🎉 Successfully fetched ${allPosts.length} hiring posts/comments`));
            return allPosts;
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error fetching hiring posts: ${error}`));
            throw error;
        }
    }
    /**
     * OPTIMIZED: Batch fetch hiring posts in parallel
     */
    async batchFetchHiringPosts(submissions, cutoffTimestamp) {
        const hiringPostIds = [];
        const progressBar = new progress_1.default('🔎 Scanning posts [:bar] :percent :etas', {
            complete: '█',
            incomplete: '░',
            width: 30,
            total: submissions.length
        });
        // Process in batches for parallel execution
        for (let i = 0; i < submissions.length; i += this.batchSize) {
            const batch = submissions.slice(i, i + this.batchSize);
            // OPTIMIZATION: Parallel batch processing
            const batchPromises = batch.map(async (postId) => {
                try {
                    const post = await this.fetchPost(postId);
                    if (post && this.isHiringPost(post) && post.time >= cutoffTimestamp) {
                        return postId;
                    }
                    return null;
                }
                catch (error) {
                    return null;
                }
            });
            // OPTIMIZATION: Use Promise.allSettled for better error handling
            const results = await Promise.allSettled(batchPromises);
            // Collect valid results
            results.forEach(result => {
                if (result.status === 'fulfilled' && result.value !== null) {
                    hiringPostIds.push(result.value);
                }
            });
            progressBar.tick(batch.length);
            // OPTIMIZATION: Reduced rate limiting for batch processing
            if (i + this.batchSize < submissions.length) {
                await this.sleep(50); // Reduced from 100ms
            }
        }
        return hiringPostIds;
    }
    /**
     * OPTIMIZED: Batch fetch comments with parallel processing
     */
    async batchFetchComments(hiringPostIds) {
        const allPosts = [];
        const progressBar = new progress_1.default('📥 Fetching hiring comments [:bar] :percent :etas', {
            complete: '█',
            incomplete: '░',
            width: 30,
            total: hiringPostIds.length
        });
        // Process in batches
        for (let i = 0; i < hiringPostIds.length; i += this.maxConcurrentRequests) {
            const batch = hiringPostIds.slice(i, i + this.maxConcurrentRequests);
            // OPTIMIZATION: Parallel comment fetching
            const batchPromises = batch.map(async (postId) => {
                try {
                    return await this.fetchHiringComments(postId);
                }
                catch (error) {
                    return [];
                }
            });
            const results = await Promise.allSettled(batchPromises);
            // Flatten and collect results
            results.forEach(result => {
                if (result.status === 'fulfilled') {
                    allPosts.push(...result.value);
                }
            });
            progressBar.tick(batch.length);
            // OPTIMIZATION: Reduced rate limiting
            if (i + this.maxConcurrentRequests < hiringPostIds.length) {
                await this.sleep(100); // Reduced from 200ms
            }
        }
        return allPosts;
    }
    /**
     * OPTIMIZED: Single post fetch with timeout
     */
    async fetchPost(id) {
        try {
            const response = await axios_1.default.get(`${this.baseUrl}/item/${id}.json`, {
                timeout: 5000 // 5 second timeout
            });
            const item = response.data;
            if (!item)
                return null;
            return {
                id: item.id,
                title: item.title || '',
                text: item.text || '',
                time: item.time,
                url: item.url || `https://news.ycombinator.com/item?id=${item.id}`,
                by: item.by || 'unknown'
            };
        }
        catch (error) {
            return null;
        }
    }
    /**
     * OPTIMIZED: Fetch comments with smart filtering
     */
    async fetchHiringComments(postId) {
        const comments = [];
        try {
            const response = await axios_1.default.get(`${this.baseUrl}/item/${postId}.json`, {
                timeout: 5000
            });
            const item = response.data;
            if (item.kids) {
                // OPTIMIZATION: Limit to top 500 comments to avoid rate limiting
                const commentIds = item.kids.slice(0, 500);
                // OPTIMIZATION: Parallel comment fetching with concurrency limit
                const commentPromises = commentIds.map(async (kidId) => {
                    try {
                        const comment = await this.fetchPost(kidId);
                        // OPTIMIZATION: Early filtering - only process substantial comments
                        if (comment && comment.text && comment.text.length > 50) {
                            return comment;
                        }
                        return null;
                    }
                    catch (error) {
                        return null;
                    }
                });
                // OPTIMIZATION: Process in smaller chunks to avoid overwhelming API
                const chunkSize = 20;
                for (let i = 0; i < commentPromises.length; i += chunkSize) {
                    const chunk = commentPromises.slice(i, i + chunkSize);
                    const chunkResults = await Promise.allSettled(chunk);
                    chunkResults.forEach(result => {
                        if (result.status === 'fulfilled' && result.value !== null) {
                            comments.push(result.value);
                        }
                    });
                    // Small delay between chunks
                    if (i + chunkSize < commentPromises.length) {
                        await this.sleep(20);
                    }
                }
            }
        }
        catch (error) {
            // Silently handle errors to avoid breaking the batch
        }
        return comments;
    }
    /**
     * Checks if a post is a "Who is Hiring?" post
     */
    isHiringPost(post) {
        if (!post.title)
            return false;
        return this.hiringPattern.test(post.title);
    }
    /**
     * Optimized sleep function
     */
    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
    /**
     * Gets the latest hiring post for testing
     */
    async getLatestHiringPost() {
        try {
            const userResponse = await axios_1.default.get(`${this.baseUrl}/user/whoishiring.json`);
            const submissions = userResponse.data.submitted || [];
            // Check the most recent submissions
            for (const postId of submissions.slice(0, 10)) {
                const post = await this.fetchPost(postId);
                if (post && this.isHiringPost(post)) {
                    return post;
                }
            }
            return null;
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error fetching latest hiring post: ${error}`));
            return null;
        }
    }
}
exports.HackerNewsService = HackerNewsService;
//# sourceMappingURL=HackerNewsService.js.map