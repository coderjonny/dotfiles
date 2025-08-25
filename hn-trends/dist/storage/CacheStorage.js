"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CacheStorage = void 0;
const fs_1 = require("fs");
const path_1 = require("path");
const os_1 = require("os");
const chalk_1 = __importDefault(require("chalk"));
class CacheStorage {
    cacheDir;
    cacheFile;
    maxCacheAge = 24 * 60 * 60 * 1000; // 24 hours in milliseconds
    constructor() {
        this.cacheDir = (0, path_1.join)((0, os_1.homedir)(), '.hn-trends');
        this.cacheFile = (0, path_1.join)(this.cacheDir, 'cache.json');
    }
    /**
     * Initialize storage directory
     */
    async initialize() {
        try {
            await fs_1.promises.mkdir(this.cacheDir, { recursive: true });
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Failed to create cache directory: ${error}`));
            throw error;
        }
    }
    /**
     * Save hiring posts to cache
     */
    async savePosts(posts, analysis) {
        try {
            const data = {
                lastFetch: new Date(),
                posts,
                analysis
            };
            await fs_1.promises.writeFile(this.cacheFile, JSON.stringify(data, null, 2));
            console.log(chalk_1.default.green(`💾 Cached ${posts.length} posts`));
        }
        catch (error) {
            console.error(chalk_1.default.yellow(`⚠️  Failed to save cache: ${error}`));
        }
    }
    /**
     * Load hiring posts from cache
     */
    async loadPosts() {
        try {
            const data = await fs_1.promises.readFile(this.cacheFile, 'utf-8');
            const cached = JSON.parse(data);
            // Convert date strings back to Date objects
            cached.lastFetch = new Date(cached.lastFetch);
            if (cached.analysis) {
                cached.analysis.timeRange.start = new Date(cached.analysis.timeRange.start);
                cached.analysis.timeRange.end = new Date(cached.analysis.timeRange.end);
            }
            return cached;
        }
        catch (error) {
            return null;
        }
    }
    /**
     * Check if cache is valid (not expired)
     */
    async isCacheValid() {
        const cached = await this.loadPosts();
        if (!cached)
            return false;
        const now = new Date().getTime();
        const cacheTime = cached.lastFetch.getTime();
        const age = now - cacheTime;
        return age < this.maxCacheAge;
    }
    /**
     * Get cache status information
     */
    async getCacheStatus() {
        const cached = await this.loadPosts();
        if (!cached) {
            return { exists: false, valid: false };
        }
        const now = new Date().getTime();
        const cacheTime = cached.lastFetch.getTime();
        const age = now - cacheTime;
        const ageHours = age / (60 * 60 * 1000);
        const valid = age < this.maxCacheAge;
        return {
            exists: true,
            valid,
            lastFetch: cached.lastFetch,
            postsCount: cached.posts.length,
            ageHours
        };
    }
    /**
     * Clear cache
     */
    async clearCache() {
        try {
            await fs_1.promises.unlink(this.cacheFile);
            console.log(chalk_1.default.green('🗑️  Cache cleared'));
        }
        catch (error) {
            // File might not exist, that's okay
            console.log(chalk_1.default.dim('🗑️  No cache to clear'));
        }
    }
    /**
     * Get cache file size
     */
    async getCacheSize() {
        try {
            const stats = await fs_1.promises.stat(this.cacheFile);
            return stats.size;
        }
        catch (error) {
            return 0;
        }
    }
    /**
     * Format cache size in human readable format
     */
    formatCacheSize(bytes) {
        if (bytes === 0)
            return '0 B';
        const sizes = ['B', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(1024));
        return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
    }
}
exports.CacheStorage = CacheStorage;
//# sourceMappingURL=CacheStorage.js.map