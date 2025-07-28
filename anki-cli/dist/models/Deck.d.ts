export interface Deck {
    id: string;
    name: string;
    description?: string;
    tags: string[];
    createdAt: Date;
    updatedAt: Date;
    newCardsPerDay: number;
    maxReviewsPerDay: number;
    totalCards: number;
    newCards: number;
    dueCards: number;
    masteredCards: number;
}
export interface DeckSettings {
    learningSteps: number[];
    graduatingInterval: number;
    easyInterval: number;
    maximumInterval: number;
    startingEase: number;
    easyBonus: number;
    intervalModifier: number;
    relearningSteps: number[];
    minimumInterval: number;
    leechThreshold: number;
}
//# sourceMappingURL=Deck.d.ts.map