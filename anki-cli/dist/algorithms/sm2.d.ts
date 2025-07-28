import { Card, ReviewRating } from '../models/Card';
export interface SM2Result {
    interval: number;
    repetitions: number;
    easeFactor: number;
    nextReview: Date;
}
/**
 * SuperMemo SM-2 Algorithm Implementation
 *
 * Based on the original algorithm by Piotr Wozniak:
 * https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
 *
 * @param card Current card state
 * @param rating User's rating of recall difficulty
 * @returns Updated scheduling parameters
 */
export declare function calculateSM2(card: Card, rating: ReviewRating): SM2Result;
/**
 * Calculate optimal study schedule for new cards
 */
export declare function getNewCardSchedule(): SM2Result;
/**
 * Determine if a card is due for review
 */
export declare function isCardDue(card: Card): boolean;
/**
 * Get cards that are due for review, sorted by priority
 */
export declare function getDueCards(cards: Card[]): Card[];
/**
 * Calculate retention rate for a set of cards
 */
export declare function calculateRetentionRate(cards: Card[]): number;
/**
 * Predict when all due cards will be completed
 */
export declare function estimateStudyTime(dueCards: Card[], averageTimePerCard?: number): number;
//# sourceMappingURL=sm2.d.ts.map