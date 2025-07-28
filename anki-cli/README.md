# 🧠 Anki CLI

A TypeScript CLI flashcard application with **spaced repetition** using the **SuperMemo SM-2 algorithm**. Create, study, and master flashcards right from your terminal!

## ✨ Features

### 🎯 **Core Functionality**
- **Spaced Repetition**: Industry-standard SM-2 algorithm for optimal learning
- **Interactive Reviews**: Smooth terminal-based study sessions
- **Multiple Decks**: Organize cards by topic or subject
- **Smart Scheduling**: Cards appear exactly when you need to review them
- **Progress Tracking**: Detailed statistics and performance analytics

### 📊 **Advanced Features**  
- **Retention Analytics**: Track success rates and learning progress
- **Difficulty Adaptation**: Cards adjust based on your performance
- **Session Management**: Customizable review limits and deck filtering
- **Data Persistence**: JSON-based storage with automatic backups
- **Rich CLI Experience**: Beautiful colors, emojis, and progress indicators

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd anki-cli

# Install dependencies
npm install

# Build the application
npm run build

# Run the CLI
npm start
```

### First Steps

```bash
# Create your first deck
anki-cli add deck --name "Spanish Vocabulary"

# Add some cards
anki-cli add card --question "Hello" --answer "Hola"
anki-cli add quick  # Interactive card creation

# Start studying
anki-cli review

# Check your progress
anki-cli stats
```

## 📖 Usage Guide

### 🎯 **Adding Content**

```bash
# Create a new deck
anki-cli add deck --name "JavaScript Concepts" --description "Core JS knowledge"

# Add cards with command line options
anki-cli add card --question "What is a closure?" --answer "A function with access to outer scope" --tags "javascript,functions"

# Interactive card creation (recommended)
anki-cli add quick

# Add card to specific deck
anki-cli add card --deck javascript-concepts
```

### 📚 **Studying**

```bash
# Start a review session (default: 20 cards max)
anki-cli review

# Review specific deck
anki-cli review --deck spanish-vocabulary

# Review more cards
anki-cli review --limit 50

# Quick check what's due
anki-cli list due
```

### 📊 **Tracking Progress**

```bash
# Overall statistics
anki-cli stats

# Detailed analytics
anki-cli stats --detailed

# Deck-specific stats
anki-cli stats --deck spanish-vocabulary --detailed
```

### 📋 **Managing Content**

```bash
# List all decks
anki-cli list decks

# List all cards
anki-cli list cards

# Filter cards by deck
anki-cli list cards --deck spanish-vocabulary

# Show only due cards
anki-cli list due

# Filter by tags
anki-cli list cards --tag javascript
```

## 🧠 How Spaced Repetition Works

This app uses the **SuperMemo SM-2 algorithm**, the gold standard for spaced repetition:

### 📈 **The Algorithm**
1. **New cards** start with a 1-day interval
2. **Second review** happens after 6 days  
3. **Subsequent intervals** multiply by your "ease factor" (default: 2.5)
4. **Ease factor adjusts** based on how well you know each card:
   - **Again** (forgot): Reset to 1 day, decrease ease
   - **Hard** (difficult): Shorter interval, slightly decrease ease  
   - **Good** (recalled): Normal interval, maintain ease
   - **Easy** (perfect): Longer interval, increase ease

### 🎯 **Why It Works**
- **Optimized timing**: Review just before you'd forget
- **Personalized**: Adapts to your individual learning curve
- **Efficient**: Focus time on cards you struggle with
- **Long-term retention**: Scientifically proven for lasting memory

## 📊 Understanding Your Statistics

### 🔍 **Key Metrics**
- **Retention Rate**: Percentage of reviews answered correctly
- **Ease Factor**: Difficulty multiplier (higher = easier for you)
- **Mastered Cards**: Cards with 21+ day intervals (long-term memory)
- **Due Cards**: Cards ready for review right now

### 📈 **Card Statuses**
- 🆕 **New**: Never reviewed
- 🔄 **Review**: Short interval (1-6 days)  
- 📈 **Learning**: Medium interval (1-3 weeks)
- ⭐ **Mastered**: Long interval (21+ days)

## ⚙️ Development

### 🛠️ **Available Scripts**

```bash
# Development
npm run dev        # Run with ts-node (hot reload)
npm run watch      # Watch mode compilation
npm test          # Run tests

# Build & Distribution  
npm run build     # Compile TypeScript
npm run clean     # Remove dist folder
npm start         # Run compiled version
```

### 📁 **Project Structure**

```
anki-cli/
├── src/
│   ├── models/          # TypeScript interfaces
│   │   └── Card.ts      # Card, Deck, Review types
│   ├── algorithms/      # Spaced repetition logic
│   │   └── sm2.ts       # SuperMemo SM-2 implementation
│   ├── storage/         # Data persistence
│   │   └── FileStorage.ts
│   ├── commands/        # CLI command handlers
│   │   ├── AddCommand.ts
│   │   ├── ReviewCommand.ts
│   │   ├── ListCommand.ts
│   │   └── StatsCommand.ts
│   └── index.ts         # Main CLI entry point
├── dist/               # Compiled JavaScript
└── data/              # User flashcard data
```

### 🎨 **Technical Highlights**

- **TypeScript**: Full type safety and modern ES features
- **Commander.js**: Robust CLI framework with subcommands
- **Inquirer.js**: Interactive prompts and menus
- **Chalk**: Beautiful terminal colors and formatting
- **Atomic File Operations**: Data integrity with backup system
- **SM-2 Algorithm**: Scientifically-proven spaced repetition

## 📝 Data Storage

Your flashcard data is stored locally in:
- **Main data**: `~/.anki-cli/data.json`
- **Backups**: `~/.anki-cli/backups/` (last 10 automatically kept)

The data format is human-readable JSON, making it easy to backup, migrate, or inspect.

## 🤝 Contributing

Contributions welcome! This project follows:
- **SOLID principles** for maintainable code
- **Staff-level engineering** practices
- **Comprehensive testing** for reliability
- **Type safety** throughout

## 📄 License

MIT License - feel free to use this for learning and building your own tools!

---

**Happy learning!** 🎓 Remember: consistent daily review beats cramming every time. 