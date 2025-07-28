export interface Card {
    id: string;
    question: string;
    answer: string;
    tags: string[];
    deckId: string;
    easeFactor: number;
    interval: number;
    repetitions: number;
    createdAt: Date;
    lastReviewed?: Date;
    nextReview?: Date;
    totalReviews: number;
    correctReviews: number;
    averageTime?: number;
}
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
export interface ReviewSession {
    cardId: string;
    rating: ReviewRating;
    responseTime: number;
    reviewedAt: Date;
}
export declare enum ReviewRating {
    Again = 1,// Complete blackout, incorrect
    Hard = 2,// Incorrect but remembered with effort  
    Good = 3,// Correct with some effort
    Easy = 4
}
export interface CardStats {
    totalCards: number;
    dueCards: number;
    newCards: number;
    reviewCards: number;
    masteredCards: number;
    averageEaseFactor: number;
    retentionRate: number;
}
//# sourceMappingURL=Card.d.ts.map