export interface HiringPost {
    id: number;
    title: string;
    text: string;
    time: number;
    url: string;
    by: string;
}
export interface TechnologyMention {
    name: string;
    category: 'programming_language' | 'framework' | 'database' | 'tool' | 'platform' | 'other';
    count: number;
    posts: number[];
    aliases: string[];
}
export interface TrendPeriod {
    year: number;
    month: number;
    totalPosts: number;
    technologies: Record<string, TechnologyMention>;
}
export interface TrendAnalysis {
    timeRange: {
        start: Date;
        end: Date;
    };
    totalPosts: number;
    periods: TrendPeriod[];
    topTechnologies: TechnologyMention[];
    growthTrends: GrowthTrend[];
}
export interface GrowthTrend {
    technology: string;
    category: string;
    trend: 'rising' | 'declining' | 'stable';
    growthRate: number;
    confidence: number;
}
export interface ComparisonResult {
    technologies: string[];
    periods: {
        period: string;
        data: Record<string, number>;
    }[];
    summary: {
        winner: string;
        trend: 'convergent' | 'divergent' | 'stable';
        insights: string[];
    };
}
//# sourceMappingURL=TrendData.d.ts.map