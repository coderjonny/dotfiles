#!/usr/bin/env node

import { Command } from 'commander';
import chalk from 'chalk';
import { HackerNewsService } from './services/HackerNewsService';
import { TechnologyAnalyzer } from './services/TechnologyAnalyzer';
import { CacheStorage } from './storage/CacheStorage';
import { TrendsCommand } from './commands/TrendsCommand';

const program = new Command();

async function main() {
  try {
    // Initialize services
    const hnService = new HackerNewsService();
    const analyzer = new TechnologyAnalyzer();
    const cache = new CacheStorage();
    
    // Initialize storage
    await cache.initialize();

    // CLI Configuration
    program
      .name('hn-trends')
      .description('📈 Analyze technology trends from Hacker News hiring posts')
      .version('1.0.0');

    // Add banner
    console.log(chalk.blue.bold('\n🔥 HN Trends - Hacker News Technology Trend Analyzer'));
    console.log(chalk.dim('Analyzing programming language and technology trends from "Who is Hiring?" posts\n'));

    // Register commands
    const trendsCommand = new TrendsCommand(hnService, analyzer, cache);
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

  } catch (error) {
    console.error(chalk.red(`❌ Error: ${error}`));
    process.exit(1);
  }
}

async function quickAnalysis(
  hnService: HackerNewsService,
  analyzer: TechnologyAnalyzer,
  cache: CacheStorage
): Promise<void> {
  try {
    console.log(chalk.blue('🚀 Running quick trend analysis (last 12 months)...'));
    console.log(chalk.dim('━'.repeat(60)));
    
    // Check cache first
    let posts;
    if (await cache.isCacheValid()) {
      console.log(chalk.green('💾 Using cached data...'));
      const cached = await cache.loadPosts();
      posts = cached?.posts || [];
    } else {
      console.log(chalk.blue('🔄 Fetching data from Hacker News...'));
      posts = await hnService.fetchHiringPosts(12);
      await cache.savePosts(posts);
    }
    
    const analysis = analyzer.analyzeTrends(posts);
    
    // Show top 5 in each category
    const categories = analyzer.getCategories();
    
    console.log(chalk.yellow.bold('\n📊 Quick Trends Overview'));
    console.log(chalk.dim(`Based on ${analysis.totalPosts.toLocaleString()} hiring posts from ${analysis.timeRange.start.toLocaleDateString()} to ${analysis.timeRange.end.toLocaleDateString()}`));
    
    categories.forEach(category => {
      const techs = analysis.topTechnologies
        .filter(tech => tech.category === category)
        .slice(0, 5);
      
      if (techs.length > 0) {
        console.log(chalk.cyan(`\n${category.replace('_', ' ').toUpperCase()}:`));
        techs.forEach((tech, index) => {
          console.log(`  ${index + 1}. ${chalk.bold(tech.name)} (${chalk.green(tech.count)} mentions)`);
        });
      }
    });
    
    // Show top growth trends
    const topGrowth = analysis.growthTrends
      .filter(trend => trend.confidence > 0.3)
      .slice(0, 5);
    
    if (topGrowth.length > 0) {
      console.log(chalk.cyan('\nTOP GROWTH TRENDS:'));
      topGrowth.forEach(trend => {
        const icon = trend.trend === 'rising' ? '📈' : trend.trend === 'declining' ? '📉' : '📊';
        const color = trend.growthRate > 0 ? chalk.green : chalk.red;
        console.log(`  ${icon} ${chalk.bold(trend.technology)} ${color(`${trend.growthRate > 0 ? '+' : ''}${trend.growthRate.toFixed(1)}%`)}`);
      });
    }
    
    console.log(chalk.blue('\n💡 Use "hn-trends trends show" for detailed analysis'));
    console.log(chalk.blue('💡 Use "hn-trends trends languages" to focus on programming languages'));
    
  } catch (error) {
    console.error(chalk.red(`❌ Error in quick analysis: ${error}`));
  }
}

async function showStatus(cache: CacheStorage): Promise<void> {
  try {
    const status = await cache.getCacheStatus();
    const size = await cache.getCacheSize();
    
    console.log(chalk.blue.bold('\n📊 HN Trends Status'));
    console.log(chalk.dim('━'.repeat(40)));
    
    if (!status.exists) {
      console.log(chalk.yellow('📭 No data cached yet'));
      console.log(chalk.blue('💡 Run "hn-trends quick" to fetch data'));
    } else {
      console.log(`📦 Data cached: ${chalk.green('Yes')}`);
      console.log(`✅ Cache valid: ${status.valid ? chalk.green('Yes') : chalk.red('No')}`);
      console.log(`📅 Last update: ${chalk.cyan(status.lastFetch?.toLocaleString())}`);
      console.log(`📊 Posts cached: ${chalk.cyan(status.postsCount?.toLocaleString())}`);
      console.log(`⏰ Cache age: ${chalk.cyan(status.ageHours?.toFixed(1))} hours`);
      console.log(`💾 Cache size: ${chalk.cyan(cache.formatCacheSize(size))}`);
      
      if (!status.valid) {
        console.log(chalk.yellow('\n⚠️  Cache is stale, consider refreshing with --force-refresh'));
      }
    }
    
    console.log(chalk.blue('\n💡 Available commands:'));
    console.log('  • hn-trends quick           - Quick trend overview');
    console.log('  • hn-trends trends show     - Detailed trend analysis');
    console.log('  • hn-trends trends languages - Programming language trends');
    console.log('  • hn-trends trends growth   - Growth/decline trends');
    console.log('  • hn-trends trends compare  - Compare technologies');
    
  } catch (error) {
    console.error(chalk.red(`❌ Error showing status: ${error}`));
  }
}

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  console.error(chalk.red('❌ Unhandled Rejection at:'), promise, chalk.red('reason:'), reason);
  process.exit(1);
});

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error(chalk.red('❌ Uncaught Exception:'), error);
  process.exit(1);
});

// Handle SIGINT (Ctrl+C) gracefully
process.on('SIGINT', () => {
  console.log(chalk.yellow('\n👋 Goodbye! Thanks for using HN Trends!'));
  process.exit(0);
});

// Run the CLI
main();
