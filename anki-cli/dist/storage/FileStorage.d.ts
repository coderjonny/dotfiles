import { Card, Deck, ReviewSession } from '../models/Card';
export interface AppData {
    cards: Card[];
    decks: Deck[];
    reviews: ReviewSession[];
    version: string;
    lastBackup?: Date;
}
export declare class FileStorage {
    private readonly dataDir;
    private readonly dataFile;
    private readonly backupDir;
    constructor();
    initialize(): Promise<void>;
    loadData(): Promise<AppData>;
    saveData(data: AppData): Promise<void>;
    createBackup(): Promise<void>;
    private cleanOldBackups;
    addCard(card: Card): Promise<void>;
    updateCard(cardId: string, updates: Partial<Card>): Promise<void>;
    deleteCard(cardId: string): Promise<void>;
    addDeck(deck: Deck): Promise<void>;
    updateDeck(deckId: string, updates: Partial<Deck>): Promise<void>;
    addReview(review: ReviewSession): Promise<void>;
    getCardsByDeck(deckId: string): Promise<Card[]>;
    getDueCards(): Promise<Card[]>;
}
//# sourceMappingURL=FileStorage.d.ts.map