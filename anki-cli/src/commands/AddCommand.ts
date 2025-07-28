import { Command } from 'commander';
import inquirer from 'inquirer';
import chalk from 'chalk';
import { randomUUID } from 'crypto';
import { Card, Deck } from '../models/Card';
import { FileStorage } from '../storage/FileStorage';
import { getNewCardSchedule } from '../algorithms/sm2';

export class AddCommand {
  constructor(private storage: FileStorage) {}

  register(program: Command): void {
    const addCmd = program
      .command('add')
      .description('📝 Add new flashcards or decks');

    // Add card subcommand
    addCmd
      .command('card')
      .description('Add a new flashcard')
      .option('-d, --deck <deckId>', 'Deck ID to add card to')
      .option('-q, --question <question>', 'Question text')
      .option('-a, --answer <answer>', 'Answer text')
      .option('-t, --tags <tags>', 'Comma-separated tags')
      .action(async (options) => {
        await this.addCard(options);
      });

    // Add deck subcommand
    addCmd
      .command('deck')
      .description('Add a new deck')
      .option('-n, --name <name>', 'Deck name')
      .option('-d, --description <description>', 'Deck description')
      .action(async (options) => {
        await this.addDeck(options);
      });

    // Quick add (interactive)
    addCmd
      .command('quick')
      .description('Quick interactive card creation')
      .action(async () => {
        await this.quickAdd();
      });
  }

  private async addCard(options: any): Promise<void> {
    try {
      let { deck: deckId, question, answer, tags } = options;

      // Get available decks
      const data = await this.storage.loadData();
      
      if (data.decks.length === 0) {
        console.log(chalk.yellow('⚠️  No decks found. Creating default deck...'));
        await this.createDefaultDeck();
        deckId = 'default';
      }

      // Interactive prompts for missing data
      if (!deckId) {
        const deckChoices = data.decks.map(deck => ({
          name: `${deck.name} (${deck.totalCards} cards)`,
          value: deck.id
        }));

        const deckAnswer = await inquirer.prompt([
          {
            type: 'list',
            name: 'deckId',
            message: '📚 Select a deck:',
            choices: deckChoices
          }
        ]);
        deckId = deckAnswer.deckId;
      }

      if (!question || !answer) {
        const answers = await inquirer.prompt([
          {
            type: 'input',
            name: 'question',
            message: '❓ Question:',
            when: () => !question,
            validate: (input) => input.trim() !== '' || 'Question cannot be empty'
          },
          {
            type: 'input',
            name: 'answer',
            message: '💡 Answer:',
            when: () => !answer,
            validate: (input) => input.trim() !== '' || 'Answer cannot be empty'
          },
          {
            type: 'input',
            name: 'tags',
            message: '🏷️  Tags (comma-separated, optional):',
            when: () => !tags
          }
        ]);

        question = question || answers.question;
        answer = answer || answers.answer;
        tags = tags || answers.tags;
      }

      // Parse tags
      const tagArray = tags ? tags.split(',').map((tag: string) => tag.trim()).filter(Boolean) : [];

      // Create new card
      const schedule = getNewCardSchedule();
      const card: Card = {
        id: randomUUID(),
        question: question.trim(),
        answer: answer.trim(),
        tags: tagArray,
        deckId,
        easeFactor: schedule.easeFactor,
        interval: schedule.interval,
        repetitions: schedule.repetitions,
        createdAt: new Date(),
        nextReview: schedule.nextReview,
        totalReviews: 0,
        correctReviews: 0
      };

      // Save card
      await this.storage.addCard(card);

      // Update deck statistics
      const deck = data.decks.find(d => d.id === deckId);
      if (deck) {
        await this.storage.updateDeck(deckId, {
          totalCards: deck.totalCards + 1,
          newCards: deck.newCards + 1,
          updatedAt: new Date()
        });
      }

      console.log(chalk.green('✅ Card added successfully!'));
      console.log(chalk.dim(`   Question: ${question}`));
      console.log(chalk.dim(`   Answer: ${answer}`));
      if (tagArray.length > 0) {
        console.log(chalk.dim(`   Tags: ${tagArray.join(', ')}`));
      }

    } catch (error) {
      console.error(chalk.red(`❌ Failed to add card: ${error}`));
    }
  }

  private async addDeck(options: any): Promise<void> {
    try {
      let { name, description } = options;

      if (!name) {
        const answers = await inquirer.prompt([
          {
            type: 'input',
            name: 'name',
            message: '📚 Deck name:',
            validate: (input) => input.trim() !== '' || 'Deck name cannot be empty'
          },
          {
            type: 'input',
            name: 'description',
            message: '📄 Description (optional):'
          }
        ]);

        name = answers.name;
        description = answers.description;
      }

      const deck: Deck = {
        id: name.toLowerCase().replace(/\s+/g, '-'),
        name: name.trim(),
        description: description?.trim(),
        tags: [],
        createdAt: new Date(),
        updatedAt: new Date(),
        newCardsPerDay: 20,
        maxReviewsPerDay: 100,
        totalCards: 0,
        newCards: 0,
        dueCards: 0,
        masteredCards: 0
      };

      await this.storage.addDeck(deck);

      console.log(chalk.green('✅ Deck created successfully!'));
      console.log(chalk.dim(`   Name: ${name}`));
      if (description) {
        console.log(chalk.dim(`   Description: ${description}`));
      }

    } catch (error) {
      console.error(chalk.red(`❌ Failed to create deck: ${error}`));
    }
  }

  private async quickAdd(): Promise<void> {
    console.log(chalk.blue('🚀 Quick Card Creation'));
    
    const answers = await inquirer.prompt([
      {
        type: 'input',
        name: 'question',
        message: '❓ Question:',
        validate: (input) => input.trim() !== '' || 'Question cannot be empty'
      },
      {
        type: 'input',
        name: 'answer',
        message: '💡 Answer:',
        validate: (input) => input.trim() !== '' || 'Answer cannot be empty'
      },
      {
        type: 'input',
        name: 'tags',
        message: '🏷️  Tags (optional):'
      }
    ]);

    await this.addCard({
      question: answers.question,
      answer: answers.answer,
      tags: answers.tags
    });
  }

  private async createDefaultDeck(): Promise<void> {
    const defaultDeck: Deck = {
      id: 'default',
      name: 'Default Deck',
      description: 'Your first flashcard deck',
      tags: [],
      createdAt: new Date(),
      updatedAt: new Date(),
      newCardsPerDay: 20,
      maxReviewsPerDay: 100,
      totalCards: 0,
      newCards: 0,
      dueCards: 0,
      masteredCards: 0
    };

    await this.storage.addDeck(defaultDeck);
  }
} 