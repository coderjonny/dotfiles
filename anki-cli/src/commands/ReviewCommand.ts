import { Command } from 'commander';
import inquirer from 'inquirer';
import chalk from 'chalk';
import { Card, ReviewRating, ReviewSession } from '../models/Card';
import { FileStorage } from '../storage/FileStorage';
import { calculateSM2, getDueCards } from '../algorithms/sm2';
import { randomUUID } from 'crypto';

export class ReviewCommand {
  constructor(private storage: FileStorage) {}

  register(program: Command): void {
    program
      .command('review')
      .description('📚 Start a review session')
      .option('-l, --limit <number>', 'Maximum number of cards to review', '20')
      .option('-d, --deck <deckId>', 'Review cards from specific deck only')
      .action(async (options) => {
        await this.startReview(options);
      });
  }

  private async startReview(options: any): Promise<void> {
    try {
      const data = await this.storage.loadData();
      const limit = parseInt(options.limit) || 20;
      
      let cardsToReview = getDueCards(data.cards);
      
      // Filter by deck if specified
      if (options.deck) {
        cardsToReview = cardsToReview.filter(card => card.deckId === options.deck);
      }
      
      // Limit cards
      cardsToReview = cardsToReview.slice(0, limit);
      
      if (cardsToReview.length === 0) {
        console.log(chalk.green('🎉 No cards due for review! Come back later.'));
        return;
      }
      
      console.log(chalk.blue(`📚 Starting review session: ${cardsToReview.length} cards`));
      console.log(chalk.dim('━'.repeat(60)));
      
      let reviewed = 0;
      const startTime = Date.now();
      
      for (const card of cardsToReview) {
        const cardStartTime = Date.now();
        
        // Show question
        console.log(`\n${chalk.bold(`Card ${reviewed + 1}/${cardsToReview.length}`)}`);
        console.log(chalk.cyan(`❓ ${card.question}`));
        
        // Wait for user to think
        await inquirer.prompt([
          {
            type: 'input',
            name: 'ready',
            message: 'Press Enter when ready to see the answer...'
          }
        ]);
        
        // Show answer
        console.log(chalk.green(`💡 ${card.answer}`));
        
        // Get difficulty rating
        const { rating } = await inquirer.prompt([
          {
            type: 'list',
            name: 'rating',
            message: 'How well did you know this?',
            choices: [
              { name: '1️⃣ Again (completely forgot)', value: ReviewRating.Again },
              { name: '2️⃣ Hard (difficult to recall)', value: ReviewRating.Hard },
              { name: '3️⃣ Good (recalled with effort)', value: ReviewRating.Good },
              { name: '4️⃣ Easy (perfect recall)', value: ReviewRating.Easy }
            ]
          }
        ]);
        
        const responseTime = Math.round((Date.now() - cardStartTime) / 1000);
        
        // Update card using SM-2 algorithm
        const newSchedule = calculateSM2(card, rating);
        const wasCorrect = rating >= ReviewRating.Good;
        
        await this.storage.updateCard(card.id, {
          easeFactor: newSchedule.easeFactor,
          interval: newSchedule.interval,
          repetitions: newSchedule.repetitions,
          lastReviewed: new Date(),
          nextReview: newSchedule.nextReview,
          totalReviews: card.totalReviews + 1,
          correctReviews: card.correctReviews + (wasCorrect ? 1 : 0),
          averageTime: card.averageTime 
            ? Math.round((card.averageTime + responseTime) / 2)
            : responseTime
        });
        
        // Record review session
        const review: ReviewSession = {
          cardId: card.id,
          rating,
          responseTime,
          reviewedAt: new Date()
        };
        await this.storage.addReview(review);
        
        // Show feedback
        this.showFeedback(rating, newSchedule.interval);
        
        reviewed++;
        
        // Ask if user wants to continue (every 5 cards)
        if (reviewed % 5 === 0 && reviewed < cardsToReview.length) {
          const { continue: shouldContinue } = await inquirer.prompt([
            {
              type: 'confirm',
              name: 'continue',
              message: `Continue reviewing? (${cardsToReview.length - reviewed} cards remaining)`,
              default: true
            }
          ]);
          
          if (!shouldContinue) {
            break;
          }
        }
      }
      
      // Show session summary
      const totalTime = Math.round((Date.now() - startTime) / 1000);
      console.log(chalk.dim('━'.repeat(60)));
      console.log(chalk.green(`✅ Review session complete!`));
      console.log(chalk.dim(`   Cards reviewed: ${reviewed}`));
      console.log(chalk.dim(`   Time taken: ${this.formatTime(totalTime)}`));
      console.log(chalk.dim(`   Average per card: ${Math.round(totalTime / reviewed)}s`));
      
    } catch (error) {
      console.error(chalk.red(`❌ Review session failed: ${error}`));
    }
  }
  
  private showFeedback(rating: ReviewRating, nextInterval: number): void {
    let emoji = '';
    let message = '';
    
    switch (rating) {
      case ReviewRating.Again:
        emoji = '🔄';
        message = 'You\'ll see this card again soon';
        break;
      case ReviewRating.Hard:
        emoji = '💪';
        message = `Next review in ${nextInterval} day${nextInterval > 1 ? 's' : ''}`;
        break;
      case ReviewRating.Good:
        emoji = '👍';
        message = `Next review in ${nextInterval} day${nextInterval > 1 ? 's' : ''}`;
        break;
      case ReviewRating.Easy:
        emoji = '🎯';
        message = `Next review in ${nextInterval} day${nextInterval > 1 ? 's' : ''}`;
        break;
    }
    
    console.log(chalk.dim(`${emoji} ${message}\n`));
  }
  
  private formatTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return `${minutes}m ${remainingSeconds}s`;
    }
    return `${remainingSeconds}s`;
  }
} 