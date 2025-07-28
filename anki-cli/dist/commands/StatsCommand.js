"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StatsCommand = void 0;
const chalk_1 = __importDefault(require("chalk"));
const sm2_1 = require("../algorithms/sm2");
class StatsCommand {
    storage;
    constructor(storage) {
        this.storage = storage;
    }
    register(program) {
        program
            .command('stats')
            .description('📊 Show statistics and progress')
            .option('-d, --deck <deckId>', 'Show stats for specific deck')
            .option('--detailed', 'Show detailed statistics')
            .action(async (options) => {
            await this.showStats(options);
        });
    }
    async showStats(options) {
        try {
            const data = await this.storage.loadData();
            if (options.deck) {
                await this.showDeckStats(data, options.deck, options.detailed);
            }
            else {
                await this.showOverallStats(data, options.detailed);
            }
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Failed to show statistics: ${error}`));
        }
    }
    async showOverallStats(data, detailed) {
        const cards = data.cards;
        const decks = data.decks;
        const reviews = data.reviews;
        // Basic counts
        const totalCards = cards.length;
        const dueCards = cards.filter(sm2_1.isCardDue).length;
        const newCards = cards.filter((c) => c.totalReviews === 0).length;
        const masteredCards = cards.filter((c) => c.interval >= 21).length;
        const totalReviews = reviews.length;
        // Retention rate
        const retentionRate = (0, sm2_1.calculateRetentionRate)(cards);
        // Average ease factor
        const reviewedCards = cards.filter((c) => c.totalReviews > 0);
        const avgEaseFactor = reviewedCards.length > 0
            ? reviewedCards.reduce((sum, c) => sum + c.easeFactor, 0) / reviewedCards.length
            : 2.5;
        console.log(chalk_1.default.blue('📊 Anki CLI Statistics'));
        console.log(chalk_1.default.dim('━'.repeat(60)));
        // Cards overview
        console.log(chalk_1.default.bold('📚 Cards Overview'));
        console.log(`  Total cards: ${chalk_1.default.green(totalCards.toString())}`);
        console.log(`  Due for review: ${chalk_1.default.yellow(dueCards.toString())}`);
        console.log(`  New cards: ${chalk_1.default.cyan(newCards.toString())}`);
        console.log(`  Mastered: ${chalk_1.default.green(masteredCards.toString())} (${this.percentage(masteredCards, totalCards)}%)`);
        console.log('');
        // Decks overview
        console.log(chalk_1.default.bold('📂 Decks Overview'));
        console.log(`  Total decks: ${chalk_1.default.green(decks.length.toString())}`);
        decks.forEach((deck) => {
            const deckCards = cards.filter((c) => c.deckId === deck.id);
            const deckDue = deckCards.filter(sm2_1.isCardDue).length;
            console.log(`  • ${deck.name}: ${deckCards.length} cards (${deckDue} due)`);
        });
        console.log('');
        // Performance metrics
        console.log(chalk_1.default.bold('📈 Performance'));
        console.log(`  Total reviews: ${chalk_1.default.green(totalReviews.toString())}`);
        console.log(`  Retention rate: ${chalk_1.default.green(retentionRate.toFixed(1))}%`);
        console.log(`  Average ease: ${chalk_1.default.green(avgEaseFactor.toFixed(2))}`);
        console.log('');
        if (detailed) {
            await this.showDetailedStats(data);
        }
    }
    async showDeckStats(data, deckId, detailed) {
        const deck = data.decks.find((d) => d.id === deckId);
        if (!deck) {
            console.log(chalk_1.default.red(`❌ Deck '${deckId}' not found`));
            return;
        }
        const cards = data.cards.filter((c) => c.deckId === deckId);
        const reviews = data.reviews.filter((r) => cards.some((c) => c.id === r.cardId));
        const dueCards = cards.filter(sm2_1.isCardDue).length;
        const newCards = cards.filter((c) => c.totalReviews === 0).length;
        const masteredCards = cards.filter((c) => c.interval >= 21).length;
        const retentionRate = (0, sm2_1.calculateRetentionRate)(cards);
        console.log(chalk_1.default.blue(`📊 Statistics for "${deck.name}"`));
        console.log(chalk_1.default.dim('━'.repeat(60)));
        console.log(chalk_1.default.bold('📚 Deck Information'));
        console.log(`  Name: ${deck.name}`);
        if (deck.description) {
            console.log(`  Description: ${deck.description}`);
        }
        console.log(`  Created: ${deck.createdAt.toLocaleDateString()}`);
        console.log('');
        console.log(chalk_1.default.bold('📊 Card Statistics'));
        console.log(`  Total cards: ${chalk_1.default.green(cards.length.toString())}`);
        console.log(`  Due for review: ${chalk_1.default.yellow(dueCards.toString())}`);
        console.log(`  New cards: ${chalk_1.default.cyan(newCards.toString())}`);
        console.log(`  Mastered: ${chalk_1.default.green(masteredCards.toString())} (${this.percentage(masteredCards, cards.length)}%)`);
        console.log(`  Retention rate: ${chalk_1.default.green(retentionRate.toFixed(1))}%`);
        console.log(`  Total reviews: ${chalk_1.default.green(reviews.length.toString())}`);
        console.log('');
        if (detailed) {
            await this.showDeckDetailedStats(cards, reviews);
        }
    }
    async showDetailedStats(data) {
        const cards = data.cards;
        const reviews = data.reviews;
        console.log(chalk_1.default.bold('🔍 Detailed Statistics'));
        // Review distribution by rating
        const ratingCounts = [0, 0, 0, 0]; // Again, Hard, Good, Easy
        reviews.forEach((r) => {
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
        cards.forEach((c) => {
            if (c.interval === 1)
                intervalRanges['1 day']++;
            else if (c.interval <= 6)
                intervalRanges['2-6 days']++;
            else if (c.interval <= 21)
                intervalRanges['1-3 weeks']++;
            else
                intervalRanges['1+ months']++;
        });
        console.log('  Interval Distribution:');
        Object.entries(intervalRanges).forEach(([range, count]) => {
            console.log(`    ${range}: ${count} cards`);
        });
        console.log('');
        // Recent activity (last 7 days)
        const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
        const recentReviews = reviews.filter((r) => new Date(r.reviewedAt) >= sevenDaysAgo);
        console.log(`  Recent Activity (Last 7 days): ${recentReviews.length} reviews`);
        console.log('');
    }
    async showDeckDetailedStats(cards, reviews) {
        // Show top difficult cards (lowest ease factor)
        const difficultCards = cards
            .filter(c => c.totalReviews > 0)
            .sort((a, b) => a.easeFactor - b.easeFactor)
            .slice(0, 5);
        if (difficultCards.length > 0) {
            console.log(chalk_1.default.bold('🔥 Most Difficult Cards'));
            difficultCards.forEach((card, index) => {
                console.log(`  ${index + 1}. ${card.question.substring(0, 50)}${card.question.length > 50 ? '...' : ''}`);
                console.log(`     Ease: ${card.easeFactor.toFixed(2)}, Success: ${this.percentage(card.correctReviews, card.totalReviews)}%`);
            });
            console.log('');
        }
        // Show cards due soon
        const soonDue = cards
            .filter(c => c.nextReview && c.nextReview > new Date())
            .sort((a, b) => a.nextReview.getTime() - b.nextReview.getTime())
            .slice(0, 5);
        if (soonDue.length > 0) {
            console.log(chalk_1.default.bold('⏰ Due Soon'));
            soonDue.forEach((card, index) => {
                const daysUntil = Math.ceil((card.nextReview.getTime() - Date.now()) / (24 * 60 * 60 * 1000));
                console.log(`  ${index + 1}. ${card.question.substring(0, 50)}${card.question.length > 50 ? '...' : ''}`);
                console.log(`     Due in ${daysUntil} day${daysUntil !== 1 ? 's' : ''}`);
            });
            console.log('');
        }
    }
    percentage(part, total) {
        return total > 0 ? (part / total * 100).toFixed(1) : '0.0';
    }
}
exports.StatsCommand = StatsCommand;
//# sourceMappingURL=StatsCommand.js.map