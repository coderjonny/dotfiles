#!/usr/bin/env node
"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const commander_1 = require("commander");
const chalk_1 = __importDefault(require("chalk"));
const AddCommand_1 = require("./commands/AddCommand");
const ReviewCommand_1 = require("./commands/ReviewCommand");
const ListCommand_1 = require("./commands/ListCommand");
const StatsCommand_1 = require("./commands/StatsCommand");
const FileStorage_1 = require("./storage/FileStorage");
const program = new commander_1.Command();
const storage = new FileStorage_1.FileStorage();
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
        const addCommand = new AddCommand_1.AddCommand(storage);
        const reviewCommand = new ReviewCommand_1.ReviewCommand(storage);
        const listCommand = new ListCommand_1.ListCommand(storage);
        const statsCommand = new StatsCommand_1.StatsCommand(storage);
        // Register commands
        addCommand.register(program);
        reviewCommand.register(program);
        listCommand.register(program);
        statsCommand.register(program);
        // Parse arguments
        await program.parseAsync(process.argv);
    }
    catch (error) {
        console.error(chalk_1.default.red(`❌ Error: ${error}`));
        process.exit(1);
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
// Run the CLI
main();
//# sourceMappingURL=index.js.map