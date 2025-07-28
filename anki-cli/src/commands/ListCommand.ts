import { Command } from 'commander';
import chalk from 'chalk';
import { Card, Deck } from '../models/Card';
import { FileStorage } from '../storage/FileStorage';
import { isCardDue } from '../algorithms/sm2';

export class ListCommand {
  constructor(private storage: FileStorage) {}

  register(program: Command): void {
    const listCmd = program
      .command('list')
      .description('📋 List decks and cards');

    // List decks
    listCmd
      .command('decks')
      .description('List all decks')
      .action(async () => {
        await this.listDecks();
      });

    // List cards
    listCmd
      .command('cards')
      .description('List cards')
      .option('-d, --deck <deckId>', 'Filter by deck')
      .option('-t, --tag <tag>', 'Filter by tag')
      .option('--due', 'Show only due cards')
      .option('--new', 'Show only new cards')
      .action(async (options) => {
        await this.listCards(options);
      });

    // List due cards (shortcut)
    listCmd
      .command('due')
      .description('List cards due for review')
      .action(async () => {
        await this.listCards({ due: true });
      });
  }

  private async listDecks(): Promise<void> {
    try {
      const data = await this.storage.loadData();
      
      if (data.decks.length === 0) {
        console.log(chalk.yellow('📚 No decks found. Create one with: anki-cli add deck'));
        return;
      }
      
      console.log(chalk.blue('📚 Your Decks:'));
      console.log(chalk.dim('━'.repeat(80)));
      
      data.decks.forEach(deck => {
        const dueCards = data.cards.filter(card => 
          card.deckId === deck.id && isCardDue(card)
        ).length;
        
        console.log(`${chalk.bold(deck.name)} ${chalk.dim(`(${deck.id})`)}`);
        if (deck.description) {
          console.log(`  ${chalk.dim(deck.description)}`);
        }
        console.log(`  📊 ${deck.totalCards} total • ${dueCards} due • ${deck.masteredCards} mastered`);
        console.log(`  📅 Created: ${deck.createdAt.toLocaleDateString()}`);
        console.log('');
      });
      
    } catch (error) {
      console.error(chalk.red(`❌ Failed to list decks: ${error}`));
    }
  }

  private async listCards(options: any): Promise<void> {
    try {
      const data = await this.storage.loadData();
      let cards = data.cards;
      
      // Apply filters
      if (options.deck) {
        cards = cards.filter(card => card.deckId === options.deck);
      }
      
      if (options.tag) {
        cards = cards.filter(card => card.tags.includes(options.tag));
      }
      
      if (options.due) {
        cards = cards.filter(card => isCardDue(card));
      }
      
      if (options.new) {
        cards = cards.filter(card => card.totalReviews === 0);
      }
      
      if (cards.length === 0) {
        console.log(chalk.yellow('📝 No cards found matching your criteria.'));
        return;
      }
      
      console.log(chalk.blue(`📝 Cards (${cards.length} found):`));
      console.log(chalk.dim('━'.repeat(80)));
      
      cards.forEach((card, index) => {
        const deck = data.decks.find(d => d.id === card.deckId);
        const isDue = isCardDue(card);
        const status = this.getCardStatus(card);
        
        console.log(`${chalk.bold(`${index + 1}.`)} ${card.question}`);
        console.log(`   ${chalk.green('A:')} ${card.answer}`);
        console.log(`   ${chalk.dim(`Deck: ${deck?.name || 'Unknown'} • ${status} ${isDue ? '🔴' : '🟢'}`)}`);
        
        if (card.tags.length > 0) {
          console.log(`   ${chalk.dim(`Tags: ${card.tags.join(', ')}`)}`)
        }
        
        if (card.nextReview) {
          const nextReview = card.nextReview.toLocaleDateString();
          console.log(`   ${chalk.dim(`Next review: ${nextReview}`)}`);
        }
        
        console.log('');
      });
      
    } catch (error) {
      console.error(chalk.red(`❌ Failed to list cards: ${error}`));
    }
  }
  
  private getCardStatus(card: Card): string {
    if (card.totalReviews === 0) {
      return '🆕 New';
    }
    
    if (card.interval >= 21) {
      return '⭐ Mastered';
    }
    
    if (card.interval >= 7) {
      return '📈 Learning';
    }
    
    return '🔄 Review';
  }
} 