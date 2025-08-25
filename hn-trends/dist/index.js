#!/usr/bin/env node
"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const commander_1 = require("commander");
const chalk_1 = __importDefault(require("chalk"));
const HackerNewsService_1 = require("./services/HackerNewsService");
const TechnologyAnalyzer_1 = require("./services/TechnologyAnalyzer");
const CacheStorage_1 = require("./storage/CacheStorage");
const TrendsCommand_1 = require("./commands/TrendsCommand");
const program = new commander_1.Command();
async function main() {
    try {
        // Initialize services
        const hnService = new HackerNewsService_1.HackerNewsService();
        const analyzer = new TechnologyAnalyzer_1.TechnologyAnalyzer();
        const cache = new CacheStorage_1.CacheStorage();
        // Initialize storage
        await cache.initialize();
        // CLI Configuration
        program
            .name('hn-trends')
            .description('📈 Analyze technology trends from Hacker News hiring posts')
            .version('1.0.0');
        // Add banner
        console.log(chalk_1.default.blue.bold('\n🔥 HN Trends - Hacker News Technology Trend Analyzer'));
        console.log(chalk_1.default.dim('Analyzing programming language and technology trends from "Who is Hiring?" posts\n'));
        // Register commands
        const trendsCommand = new TrendsCommand_1.TrendsCommand(hnService, analyzer, cache);
        trendsCommand.register(program);
        // Add some helpful standalone commands
        program
            .command('quick')
            .description('🚀 Quick overview of current trends (last 12 months)')
            .action(async () => {
            await quickAnalysis(hnService, analyzer, cache);
        });
        program
            .command('status')
            .description('📊 Show cache status and basic info')
            .action(async () => {
            await showStatus(cache);
        });
        // Show help if no arguments provided
        if (process.argv.length <= 2) {
            program.help();
        }
        // Parse arguments
        await program.parseAsync(process.argv);
    }
    catch (error) {
        console.error(chalk_1.default.red(`❌ Error: ${error}`));
        process.exit(1);
    }
}
async function quickAnalysis(hnService, analyzer, cache) {
    try {
        console.log(chalk_1.default.blue('🚀 Running quick trend analysis (last 12 months)...'));
        console.log(chalk_1.default.dim('━'.repeat(60)));
        // Check cache first
        let posts;
        if (await cache.isCacheValid()) {
            console.log(chalk_1.default.green('💾 Using cached data...'));
            const cached = await cache.loadPosts();
            posts = cached?.posts || [];
        }
        else {
            console.log(chalk_1.default.blue('🔄 Fetching data from Hacker News...'));
            posts = await hnService.fetchHiringPosts(12);
            await cache.savePosts(posts);
        }
        const analysis = analyzer.analyzeTrends(posts);
        // Show top 5 in each category
        const categories = analyzer.getCategories();
        console.log(chalk_1.default.yellow.bold('\n📊 Quick Trends Overview'));
        console.log(chalk_1.default.dim(`Based on ${analysis.totalPosts.toLocaleString()} hiring posts from ${analysis.timeRange.start.toLocaleDateString()} to ${analysis.timeRange.end.toLocaleDateString()}`));
        categories.forEach(category => {
            const techs = analysis.topTechnologies
                .filter(tech => tech.category === category)
                .slice(0, 5);
            if (techs.length > 0) {
                console.log(chalk_1.default.cyan(`\n${category.replace('_', ' ').toUpperCase()}:`));
                techs.forEach((tech, index) => {
                    console.log(`  ${index + 1}. ${chalk_1.default.bold(tech.name)} (${chalk_1.default.green(tech.count)} mentions)`);
                });
            }
        });
        // Show top growth trends
        const topGrowth = analysis.growthTrends
            .filter(trend => trend.confidence > 0.3)
            .slice(0, 5);
        if (topGrowth.length > 0) {
            console.log(chalk_1.default.cyan('\nTOP GROWTH TRENDS:'));
            topGrowth.forEach(trend => {
                const icon = trend.trend === 'rising' ? '📈' : trend.trend === 'declining' ? '📉' : '📊';
                const color = trend.growthRate > 0 ? chalk_1.default.green : chalk_1.default.red;
                console.log(`  ${icon} ${chalk_1.default.bold(trend.technology)} ${color(`${trend.growthRate > 0 ? '+' : ''}${trend.growthRate.toFixed(1)}%`)}`);
            });
        }
        console.log(chalk_1.default.blue('\n💡 Use "hn-trends trends show" for detailed analysis'));
        console.log(chalk_1.default.blue('💡 Use "hn-trends trends languages" to focus on programming languages'));
    }
    catch (error) {
        console.error(chalk_1.default.red(`❌ Error in quick analysis: ${error}`));
    }
}
async function showStatus(cache) {
    try {
        const status = await cache.getCacheStatus();
        const size = await cache.getCacheSize();
        console.log(chalk_1.default.blue.bold('\n📊 HN Trends Status'));
        console.log(chalk_1.default.dim('━'.repeat(40)));
        if (!status.exists) {
            console.log(chalk_1.default.yellow('📭 No data cached yet'));
            console.log(chalk_1.default.blue('💡 Run "hn-trends quick" to fetch data'));
        }
        else {
            console.log(`📦 Data cached: ${chalk_1.default.green('Yes')}`);
            console.log(`✅ Cache valid: ${status.valid ? chalk_1.default.green('Yes') : chalk_1.default.red('No')}`);
            console.log(`📅 Last update: ${chalk_1.default.cyan(status.lastFetch?.toLocaleString())}`);
            console.log(`📊 Posts cached: ${chalk_1.default.cyan(status.postsCount?.toLocaleString())}`);
            console.log(`⏰ Cache age: ${chalk_1.default.cyan(status.ageHours?.toFixed(1))} hours`);
            console.log(`💾 Cache size: ${chalk_1.default.cyan(cache.formatCacheSize(size))}`);
            if (!status.valid) {
                console.log(chalk_1.default.yellow('\n⚠️  Cache is stale, consider refreshing with --force-refresh'));
            }
        }
        console.log(chalk_1.default.blue('\n💡 Available commands:'));
        console.log('  • hn-trends quick           - Quick trend overview');
        console.log('  • hn-trends trends show     - Detailed trend analysis');
        console.log('  • hn-trends trends languages - Programming language trends');
        console.log('  • hn-trends trends growth   - Growth/decline trends');
        console.log('  • hn-trends trends compare  - Compare technologies');
    }
    catch (error) {
        console.error(chalk_1.default.red(`❌ Error showing status: ${error}`));
    }
}
// Handle unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
    console.error(chalk_1.default.red('❌ Unhandled Rejection at:'), promise, chalk_1.default.red('reason:'), reason);
    process.exit(1);
});
// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
    console.error(chalk_1.default.red('❌ Uncaught Exception:'), error);
    process.exit(1);
});
// Handle SIGINT (Ctrl+C) gracefully
process.on('SIGINT', () => {
    console.log(chalk_1.default.yellow('\n👋 Goodbye! Thanks for using HN Trends!'));
    process.exit(0);
});
// Run the CLI
main();
//# sourceMappingURL=index.js.map