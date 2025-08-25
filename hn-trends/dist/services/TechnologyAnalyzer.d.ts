import { HiringPost, TrendAnalysis } from '../models/TrendData';
export declare class TechnologyAnalyzer {
    private readonly technologyPatterns;
    private readonly technologyMap;
    constructor();
    /**
     * OPTIMIZATION: Build-time pattern compilation for maximum performance
     */
    private initializeTechnologyPatterns;
    /**
     * OPTIMIZED: Analyzes hiring posts with massive performance improvements
     */
    analyzeTrends(posts: HiringPost[]): TrendAnalysis;
    /**
     * OPTIMIZATION: Pre-process posts to extract only needed data
     */
    private preprocessPosts;
    /**
     * OPTIMIZATION: Single-pass analysis with optimized data structures
     */
    private singlePassAnalysis;
    /**
     * OPTIMIZATION: Ultra-fast technology extraction using pre-compiled patterns
     */
    private extractTechnologiesOptimized;
    /**
     * OPTIMIZATION: Efficient period conversion
     */
    private convertPeriodStats;
    /**
     * OPTIMIZATION: Efficient overall stats conversion
     */
    private convertOverallStats;
    /**
     * OPTIMIZATION: Efficient growth trends calculation
     */
    private calculateGrowthTrendsOptimized;
    /**
     * OPTIMIZATION: Efficient time range calculation
     */
    private getTimeRangeOptimized;
    /**
     * Get available technology categories
     */
    getCategories(): string[];
    /**
     * Get technologies by category
     */
    getTechnologiesByCategory(category: string): string[];
}
//# sourceMappingURL=TechnologyAnalyzer.d.ts.map