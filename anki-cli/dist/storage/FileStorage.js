"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FileStorage = void 0;
const fs_1 = require("fs");
const path_1 = require("path");
const os_1 = require("os");
class FileStorage {
    dataDir;
    dataFile;
    backupDir;
    constructor() {
        this.dataDir = (0, path_1.join)((0, os_1.homedir)(), '.anki-cli');
        this.dataFile = (0, path_1.join)(this.dataDir, 'data.json');
        this.backupDir = (0, path_1.join)(this.dataDir, 'backups');
    }
    async initialize() {
        try {
            await fs_1.promises.mkdir(this.dataDir, { recursive: true });
            await fs_1.promises.mkdir(this.backupDir, { recursive: true });
            // Create initial data file if it doesn't exist
            try {
                await fs_1.promises.access(this.dataFile);
            }
            catch {
                await this.saveData({
                    cards: [],
                    decks: [],
                    reviews: [],
                    version: '1.0.0'
                });
            }
        }
        catch (error) {
            throw new Error(`Failed to initialize storage: ${error}`);
        }
    }
    async loadData() {
        try {
            const content = await fs_1.promises.readFile(this.dataFile, 'utf-8');
            const data = JSON.parse(content);
            // Convert date strings back to Date objects
            data.cards = data.cards.map(card => ({
                ...card,
                createdAt: new Date(card.createdAt),
                lastReviewed: card.lastReviewed ? new Date(card.lastReviewed) : undefined,
                nextReview: card.nextReview ? new Date(card.nextReview) : undefined
            }));
            data.decks = data.decks.map(deck => ({
                ...deck,
                createdAt: new Date(deck.createdAt),
                updatedAt: new Date(deck.updatedAt)
            }));
            data.reviews = data.reviews.map(review => ({
                ...review,
                reviewedAt: new Date(review.reviewedAt)
            }));
            return data;
        }
        catch (error) {
            throw new Error(`Failed to load data: ${error}`);
        }
    }
    async saveData(data) {
        try {
            // Create backup before saving
            await this.createBackup();
            // Atomic write using temporary file
            const tempFile = `${this.dataFile}.tmp`;
            const content = JSON.stringify(data, null, 2);
            await fs_1.promises.writeFile(tempFile, content, 'utf-8');
            await fs_1.promises.rename(tempFile, this.dataFile);
        }
        catch (error) {
            throw new Error(`Failed to save data: ${error}`);
        }
    }
    async createBackup() {
        try {
            const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
            const backupFile = (0, path_1.join)(this.backupDir, `data-${timestamp}.json`);
            try {
                await fs_1.promises.access(this.dataFile);
                await fs_1.promises.copyFile(this.dataFile, backupFile);
                // Keep only last 10 backups
                await this.cleanOldBackups();
            }
            catch {
                // Data file doesn't exist yet, skip backup
            }
        }
        catch (error) {
            console.warn(`Failed to create backup: ${error}`);
        }
    }
    async cleanOldBackups() {
        try {
            const files = await fs_1.promises.readdir(this.backupDir);
            const backupFiles = files
                .filter(file => file.startsWith('data-') && file.endsWith('.json'))
                .sort()
                .reverse();
            // Keep only the 10 most recent backups
            const filesToDelete = backupFiles.slice(10);
            for (const file of filesToDelete) {
                await fs_1.promises.unlink((0, path_1.join)(this.backupDir, file));
            }
        }
        catch (error) {
            console.warn(`Failed to clean old backups: ${error}`);
        }
    }
    // CRUD Operations
    async addCard(card) {
        const data = await this.loadData();
        data.cards.push(card);
        await this.saveData(data);
    }
    async updateCard(cardId, updates) {
        const data = await this.loadData();
        const cardIndex = data.cards.findIndex(c => c.id === cardId);
        if (cardIndex === -1) {
            throw new Error(`Card with ID ${cardId} not found`);
        }
        data.cards[cardIndex] = { ...data.cards[cardIndex], ...updates };
        await this.saveData(data);
    }
    async deleteCard(cardId) {
        const data = await this.loadData();
        data.cards = data.cards.filter(c => c.id !== cardId);
        await this.saveData(data);
    }
    async addDeck(deck) {
        const data = await this.loadData();
        data.decks.push(deck);
        await this.saveData(data);
    }
    async updateDeck(deckId, updates) {
        const data = await this.loadData();
        const deckIndex = data.decks.findIndex(d => d.id === deckId);
        if (deckIndex === -1) {
            throw new Error(`Deck with ID ${deckId} not found`);
        }
        data.decks[deckIndex] = { ...data.decks[deckIndex], ...updates };
        await this.saveData(data);
    }
    async addReview(review) {
        const data = await this.loadData();
        data.reviews.push(review);
        await this.saveData(data);
    }
    async getCardsByDeck(deckId) {
        const data = await this.loadData();
        return data.cards.filter(card => card.deckId === deckId);
    }
    async getDueCards() {
        const data = await this.loadData();
        const now = new Date();
        return data.cards.filter(card => !card.nextReview || card.nextReview <= now);
    }
}
exports.FileStorage = FileStorage;
//# sourceMappingURL=FileStorage.js.map