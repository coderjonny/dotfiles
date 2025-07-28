"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ListCommand = void 0;
const chalk_1 = __importDefault(require("chalk"));
const sm2_1 = require("../algorithms/sm2");
class ListCommand {
    storage;
    constructor(storage) {
        this.storage = storage;
    }
    register(program) {
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
    async listDecks() {
        try {
            const data = await this.storage.loadData();
            if (data.decks.length === 0) {
                console.log(chalk_1.default.yellow('📚 No decks found. Create one with: anki-cli add deck'));
                return;
            }
            console.log(chalk_1.default.blue('📚 Your Decks:'));
            console.log(chalk_1.default.dim('━'.repeat(80)));
            data.decks.forEach(deck => {
                const dueCards = data.cards.filter(card => card.deckId === deck.id && (0, sm2_1.isCardDue)(card)).length;
                console.log(`${chalk_1.default.bold(deck.name)} ${chalk_1.default.dim(`(${deck.id})`)}`);
                if (deck.description) {
                    console.log(`  ${chalk_1.default.dim(deck.description)}`);
                }
                console.log(`  📊 ${deck.totalCards} total • ${dueCards} due • ${deck.masteredCards} mastered`);
                console.log(`  📅 Created: ${deck.createdAt.toLocaleDateString()}`);
                console.log('');
            });
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Failed to list decks: ${error}`));
        }
    }
    async listCards(options) {
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
                cards = cards.filter(card => (0, sm2_1.isCardDue)(card));
            }
            if (options.new) {
                cards = cards.filter(card => card.totalReviews === 0);
            }
            if (cards.length === 0) {
                console.log(chalk_1.default.yellow('📝 No cards found matching your criteria.'));
                return;
            }
            console.log(chalk_1.default.blue(`📝 Cards (${cards.length} found):`));
            console.log(chalk_1.default.dim('━'.repeat(80)));
            cards.forEach((card, index) => {
                const deck = data.decks.find(d => d.id === card.deckId);
                const isDue = (0, sm2_1.isCardDue)(card);
                const status = this.getCardStatus(card);
                console.log(`${chalk_1.default.bold(`${index + 1}.`)} ${card.question}`);
                console.log(`   ${chalk_1.default.green('A:')} ${card.answer}`);
                console.log(`   ${chalk_1.default.dim(`Deck: ${deck?.name || 'Unknown'} • ${status} ${isDue ? '🔴' : '🟢'}`)}`);
                if (card.tags.length > 0) {
                    console.log(`   ${chalk_1.default.dim(`Tags: ${card.tags.join(', ')}`)}`);
                }
                if (card.nextReview) {
                    const nextReview = card.nextReview.toLocaleDateString();
                    console.log(`   ${chalk_1.default.dim(`Next review: ${nextReview}`)}`);
                }
                console.log('');
            });
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Failed to list cards: ${error}`));
        }
    }
    getCardStatus(card) {
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
exports.ListCommand = ListCommand;
//# sourceMappingURL=ListCommand.js.map