import { HiringPost } from '../models/TrendData';
export declare class HackerNewsService {
    private readonly baseUrl;
    private readonly hiringPattern;
    private readonly maxConcurrentRequests;
    private readonly batchSize;
    /**
     * Fetches all "Who is Hiring?" posts from the last specified months
     * OPTIMIZED: Parallel processing, batch requests, smart filtering
     */
    fetchHiringPosts(months?: number): Promise<HiringPost[]>;
    /**
     * OPTIMIZED: Batch fetch hiring posts in parallel
     */
    private batchFetchHiringPosts;
    /**
     * OPTIMIZED: Batch fetch comments with parallel processing
     */
    private batchFetchComments;
    /**
     * OPTIMIZED: Single post fetch with timeout
     */
    private fetchPost;
    /**
     * OPTIMIZED: Fetch comments with smart filtering
     */
    private fetchHiringComments;
    /**
     * Checks if a post is a "Who is Hiring?" post
     */
    private isHiringPost;
    /**
     * Optimized sleep function
     */
    private sleep;
    /**
     * Gets the latest hiring post for testing
     */
    getLatestHiringPost(): Promise<HiringPost | null>;
}
//# sourceMappingURL=HackerNewsService.d.ts.map