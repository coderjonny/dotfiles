"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateSM2 = calculateSM2;
exports.getNewCardSchedule = getNewCardSchedule;
exports.isCardDue = isCardDue;
exports.getDueCards = getDueCards;
exports.calculateRetentionRate = calculateRetentionRate;
exports.estimateStudyTime = estimateStudyTime;
const Card_1 = require("../models/Card");
/**
 * Add days to a date
 */
function addDays(date, days) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
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
function calculateSM2(card, rating) {
    let { easeFactor, interval, repetitions } = card;
    // Apply the SM-2 algorithm
    if (rating >= Card_1.ReviewRating.Good) {
        // Successful recall
        repetitions += 1;
        if (repetitions === 1) {
            interval = 1;
        }
        else if (repetitions === 2) {
            interval = 6;
        }
        else {
            interval = Math.round(interval * easeFactor);
        }
    }
    else {
        // Failed recall - reset repetitions and set short interval
        repetitions = 0;
        interval = 1;
    }
    // Update ease factor based on rating
    easeFactor = easeFactor + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02));
    // Ensure minimum ease factor
    if (easeFactor < 1.3) {
        easeFactor = 1.3;
    }
    // Calculate next review date
    const nextReview = addDays(new Date(), interval);
    return {
        interval,
        repetitions,
        easeFactor,
        nextReview
    };
}
/**
 * Calculate optimal study schedule for new cards
 */
function getNewCardSchedule() {
    const nextReview = addDays(new Date(), 1); // Review tomorrow
    return {
        interval: 1,
        repetitions: 0,
        easeFactor: 2.5, // Default ease factor
        nextReview
    };
}
/**
 * Determine if a card is due for review
 */
function isCardDue(card) {
    if (!card.nextReview) {
        return true; // New card
    }
    return new Date() >= card.nextReview;
}
/**
 * Get cards that are due for review, sorted by priority
 */
function getDueCards(cards) {
    const now = new Date();
    return cards
        .filter(card => isCardDue(card))
        .sort((a, b) => {
        // Prioritize overdue cards first
        const aOverdue = a.nextReview ? now.getTime() - a.nextReview.getTime() : 0;
        const bOverdue = b.nextReview ? now.getTime() - b.nextReview.getTime() : 0;
        if (aOverdue !== bOverdue) {
            return bOverdue - aOverdue; // Most overdue first
        }
        // Then by ease factor (harder cards first)
        return a.easeFactor - b.easeFactor;
    });
}
/**
 * Calculate retention rate for a set of cards
 */
function calculateRetentionRate(cards) {
    const reviewedCards = cards.filter(card => card.totalReviews > 0);
    if (reviewedCards.length === 0) {
        return 0;
    }
    const totalCorrect = reviewedCards.reduce((sum, card) => sum + card.correctReviews, 0);
    const totalReviews = reviewedCards.reduce((sum, card) => sum + card.totalReviews, 0);
    return totalReviews > 0 ? (totalCorrect / totalReviews) * 100 : 0;
}
/**
 * Predict when all due cards will be completed
 */
function estimateStudyTime(dueCards, averageTimePerCard = 30) {
    return dueCards.length * averageTimePerCard; // in seconds
}
//# sourceMappingURL=sm2.js.map