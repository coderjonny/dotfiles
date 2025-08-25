import { HiringPost, TrendAnalysis } from '../models/TrendData';
export interface CachedData {
    lastFetch: Date;
    posts: HiringPost[];
    analysis?: TrendAnalysis;
}
export declare class CacheStorage {
    private readonly cacheDir;
    private readonly cacheFile;
    private readonly maxCacheAge;
    constructor();
    /**
     * Initialize storage directory
     */
    initialize(): Promise<void>;
    /**
     * Save hiring posts to cache
     */
    savePosts(posts: HiringPost[], analysis?: TrendAnalysis): Promise<void>;
    /**
     * Load hiring posts from cache
     */
    loadPosts(): Promise<CachedData | null>;
    /**
     * Check if cache is valid (not expired)
     */
    isCacheValid(): Promise<boolean>;
    /**
     * Get cache status information
     */
    getCacheStatus(): Promise<{
        exists: boolean;
        valid: boolean;
        lastFetch?: Date;
        postsCount?: number;
        ageHours?: number;
    }>;
    /**
     * Clear cache
     */
    clearCache(): Promise<void>;
    /**
     * Get cache file size
     */
    getCacheSize(): Promise<number>;
    /**
     * Format cache size in human readable format
     */
    formatCacheSize(bytes: number): string;
}
//# sourceMappingURL=CacheStorage.d.ts.map