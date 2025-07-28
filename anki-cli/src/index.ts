#!/usr/bin/env node

import { Command } from 'commander';
import chalk from 'chalk';
import { AddCommand } from './commands/AddCommand';
import { ReviewCommand } from './commands/ReviewCommand';
import { ListCommand } from './commands/ListCommand';
import { StatsCommand } from './commands/StatsCommand';
import { FileStorage } from './storage/FileStorage';

const program = new Command();
const storage = new FileStorage();

async function main() {
  try {
    // Initialize storage
    await storage.initialize();

    // CLI Configuration
    program
      .name('anki-cli')
      .description('🧠 CLI flashcard application with spaced repetition')
      .version('1.0.0');

    // Add Commands
    const addCommand = new AddCommand(storage);
    const reviewCommand = new ReviewCommand(storage);
    const listCommand = new ListCommand(storage);
    const statsCommand = new StatsCommand(storage);

    // Register commands
    addCommand.register(program);
    reviewCommand.register(program);
    listCommand.register(program);
    statsCommand.register(program);

    // Parse arguments
    await program.parseAsync(process.argv);

  } catch (error) {
    console.error(chalk.red(`❌ Error: ${error}`));
    process.exit(1);
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

// Run the CLI
main(); 