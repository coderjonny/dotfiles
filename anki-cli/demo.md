# 🎬 Anki CLI Demo

This demo showcases the complete TypeScript CLI flashcard application with spaced repetition!

## 🚀 Setup & Installation

```bash
cd anki-cli
npm install
npm run build
```

## 📚 Demo Walkthrough

### 1. Create Your First Deck

```bash
# Interactive deck creation
anki-cli add deck --name "Spanish Vocabulary" --description "Basic Spanish words for beginners"

# Quick deck creation
anki-cli add deck --name "JavaScript Concepts"
```

### 2. Add Some Cards

```bash
# Add cards with command line options
anki-cli add card --question "What does 'Hola' mean?" --answer "Hello" --tags "greetings,spanish"

# Interactive card creation (recommended)
anki-cli add quick
```

**Interactive prompts will guide you through:**
- ❓ Question: What is a closure in JavaScript?
- 💡 Answer: A function that has access to variables in its outer scope
- 🏷️ Tags: javascript,functions,scope

### 3. Start Learning!

```bash
# Begin your first review session
anki-cli review
```

**Experience the spaced repetition flow:**
1. 📚 **Starting review session: 3 cards**
2. ❓ **What does 'Hola' mean?**
3. Press Enter to see answer...
4. 💡 **Hello**
5. Rate your recall:
   - 1️⃣ Again (completely forgot)
   - 2️⃣ Hard (difficult to recall) 
   - 3️⃣ Good (recalled with effort)
   - 4️⃣ Easy (perfect recall)

### 4. Track Your Progress

```bash
# View overall statistics
anki-cli stats

# Detailed analytics
anki-cli stats --detailed
```

**Sample output:**
```
📊 Anki CLI Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 Cards Overview
  Total cards: 5
  Due for review: 2
  New cards: 3
  Mastered: 0 (0.0%)

📂 Decks Overview
  Total decks: 2
  • Spanish Vocabulary: 3 cards (2 due)
  • JavaScript Concepts: 2 cards (0 due)

📈 Performance
  Total reviews: 4
  Retention rate: 75.0%
  Average ease: 2.42
```

### 5. Manage Your Content

```bash
# List all decks
anki-cli list decks

# Show cards due for review
anki-cli list due

# Filter cards by deck
anki-cli list cards --deck spanish-vocabulary

# Filter by tags
anki-cli list cards --tag javascript
```

## 🧠 How Spaced Repetition Works

Watch your cards evolve over time:

### **Day 1** - New Card
- ❓ "What does 'Hola' mean?"
- Rating: 3️⃣ Good
- ✅ Next review: **Tomorrow** (1 day)

### **Day 2** - Second Review
- ❓ "What does 'Hola' mean?"  
- Rating: 4️⃣ Easy
- ✅ Next review: **6 days** (SM-2 algorithm)

### **Day 8** - Established Card
- ❓ "What does 'Hola' mean?"
- Rating: 3️⃣ Good  
- ✅ Next review: **15 days** (6 × 2.5 ease factor)

### **Day 23** - Mastered! ⭐
- Interval: 21+ days = **Mastered status**
- Card appears in statistics as long-term memory

## 🎯 Advanced Features

### **Deck-Specific Review**
```bash
anki-cli review --deck spanish-vocabulary --limit 10
```

### **Performance Analytics**
```bash
anki-cli stats --deck javascript-concepts --detailed
```

**Sample detailed output:**
```
🔍 Detailed Statistics
  Review Distribution:
    Again: 1 (25.0%)
    Hard: 0 (0.0%)  
    Good: 2 (50.0%)
    Easy: 1 (25.0%)

  Interval Distribution:
    1 day: 2 cards
    2-6 days: 1 cards
    1-3 weeks: 0 cards
    1+ months: 0 cards

🔥 Most Difficult Cards
  1. What is a closure in JavaScript?
     Ease: 2.30, Success: 66%
```

## 💾 Data Storage

Your learning data is safely stored in:
- `~/.anki-cli/data.json` - Main database
- `~/.anki-cli/backups/` - Automatic backups (last 10)

**Sample data structure:**
```json
{
  "cards": [
    {
      "id": "uuid-here",
      "question": "What does 'Hola' mean?",
      "answer": "Hello",
      "easeFactor": 2.5,
      "interval": 6,
      "nextReview": "2024-01-15T00:00:00.000Z"
    }
  ],
  "decks": [...],
  "reviews": [...]
}
```

## 🏆 Success Metrics

After using this for a week, you might see:
- **50+ cards** in your collection
- **85%+ retention rate** 
- **10+ mastered cards** in long-term memory
- **15 minutes/day** average study time

## 🎓 Learning Tips

1. **Consistency beats intensity** - 15 minutes daily > 2 hours weekly
2. **Rate honestly** - Accurate ratings improve the algorithm
3. **Use the "Again" button** - Don't be afraid to reset difficult cards
4. **Add context** - Use tags to organize related concepts
5. **Review when due** - The algorithm knows the optimal timing

---

**Ready to supercharge your learning?** 🚀

Start with `anki-cli add quick` and begin building your knowledge empire, one card at a time! 