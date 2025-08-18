"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TrendsCommand = void 0;
const chalk_1 = __importDefault(require("chalk"));
const cli_table3_1 = __importDefault(require("cli-table3"));
const date_fns_1 = require("date-fns");
const ChartRenderer_1 = require("../utils/ChartRenderer");
class TrendsCommand {
    hnService;
    analyzer;
    cache;
    chartRenderer;
    constructor(hnService, analyzer, cache) {
        this.hnService = hnService;
        this.analyzer = analyzer;
        this.cache = cache;
        this.chartRenderer = new ChartRenderer_1.ChartRenderer();
    }
    register(program) {
        const trendsCmd = program
            .command('trends')
            .description('📈 Analyze technology trends from HN hiring posts');
        // Main trends command
        trendsCmd
            .command('show')
            .description('Show technology trends over time')
            .option('-m, --months <number>', 'Number of months to analyze (default: 24)', '24')
            .option('-c, --category <category>', 'Filter by category (programming_language, framework, database, tool, platform)')
            .option('-l, --limit <number>', 'Limit number of results (default: 20)', '20')
            .option('--force-refresh', 'Force refresh data from HN API')
            .option('--charts', 'Show beautiful bar charts and visualizations')
            .action(async (options) => {
            await this.showTrends(options);
        });
        // Top languages specifically
        trendsCmd
            .command('languages')
            .description('Show top programming languages')
            .option('-m, --months <number>', 'Number of months to analyze (default: 24)', '24')
            .option('-l, --limit <number>', 'Limit number of results (default: 15)', '15')
            .option('--force-refresh', 'Force refresh data from HN API')
            .option('--charts', 'Show beautiful bar charts and visualizations')
            .action(async (options) => {
            await this.showLanguages(options);
        });
        // Growth trends
        trendsCmd
            .command('growth')
            .description('Show technologies with highest growth/decline')
            .option('-m, --months <number>', 'Number of months to analyze (default: 24)', '24')
            .option('--rising', 'Show only rising technologies')
            .option('--declining', 'Show only declining technologies')
            .option('--force-refresh', 'Force refresh data from HN API')
            .option('--charts', 'Show beautiful bar charts and visualizations')
            .action(async (options) => {
            await this.showGrowthTrends(options);
        });
        // Compare specific technologies
        trendsCmd
            .command('compare <technologies...>')
            .description('Compare specific technologies (e.g., "react vue angular")')
            .option('-m, --months <number>', 'Number of months to analyze (default: 24)', '24')
            .option('--force-refresh', 'Force refresh data from HN API')
            .action(async (technologies, options) => {
            await this.compareTechnologies(technologies, options);
        });
        // Cache management
        trendsCmd
            .command('cache')
            .description('Manage data cache')
            .option('--status', 'Show cache status')
            .option('--clear', 'Clear cache')
            .action(async (options) => {
            await this.manageCache(options);
        });
    }
    async showTrends(options) {
        try {
            const analysis = await this.getAnalysis(parseInt(options.months), options.forceRefresh);
            console.log(chalk_1.default.blue.bold('\n📈 Technology Trends Analysis'));
            console.log(chalk_1.default.dim('━'.repeat(80)));
            this.printAnalysisHeader(analysis);
            let technologies = analysis.topTechnologies;
            // Filter by category if specified
            if (options.category) {
                technologies = technologies.filter(tech => tech.category === options.category);
                console.log(chalk_1.default.yellow(`\n🔍 Filtered by category: ${options.category}`));
            }
            // Limit results
            const limit = parseInt(options.limit);
            technologies = technologies.slice(0, limit);
            // Show charts if requested
            if (options.charts) {
                this.printTechnologyCharts(technologies);
            }
            this.printTechnologyTable(technologies, 'Top Technologies');
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error showing trends: ${error}`));
        }
    }
    async showLanguages(options) {
        try {
            const analysis = await this.getAnalysis(parseInt(options.months), options.forceRefresh);
            console.log(chalk_1.default.blue.bold('\n💻 Programming Languages Trends'));
            console.log(chalk_1.default.dim('━'.repeat(80)));
            this.printAnalysisHeader(analysis);
            const languages = analysis.topTechnologies
                .filter(tech => tech.category === 'programming_language')
                .slice(0, parseInt(options.limit));
            // Show charts if requested
            if (options.charts) {
                this.printLanguageCharts(languages);
            }
            this.printTechnologyTable(languages, 'Top Programming Languages');
            // Show language distribution pie chart (text-based)
            this.printLanguageDistribution(languages);
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error showing languages: ${error}`));
        }
    }
    async showGrowthTrends(options) {
        try {
            const analysis = await this.getAnalysis(parseInt(options.months), options.forceRefresh);
            console.log(chalk_1.default.blue.bold('\n📊 Growth Trends Analysis'));
            console.log(chalk_1.default.dim('━'.repeat(80)));
            this.printAnalysisHeader(analysis);
            let trends = analysis.growthTrends.filter(trend => trend.confidence > 0.2);
            if (options.rising) {
                trends = trends.filter(trend => trend.trend === 'rising');
            }
            else if (options.declining) {
                trends = trends.filter(trend => trend.trend === 'declining');
            }
            // Show charts if requested
            if (options.charts) {
                this.printGrowthCharts(trends);
            }
            this.printGrowthTable(trends.slice(0, 20));
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error showing growth trends: ${error}`));
        }
    }
    async compareTechnologies(technologies, options) {
        try {
            const analysis = await this.getAnalysis(parseInt(options.months), options.forceRefresh);
            console.log(chalk_1.default.blue.bold(`\n⚔️  Technology Comparison: ${technologies.join(' vs ')}`));
            console.log(chalk_1.default.dim('━'.repeat(80)));
            this.printAnalysisHeader(analysis);
            // Find matching technologies (case-insensitive)
            const matchedTechs = technologies.map(tech => {
                const normalizedTech = tech.toLowerCase();
                return analysis.topTechnologies.find(t => t.name.toLowerCase().includes(normalizedTech) ||
                    t.aliases.some(alias => alias.toLowerCase().includes(normalizedTech)));
            }).filter(tech => tech !== undefined);
            if (matchedTechs.length === 0) {
                console.log(chalk_1.default.yellow('⚠️  No matching technologies found.'));
                return;
            }
            this.printComparisonTable(matchedTechs);
            this.printTimelineComparison(analysis, matchedTechs);
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error comparing technologies: ${error}`));
        }
    }
    async manageCache(options) {
        try {
            if (options.clear) {
                await this.cache.clearCache();
                return;
            }
            if (options.status) {
                const status = await this.cache.getCacheStatus();
                const size = await this.cache.getCacheSize();
                console.log(chalk_1.default.blue.bold('\n💾 Cache Status'));
                console.log(chalk_1.default.dim('━'.repeat(40)));
                if (!status.exists) {
                    console.log(chalk_1.default.yellow('📭 No cache found'));
                }
                else {
                    console.log(`📦 Cache exists: ${chalk_1.default.green('Yes')}`);
                    console.log(`✅ Valid: ${status.valid ? chalk_1.default.green('Yes') : chalk_1.default.red('No')}`);
                    console.log(`📅 Last fetch: ${chalk_1.default.cyan(status.lastFetch?.toLocaleString())}`);
                    console.log(`📊 Posts cached: ${chalk_1.default.cyan(status.postsCount?.toLocaleString())}`);
                    console.log(`⏰ Age: ${chalk_1.default.cyan(status.ageHours?.toFixed(1))} hours`);
                    console.log(`💾 Size: ${chalk_1.default.cyan(this.cache.formatCacheSize(size))}`);
                }
                console.log('\n💡 Use --clear to clear cache or --force-refresh to update data');
            }
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Error managing cache: ${error}`));
        }
    }
    async getAnalysis(months, forceRefresh) {
        // Check cache first
        if (!forceRefresh && await this.cache.isCacheValid()) {
            console.log(chalk_1.default.green('💾 Using cached data...'));
            const cached = await this.cache.loadPosts();
            if (cached?.analysis) {
                return cached.analysis;
            }
        }
        console.log(chalk_1.default.blue('🔄 Fetching fresh data from Hacker News...'));
        const posts = await this.hnService.fetchHiringPosts(months);
        const analysis = this.analyzer.analyzeTrends(posts);
        // Cache the results
        await this.cache.savePosts(posts, analysis);
        return analysis;
    }
    printAnalysisHeader(analysis) {
        console.log(`📅 Time range: ${chalk_1.default.cyan((0, date_fns_1.format)(analysis.timeRange.start, 'MMM yyyy'))} - ${chalk_1.default.cyan((0, date_fns_1.format)(analysis.timeRange.end, 'MMM yyyy'))}`);
        console.log(`📊 Total posts analyzed: ${chalk_1.default.cyan(analysis.totalPosts.toLocaleString())}`);
        console.log(`🔢 Technologies found: ${chalk_1.default.cyan(analysis.topTechnologies.length)}`);
        console.log('');
    }
    printTechnologyTable(technologies, title) {
        console.log(chalk_1.default.yellow.bold(`\n${title}`));
        const table = new cli_table3_1.default({
            head: ['Rank', 'Technology', 'Category', 'Mentions', 'Posts', '%'],
            style: { head: ['cyan'] }
        });
        const totalMentions = technologies.reduce((sum, tech) => sum + tech.count, 0);
        technologies.forEach((tech, index) => {
            const percentage = ((tech.count / totalMentions) * 100).toFixed(1);
            const categoryColor = this.getCategoryColor(tech.category);
            table.push([
                chalk_1.default.gray(`#${index + 1}`),
                chalk_1.default.bold(tech.name),
                categoryColor(tech.category),
                chalk_1.default.green(tech.count.toLocaleString()),
                chalk_1.default.blue(tech.posts.length.toLocaleString()),
                chalk_1.default.yellow(`${percentage}%`)
            ]);
        });
        console.log(table.toString());
    }
    printGrowthCharts(trends) {
        // Convert to chart data for trend chart
        const trendData = trends.map(trend => ({
            label: trend.technology,
            value: trend.growthRate,
            trend: trend.trend
        }));
        // Trend chart
        console.log(this.chartRenderer.renderTrendChart(trendData, {
            title: '📈 Technology Growth Trends',
            width: 50,
            maxItems: 15
        }));
        // Separate rising and declining charts
        const rising = trends.filter(t => t.trend === 'rising').slice(0, 10);
        const declining = trends.filter(t => t.trend === 'declining').slice(0, 10);
        if (rising.length > 0) {
            const risingData = rising.map(trend => ({
                label: trend.technology,
                value: trend.growthRate,
                color: 'green'
            }));
            console.log(this.chartRenderer.renderBarChart(risingData, {
                title: '🚀 Rising Technologies',
                width: 40,
                maxItems: 10,
                showValues: true
            }));
        }
        if (declining.length > 0) {
            const decliningData = declining.map(trend => ({
                label: trend.technology,
                value: Math.abs(trend.growthRate), // Use absolute value for display
                color: 'red'
            }));
            console.log(this.chartRenderer.renderBarChart(decliningData, {
                title: '📉 Declining Technologies',
                width: 40,
                maxItems: 10,
                showValues: true
            }));
        }
    }
    printGrowthTable(trends) {
        console.log(chalk_1.default.yellow.bold('\nGrowth Trends'));
        const table = new cli_table3_1.default({
            head: ['Technology', 'Category', 'Trend', 'Growth Rate', 'Confidence'],
            style: { head: ['cyan'] }
        });
        trends.forEach(trend => {
            const trendIcon = trend.trend === 'rising' ? '📈' : trend.trend === 'declining' ? '📉' : '📊';
            const growthColor = trend.growthRate > 0 ? chalk_1.default.green : chalk_1.default.red;
            const confidenceColor = trend.confidence > 0.7 ? chalk_1.default.green : trend.confidence > 0.4 ? chalk_1.default.yellow : chalk_1.default.red;
            table.push([
                chalk_1.default.bold(trend.technology),
                this.getCategoryColor(trend.category)(trend.category),
                `${trendIcon} ${trend.trend}`,
                growthColor(`${trend.growthRate > 0 ? '+' : ''}${trend.growthRate.toFixed(1)}%`),
                confidenceColor(`${(trend.confidence * 100).toFixed(0)}%`)
            ]);
        });
        console.log(table.toString());
    }
    printComparisonTable(technologies) {
        console.log(chalk_1.default.yellow.bold('\nDirect Comparison'));
        const table = new cli_table3_1.default({
            head: ['Technology', 'Mentions', 'Posts', 'Market Share'],
            style: { head: ['cyan'] }
        });
        const totalMentions = technologies.reduce((sum, tech) => sum + tech.count, 0);
        technologies.forEach(tech => {
            const percentage = ((tech.count / totalMentions) * 100).toFixed(1);
            table.push([
                chalk_1.default.bold(tech.name),
                chalk_1.default.green(tech.count.toLocaleString()),
                chalk_1.default.blue(tech.posts.length.toLocaleString()),
                chalk_1.default.yellow(`${percentage}%`)
            ]);
        });
        console.log(table.toString());
    }
    printTechnologyCharts(technologies) {
        // Convert to chart data
        const chartData = technologies.map(tech => ({
            label: tech.name,
            value: tech.count,
            color: this.getCategoryColor(tech.category)
        }));
        // Horizontal bar chart
        console.log(this.chartRenderer.renderBarChart(chartData, {
            title: '📊 Technology Mentions Distribution',
            width: 50,
            maxItems: 15,
            showValues: true,
            showPercentages: true
        }));
        // Pie chart for top 10
        const top10Data = chartData.slice(0, 10);
        console.log(this.chartRenderer.renderPieChart(top10Data, {
            title: '🥧 Top 10 Technologies Market Share',
            maxItems: 10
        }));
        // Category breakdown
        const categoryData = this.getCategoryBreakdown(technologies);
        console.log(this.chartRenderer.renderBarChart(categoryData, {
            title: '📂 Technology Categories',
            width: 40,
            showValues: true,
            showPercentages: true
        }));
    }
    getCategoryBreakdown(technologies) {
        const categories = new Map();
        technologies.forEach(tech => {
            const current = categories.get(tech.category) || 0;
            categories.set(tech.category, current + tech.count);
        });
        return Array.from(categories.entries()).map(([category, count]) => ({
            label: category.replace('_', ' ').toUpperCase(),
            value: count,
            color: this.getCategoryColor(category)
        }));
    }
    printLanguageCharts(languages) {
        // Convert to chart data
        const chartData = languages.map(lang => ({
            label: lang.name,
            value: lang.count,
            color: 'blue'
        }));
        // Horizontal bar chart
        console.log(this.chartRenderer.renderBarChart(chartData, {
            title: '💻 Programming Languages Popularity',
            width: 50,
            maxItems: 15,
            showValues: true,
            showPercentages: true
        }));
        // Pie chart
        console.log(this.chartRenderer.renderPieChart(chartData, {
            title: '🥧 Programming Languages Market Share',
            maxItems: 10
        }));
        // Vertical bar chart
        console.log(this.chartRenderer.renderVerticalBarChart(chartData.slice(0, 8), {
            title: '📊 Top 8 Programming Languages',
            height: 12,
            maxItems: 8
        }));
    }
    printLanguageDistribution(languages) {
        console.log(chalk_1.default.yellow.bold('\n📊 Language Distribution'));
        const totalMentions = languages.reduce((sum, lang) => sum + lang.count, 0);
        const maxBarLength = 40;
        languages.slice(0, 10).forEach(lang => {
            const percentage = (lang.count / totalMentions) * 100;
            const barLength = Math.round((percentage / 100) * maxBarLength);
            const bar = '█'.repeat(barLength) + '░'.repeat(maxBarLength - barLength);
            console.log(`${lang.name.padEnd(12)} │${chalk_1.default.blue(bar)}│ ${percentage.toFixed(1)}%`);
        });
    }
    printTimelineComparison(analysis, technologies) {
        console.log(chalk_1.default.yellow.bold('\n📈 Timeline Comparison'));
        console.log(chalk_1.default.dim('Showing trends over the analyzed period...'));
        // Group periods into quarters for cleaner display
        const quarters = this.groupByQuarters(analysis.periods);
        quarters.forEach(quarter => {
            console.log(`\n${chalk_1.default.cyan(quarter.label)}:`);
            technologies.forEach(tech => {
                const count = quarter.technologies[tech.name.toLowerCase()] || 0;
                const bar = '▓'.repeat(Math.min(count, 20));
                console.log(`  ${tech.name.padEnd(15)} ${chalk_1.default.blue(bar)} ${count}`);
            });
        });
    }
    groupByQuarters(periods) {
        // Simplified quarterly grouping for display
        const grouped = new Map();
        periods.forEach(period => {
            const quarter = `Q${Math.ceil((period.month + 1) / 3)} ${period.year}`;
            if (!grouped.has(quarter)) {
                grouped.set(quarter, { label: quarter, technologies: {} });
            }
            Object.entries(period.technologies).forEach(([, tech]) => {
                const techName = tech.name.toLowerCase();
                if (!grouped.get(quarter).technologies[techName]) {
                    grouped.get(quarter).technologies[techName] = 0;
                }
                grouped.get(quarter).technologies[techName] += tech.count;
            });
        });
        return Array.from(grouped.values());
    }
    getCategoryColor(category) {
        const colors = {
            'programming_language': chalk_1.default.blue,
            'framework': chalk_1.default.green,
            'database': chalk_1.default.magenta,
            'tool': chalk_1.default.yellow,
            'platform': chalk_1.default.cyan,
            'other': chalk_1.default.gray
        };
        return colors[category] || chalk_1.default.white;
    }
}
exports.TrendsCommand = TrendsCommand;
//# sourceMappingURL=TrendsCommand.js.map