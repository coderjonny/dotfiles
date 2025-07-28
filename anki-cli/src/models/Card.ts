export interface Card {
  id: string;
  question: string;
  answer: string;
  tags: string[];
  deckId: string;
  
  // Spaced repetition data (SuperMemo SM-2)
  easeFactor: number;      // 2.5 default, min 1.3
  interval: number;        // Days until next review
  repetitions: number;     // Number of successful reviews
  
  // Review tracking
  createdAt: Date;
  lastReviewed?: Date;
  nextReview?: Date;
  
  // Statistics
  totalReviews: number;
  correctReviews: number;
  averageTime?: number;    // Average response time in seconds
}

export interface Deck {
  id: string;
  name: string;
  description?: string;
  tags: string[];
  
  // Metadata
  createdAt: Date;
  updatedAt: Date;
  
  // Settings
  newCardsPerDay: number;
  maxReviewsPerDay: number;
  
  // Statistics
  totalCards: number;
  newCards: number;
  dueCards: number;
  masteredCards: number;
}

export interface ReviewSession {
  cardId: string;
  rating: ReviewRating;
  responseTime: number;    // Time taken to answer in seconds
  reviewedAt: Date;
}

export enum ReviewRating {
  Again = 1,    // Complete blackout, incorrect
  Hard = 2,     // Incorrect but remembered with effort  
  Good = 3,     // Correct with some effort
  Easy = 4      // Perfect recall, effortless
}

export interface CardStats {
  totalCards: number;
  dueCards: number;
  newCards: number;
  reviewCards: number;
  masteredCards: number;   // Cards with interval >= 21 days
  averageEaseFactor: number;
  retentionRate: number;   // Percentage of correct reviews
} 