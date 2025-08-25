export interface HiringPost {
  id: number;
  title: string;
  text: string;
  time: number; // Unix timestamp
  url: string;
  by: string; // Author
}

export interface TechnologyMention {
  name: string;
  category: 'programming_language' | 'framework' | 'database' | 'tool' | 'platform' | 'other';
  count: number;
  posts: number[]; // HN post IDs where mentioned
  aliases: string[]; // Alternative names (e.g., 'js' for 'javascript')
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
  growthRate: number; // Percentage change
  confidence: number; // 0-1 confidence score
}

export interface ComparisonResult {
  technologies: string[];
  periods: {
    period: string;
    data: Record<string, number>; // tech name -> mention count
  }[];
  summary: {
    winner: string;
    trend: 'convergent' | 'divergent' | 'stable';
    insights: string[];
  };
}
