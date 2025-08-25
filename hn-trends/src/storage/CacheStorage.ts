import { promises as fs } from 'fs';
import { join } from 'path';
import { homedir } from 'os';
import { HiringPost, TrendAnalysis } from '../models/TrendData';
import chalk from 'chalk';

export interface CachedData {
  lastFetch: Date;
  posts: HiringPost[];
  analysis?: TrendAnalysis;
}

export class CacheStorage {
  private readonly cacheDir: string;
  private readonly cacheFile: string;
  private readonly maxCacheAge: number = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

  constructor() {
    this.cacheDir = join(homedir(), '.hn-trends');
    this.cacheFile = join(this.cacheDir, 'cache.json');
  }

  /**
   * Initialize storage directory
   */
  async initialize(): Promise<void> {
    try {
      await fs.mkdir(this.cacheDir, { recursive: true });
    } catch (error) {
      console.error(chalk.red(`❌ Failed to create cache directory: ${error}`));
      throw error;
    }
  }

  /**
   * Save hiring posts to cache
   */
  async savePosts(posts: HiringPost[], analysis?: TrendAnalysis): Promise<void> {
    try {
      const data: CachedData = {
        lastFetch: new Date(),
        posts,
        analysis
      };
      
      await fs.writeFile(this.cacheFile, JSON.stringify(data, null, 2));
      console.log(chalk.green(`💾 Cached ${posts.length} posts`));
    } catch (error) {
      console.error(chalk.yellow(`⚠️  Failed to save cache: ${error}`));
    }
  }

  /**
   * Load hiring posts from cache
   */
  async loadPosts(): Promise<CachedData | null> {
    try {
      const data = await fs.readFile(this.cacheFile, 'utf-8');
      const cached: CachedData = JSON.parse(data);
      
      // Convert date strings back to Date objects
      cached.lastFetch = new Date(cached.lastFetch);
      if (cached.analysis) {
        cached.analysis.timeRange.start = new Date(cached.analysis.timeRange.start);
        cached.analysis.timeRange.end = new Date(cached.analysis.timeRange.end);
      }
      
      return cached;
    } catch (error) {
      return null;
    }
  }

  /**
   * Check if cache is valid (not expired)
   */
  async isCacheValid(): Promise<boolean> {
    const cached = await this.loadPosts();
    if (!cached) return false;
    
    const now = new Date().getTime();
    const cacheTime = cached.lastFetch.getTime();
    const age = now - cacheTime;
    
    return age < this.maxCacheAge;
  }

  /**
   * Get cache status information
   */
  async getCacheStatus(): Promise<{
    exists: boolean;
    valid: boolean;
    lastFetch?: Date;
    postsCount?: number;
    ageHours?: number;
  }> {
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
  async clearCache(): Promise<void> {
    try {
      await fs.unlink(this.cacheFile);
      console.log(chalk.green('🗑️  Cache cleared'));
    } catch (error) {
      // File might not exist, that's okay
      console.log(chalk.dim('🗑️  No cache to clear'));
    }
  }

  /**
   * Get cache file size
   */
  async getCacheSize(): Promise<number> {
    try {
      const stats = await fs.stat(this.cacheFile);
      return stats.size;
    } catch (error) {
      return 0;
    }
  }

  /**
   * Format cache size in human readable format
   */
  formatCacheSize(bytes: number): string {
    if (bytes === 0) return '0 B';
    
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
  }
}
