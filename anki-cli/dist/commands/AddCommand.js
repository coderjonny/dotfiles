"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AddCommand = void 0;
const inquirer_1 = __importDefault(require("inquirer"));
const chalk_1 = __importDefault(require("chalk"));
const crypto_1 = require("crypto");
const sm2_1 = require("../algorithms/sm2");
class AddCommand {
    storage;
    constructor(storage) {
        this.storage = storage;
    }
    register(program) {
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
    async addCard(options) {
        try {
            let { deck: deckId, question, answer, tags } = options;
            // Get available decks
            const data = await this.storage.loadData();
            if (data.decks.length === 0) {
                console.log(chalk_1.default.yellow('⚠️  No decks found. Creating default deck...'));
                await this.createDefaultDeck();
                deckId = 'default';
            }
            // Interactive prompts for missing data
            if (!deckId) {
                const deckChoices = data.decks.map(deck => ({
                    name: `${deck.name} (${deck.totalCards} cards)`,
                    value: deck.id
                }));
                const deckAnswer = await inquirer_1.default.prompt([
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
                const answers = await inquirer_1.default.prompt([
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
            const tagArray = tags ? tags.split(',').map((tag) => tag.trim()).filter(Boolean) : [];
            // Create new card
            const schedule = (0, sm2_1.getNewCardSchedule)();
            const card = {
                id: (0, crypto_1.randomUUID)(),
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
            console.log(chalk_1.default.green('✅ Card added successfully!'));
            console.log(chalk_1.default.dim(`   Question: ${question}`));
            console.log(chalk_1.default.dim(`   Answer: ${answer}`));
            if (tagArray.length > 0) {
                console.log(chalk_1.default.dim(`   Tags: ${tagArray.join(', ')}`));
            }
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Failed to add card: ${error}`));
        }
    }
    async addDeck(options) {
        try {
            let { name, description } = options;
            if (!name) {
                const answers = await inquirer_1.default.prompt([
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
            const deck = {
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
            console.log(chalk_1.default.green('✅ Deck created successfully!'));
            console.log(chalk_1.default.dim(`   Name: ${name}`));
            if (description) {
                console.log(chalk_1.default.dim(`   Description: ${description}`));
            }
        }
        catch (error) {
            console.error(chalk_1.default.red(`❌ Failed to create deck: ${error}`));
        }
    }
    async quickAdd() {
        console.log(chalk_1.default.blue('🚀 Quick Card Creation'));
        const answers = await inquirer_1.default.prompt([
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
    async createDefaultDeck() {
        const defaultDeck = {
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
exports.AddCommand = AddCommand;
//# sourceMappingURL=AddCommand.js.map