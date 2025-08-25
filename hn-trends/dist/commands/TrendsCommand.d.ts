import { Command } from 'commander';
import { HackerNewsService } from '../services/HackerNewsService';
import { TechnologyAnalyzer } from '../services/TechnologyAnalyzer';
import { CacheStorage } from '../storage/CacheStorage';
export declare class TrendsCommand {
    private hnService;
    private analyzer;
    private cache;
    private chartRenderer;
    constructor(hnService: HackerNewsService, analyzer: TechnologyAnalyzer, cache: CacheStorage);
    register(program: Command): void;
    private showTrends;
    private showLanguages;
    private showGrowthTrends;
    private compareTechnologies;
    private manageCache;
    private getAnalysis;
    private printAnalysisHeader;
    private printTechnologyTable;
    private printGrowthCharts;
    private printGrowthTable;
    private printComparisonTable;
    private printTechnologyCharts;
    private getCategoryBreakdown;
    private printLanguageCharts;
    private printLanguageDistribution;
    private printTimelineComparison;
    private groupByQuarters;
    private getCategoryColor;
}
//# sourceMappingURL=TrendsCommand.d.ts.map