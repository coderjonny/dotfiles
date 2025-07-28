"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReviewCommand = void 0;
const inquirer_1 = __importDefault(require("inquirer"));
const chalk_1 = __importDefault(require("chalk"));
const Card_1 = require("../models/Card");
const sm2_1 = require("../algorithms/sm2");
class ReviewCommand {
    storage;
    constructor(storage) {
        this.storage = storage;
    }
    register(program) {
        program
            .command('review')
            .description('📚 Start a review session')
            .option('-l, --limit <number>', 'Maximum number of cards to review', '20')
            .option('-d, --deck <deckId>', 'Review cards from specific deck only')
            .action(async (options) => {
            await this.startReview(options);
        });
    }
    async startReview(options) {
        try {
            const data = await this.storage.loadData();
            const limit = parseInt(options.limit) || 20;
            let cardsToReview = (0, sm2_1.getDueCards)(data.cards);
            // Filter by deck if specified
            if (options.deck) {
                cardsToReview = cardsToReview.filter(card => card.deckId === options.deck);
            }
            // Limit cards
            cardsToReview = cardsToReview.slice(0, limit);
            if (cardsToReview.length === 0) {
                console.log(chalk_1.default.green('🎉 No cards due for review! Come back later.'));
                return;
            }
            console.log(chalk_1.default.blue(`📚 Starting review session: ${cardsToReview.length} cards`));
            console.log(chalk_1.default.dim('━'.repeat(60)));
            let reviewed = 0;
            const startTime = Date.now();
            for (const card of cardsToReview) {
                const cardStartTime = Date.now();
                // Show question
                console.log(`\n${chalk_1.default.bold(`Card ${reviewed + 1}/${cardsToReview.length}`)}`);
                console.log(chalk_1.default.cyan(`❓ ${card.question}`));
                // Wait for user to think
                await inquirer_1.default.prompt([
                    {
                        type: 'input',
                        name: 'ready',
                        message: 'Press Enter when ready to see the answer...'
                    }
                ]);
                // Show answer
                console.log(chalk_1.default.green(`💡 ${card.answer}`));
                // Get difficulty rating
                const { rating } = await inquirer_1.default.prompt([
                    {
                        type: 'list',
                        name: 'rating',
                        message: 'How well did you know this?',
                        choices: [
                            { name: '1️⃣ Again (completely forgot)', value: Card_1.ReviewRating.Again },
                            { name: '2️⃣ Hard (difficult to recall)', value: Card_1.ReviewRating.Hard },
                            { name: '3️⃣ Good (recalled with effort)', value: Card_1.ReviewRating.Good },
                            { name: '4️⃣ Easy (perfect recall)', value: Card_1.ReviewRating.Easy }
                        ]
                    }
                ]);
                const responseTime = Math.round((Date.now() - cardStartTime) / 1000);
                // Update card using SM-2 algorithm
                const newSchedule = (0, sm2_1.calculateSM2)(card, rating);
                const wasCorrect = rating >= Card_1.ReviewRating.Good;
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
                const review = {
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
                    const { continue: shouldContinue } = await inquirer_1.default.prompt([
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
            console.log(chalk_1.default.dim('━'.repeat(60)));
            console.log(chalk_1.default.green(`✅ Review session complete!`));
            console.log(chalk_1.default.dim(`   Cards reviewed: ${reviewed}`));
            console.log(chalk_1.default.dim(`   Time taken: ${this.formatTime(totalTime)}`));
            console.log(chalk_1.default.dim(`   Average per card: ${Math.round(totalTime / reviewed)}s`));
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Review session failed: ${error}`));
        }
    }
    showFeedback(rating, nextInterval) {
        let emoji = '';
        let message = '';
        switch (rating) {
            case Card_1.ReviewRating.Again:
                emoji = '🔄';
                message = 'You\'ll see this card again soon';
                break;
            case Card_1.ReviewRating.Hard:
                emoji = '💪';
                message = `Next review in ${nextInterval} day${nextInterval > 1 ? 's' : ''}`;
                break;
            case Card_1.ReviewRating.Good:
                emoji = '👍';
                message = `Next review in ${nextInterval} day${nextInterval > 1 ? 's' : ''}`;
                break;
            case Card_1.ReviewRating.Easy:
                emoji = '🎯';
                message = `Next review in ${nextInterval} day${nextInterval > 1 ? 's' : ''}`;
                break;
        }
        console.log(chalk_1.default.dim(`${emoji} ${message}\n`));
    }
    formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        if (minutes > 0) {
            return `${minutes}m ${remainingSeconds}s`;
        }
        return `${remainingSeconds}s`;
    }
}
exports.ReviewCommand = ReviewCommand;
//# sourceMappingURL=ReviewCommand.js.map