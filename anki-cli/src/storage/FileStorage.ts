import { promises as fs } from 'fs';
import { join } from 'path';
import { homedir } from 'os';
import { Card, Deck, ReviewSession } from '../models/Card';

export interface AppData {
  cards: Card[];
  decks: Deck[];
  reviews: ReviewSession[];
  version: string;
  lastBackup?: Date;
}

export class FileStorage {
  private readonly dataDir: string;
  private readonly dataFile: string;
  private readonly backupDir: string;

  constructor() {
    this.dataDir = join(homedir(), '.anki-cli');
    this.dataFile = join(this.dataDir, 'data.json');
    this.backupDir = join(this.dataDir, 'backups');
  }

  async initialize(): Promise<void> {
    try {
      await fs.mkdir(this.dataDir, { recursive: true });
      await fs.mkdir(this.backupDir, { recursive: true });
      
      // Create initial data file if it doesn't exist
      try {
        await fs.access(this.dataFile);
      } catch {
        await this.saveData({
          cards: [],
          decks: [],
          reviews: [],
          version: '1.0.0'
        });
      }
    } catch (error) {
      throw new Error(`Failed to initialize storage: ${error}`);
    }
  }

  async loadData(): Promise<AppData> {
    try {
      const content = await fs.readFile(this.dataFile, 'utf-8');
      const data = JSON.parse(content) as AppData;
      
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
    } catch (error) {
      throw new Error(`Failed to load data: ${error}`);
    }
  }

  async saveData(data: AppData): Promise<void> {
    try {
      // Create backup before saving
      await this.createBackup();
      
      // Atomic write using temporary file
      const tempFile = `${this.dataFile}.tmp`;
      const content = JSON.stringify(data, null, 2);
      
      await fs.writeFile(tempFile, content, 'utf-8');
      await fs.rename(tempFile, this.dataFile);
    } catch (error) {
      throw new Error(`Failed to save data: ${error}`);
    }
  }

  async createBackup(): Promise<void> {
    try {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const backupFile = join(this.backupDir, `data-${timestamp}.json`);
      
      try {
        await fs.access(this.dataFile);
        await fs.copyFile(this.dataFile, backupFile);
        
        // Keep only last 10 backups
        await this.cleanOldBackups();
      } catch {
        // Data file doesn't exist yet, skip backup
      }
    } catch (error) {
      console.warn(`Failed to create backup: ${error}`);
    }
  }

  private async cleanOldBackups(): Promise<void> {
    try {
      const files = await fs.readdir(this.backupDir);
      const backupFiles = files
        .filter(file => file.startsWith('data-') && file.endsWith('.json'))
        .sort()
        .reverse();
      
      // Keep only the 10 most recent backups
      const filesToDelete = backupFiles.slice(10);
      
      for (const file of filesToDelete) {
        await fs.unlink(join(this.backupDir, file));
      }
    } catch (error) {
      console.warn(`Failed to clean old backups: ${error}`);
    }
  }

  // CRUD Operations
  async addCard(card: Card): Promise<void> {
    const data = await this.loadData();
    data.cards.push(card);
    await this.saveData(data);
  }

  async updateCard(cardId: string, updates: Partial<Card>): Promise<void> {
    const data = await this.loadData();
    const cardIndex = data.cards.findIndex(c => c.id === cardId);
    
    if (cardIndex === -1) {
      throw new Error(`Card with ID ${cardId} not found`);
    }
    
    data.cards[cardIndex] = { ...data.cards[cardIndex], ...updates };
    await this.saveData(data);
  }

  async deleteCard(cardId: string): Promise<void> {
    const data = await this.loadData();
    data.cards = data.cards.filter(c => c.id !== cardId);
    await this.saveData(data);
  }

  async addDeck(deck: Deck): Promise<void> {
    const data = await this.loadData();
    data.decks.push(deck);
    await this.saveData(data);
  }

  async updateDeck(deckId: string, updates: Partial<Deck>): Promise<void> {
    const data = await this.loadData();
    const deckIndex = data.decks.findIndex(d => d.id === deckId);
    
    if (deckIndex === -1) {
      throw new Error(`Deck with ID ${deckId} not found`);
    }
    
    data.decks[deckIndex] = { ...data.decks[deckIndex], ...updates };
    await this.saveData(data);
  }

  async addReview(review: ReviewSession): Promise<void> {
    const data = await this.loadData();
    data.reviews.push(review);
    await this.saveData(data);
  }

  async getCardsByDeck(deckId: string): Promise<Card[]> {
    const data = await this.loadData();
    return data.cards.filter(card => card.deckId === deckId);
  }

  async getDueCards(): Promise<Card[]> {
    const data = await this.loadData();
    const now = new Date();
    
    return data.cards.filter(card => 
      !card.nextReview || card.nextReview <= now
    );
  }
} 