import { Command } from 'commander';
import chalk from 'chalk';
import { Card, Deck } from '../models/Card';
import { FileStorage } from '../storage/FileStorage';
import { calculateRetentionRate, isCardDue } from '../algorithms/sm2';

export class StatsCommand {
  constructor(private storage: FileStorage) {}

  register(program: Command): void {
    program
      .command('stats')
      .description('📊 Show statistics and progress')
      .option('-d, --deck <deckId>', 'Show stats for specific deck')
      .option('--detailed', 'Show detailed statistics')
      .action(async (options) => {
        await this.showStats(options);
      });
  }

  private async showStats(options: any): Promise<void> {
    try {
      const data = await this.storage.loadData();
      
      if (options.deck) {
        await this.showDeckStats(data, options.deck, options.detailed);
      } else {
        await this.showOverallStats(data, options.detailed);
      }
      
    } catch (error) {
      console.error(chalk.red(`❌ Failed to show statistics: ${error}`));
    }
  }
  
  private async showOverallStats(data: any, detailed: boolean): Promise<void> {
    const cards = data.cards;
    const decks = data.decks;
    const reviews = data.reviews;
    
    // Basic counts
    const totalCards = cards.length;
    const dueCards = cards.filter(isCardDue).length;
    const newCards = cards.filter((c: Card) => c.totalReviews === 0).length;
    const masteredCards = cards.filter((c: Card) => c.interval >= 21).length;
    const totalReviews = reviews.length;
    
    // Retention rate
    const retentionRate = calculateRetentionRate(cards);
    
    // Average ease factor
    const reviewedCards = cards.filter((c: Card) => c.totalReviews > 0);
    const avgEaseFactor = reviewedCards.length > 0 
      ? reviewedCards.reduce((sum: number, c: Card) => sum + c.easeFactor, 0) / reviewedCards.length 
      : 2.5;
    
    console.log(chalk.blue('📊 Anki CLI Statistics'));
    console.log(chalk.dim('━'.repeat(60)));
    
    // Cards overview
    console.log(chalk.bold('📚 Cards Overview'));
    console.log(`  Total cards: ${chalk.green(totalCards.toString())}`);
    console.log(`  Due for review: ${chalk.yellow(dueCards.toString())}`);
    console.log(`  New cards: ${chalk.cyan(newCards.toString())}`);
    console.log(`  Mastered: ${chalk.green(masteredCards.toString())} (${this.percentage(masteredCards, totalCards)}%)`);
    console.log('');
    
    // Decks overview
    console.log(chalk.bold('📂 Decks Overview'));
    console.log(`  Total decks: ${chalk.green(decks.length.toString())}`);
    decks.forEach((deck: Deck) => {
      const deckCards = cards.filter((c: Card) => c.deckId === deck.id);
      const deckDue = deckCards.filter(isCardDue).length;
      console.log(`  • ${deck.name}: ${deckCards.length} cards (${deckDue} due)`);
    });
    console.log('');
    
    // Performance metrics
    console.log(chalk.bold('📈 Performance'));
    console.log(`  Total reviews: ${chalk.green(totalReviews.toString())}`);
    console.log(`  Retention rate: ${chalk.green(retentionRate.toFixed(1))}%`);
    console.log(`  Average ease: ${chalk.green(avgEaseFactor.toFixed(2))}`);
    console.log('');
    
    if (detailed) {
      await this.showDetailedStats(data);
    }
  }
  
  private async showDeckStats(data: any, deckId: string, detailed: boolean): Promise<void> {
    const deck = data.decks.find((d: Deck) => d.id === deckId);
    if (!deck) {
      console.log(chalk.red(`❌ Deck '${deckId}' not found`));
      return;
    }
    
    const cards = data.cards.filter((c: Card) => c.deckId === deckId);
    const reviews = data.reviews.filter((r: any) => 
      cards.some((c: Card) => c.id === r.cardId)
    );
    
    const dueCards = cards.filter(isCardDue).length;
    const newCards = cards.filter((c: Card) => c.totalReviews === 0).length;
    const masteredCards = cards.filter((c: Card) => c.interval >= 21).length;
    const retentionRate = calculateRetentionRate(cards);
    
    console.log(chalk.blue(`📊 Statistics for "${deck.name}"`));
    console.log(chalk.dim('━'.repeat(60)));
    
    console.log(chalk.bold('📚 Deck Information'));
    console.log(`  Name: ${deck.name}`);
    if (deck.description) {
      console.log(`  Description: ${deck.description}`);
    }
    console.log(`  Created: ${deck.createdAt.toLocaleDateString()}`);
    console.log('');
    
    console.log(chalk.bold('📊 Card Statistics'));
    console.log(`  Total cards: ${chalk.green(cards.length.toString())}`);
    console.log(`  Due for review: ${chalk.yellow(dueCards.toString())}`);
    console.log(`  New cards: ${chalk.cyan(newCards.toString())}`);
    console.log(`  Mastered: ${chalk.green(masteredCards.toString())} (${this.percentage(masteredCards, cards.length)}%)`);
    console.log(`  Retention rate: ${chalk.green(retentionRate.toFixed(1))}%`);
    console.log(`  Total reviews: ${chalk.green(reviews.length.toString())}`);
    console.log('');
    
    if (detailed) {
      await this.showDeckDetailedStats(cards, reviews);
    }
  }
  
  private async showDetailedStats(data: any): Promise<void> {
    const cards = data.cards;
    const reviews = data.reviews;
    
    console.log(chalk.bold('🔍 Detailed Statistics'));
    
    // Review distribution by rating
    const ratingCounts = [0, 0, 0, 0]; // Again, Hard, Good, Easy
    reviews.forEach((r: any) => {
      if (r.rating >= 1 && r.rating <= 4) {
        ratingCounts[r.rating - 1]++;
      }
    });
    
    console.log('  Review Distribution:');
    console.log(`    Again: ${ratingCounts[0]} (${this.percentage(ratingCounts[0], reviews.length)}%)`);
    console.log(`    Hard: ${ratingCounts[1]} (${this.percentage(ratingCounts[1], reviews.length)}%)`);
    console.log(`    Good: ${ratingCounts[2]} (${this.percentage(ratingCounts[2], reviews.length)}%)`);
    console.log(`    Easy: ${ratingCounts[3]} (${this.percentage(ratingCounts[3], reviews.length)}%)`);
    console.log('');
    
    // Interval distribution
    const intervalRanges = {
      '1 day': 0,
      '2-6 days': 0,
      '1-3 weeks': 0,
      '1+ months': 0
    };
    
    cards.forEach((c: Card) => {
      if (c.interval === 1) intervalRanges['1 day']++;
      else if (c.interval <= 6) intervalRanges['2-6 days']++;
      else if (c.interval <= 21) intervalRanges['1-3 weeks']++;
      else intervalRanges['1+ months']++;
    });
    
    console.log('  Interval Distribution:');
    Object.entries(intervalRanges).forEach(([range, count]) => {
      console.log(`    ${range}: ${count} cards`);
    });
    console.log('');
    
    // Recent activity (last 7 days)
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
    const recentReviews = reviews.filter((r: any) => 
      new Date(r.reviewedAt) >= sevenDaysAgo
    );
    
    console.log(`  Recent Activity (Last 7 days): ${recentReviews.length} reviews`);
    console.log('');
  }
  
  private async showDeckDetailedStats(cards: Card[], reviews: any[]): Promise<void> {
    // Show top difficult cards (lowest ease factor)
    const difficultCards = cards
      .filter(c => c.totalReviews > 0)
      .sort((a, b) => a.easeFactor - b.easeFactor)
      .slice(0, 5);
    
    if (difficultCards.length > 0) {
      console.log(chalk.bold('🔥 Most Difficult Cards'));
      difficultCards.forEach((card, index) => {
        console.log(`  ${index + 1}. ${card.question.substring(0, 50)}${card.question.length > 50 ? '...' : ''}`);
        console.log(`     Ease: ${card.easeFactor.toFixed(2)}, Success: ${this.percentage(card.correctReviews, card.totalReviews)}%`);
      });
      console.log('');
    }
    
    // Show cards due soon
    const soonDue = cards
      .filter(c => c.nextReview && c.nextReview > new Date())
      .sort((a, b) => a.nextReview!.getTime() - b.nextReview!.getTime())
      .slice(0, 5);
    
    if (soonDue.length > 0) {
      console.log(chalk.bold('⏰ Due Soon'));
      soonDue.forEach((card, index) => {
        const daysUntil = Math.ceil((card.nextReview!.getTime() - Date.now()) / (24 * 60 * 60 * 1000));
        console.log(`  ${index + 1}. ${card.question.substring(0, 50)}${card.question.length > 50 ? '...' : ''}`);
        console.log(`     Due in ${daysUntil} day${daysUntil !== 1 ? 's' : ''}`);
      });
      console.log('');
    }
  }
  
  private percentage(part: number, total: number): string {
    return total > 0 ? (part / total * 100).toFixed(1) : '0.0';
  }
} 