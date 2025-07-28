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

export interface DeckSettings {
  // Learning settings
  learningSteps: number[];     // Minutes for learning cards [1, 10]
  graduatingInterval: number;  // Days when card graduates (1)
  easyInterval: number;        // Days for easy cards (4)
  
  // Review settings  
  maximumInterval: number;     // Max days between reviews (36500)
  startingEase: number;        // Initial ease factor (2.5)
  easyBonus: number;          // Easy bonus multiplier (1.3)
  intervalModifier: number;    // Global interval modifier (1.0)
  
  // Lapses
  relearningSteps: number[];  // Steps for failed cards [10]
  minimumInterval: number;    // Min interval after lapse (1)
  leechThreshold: number;     // Failed reviews before leech (8)
} 