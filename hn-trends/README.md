# 📈 HN Trends

A powerful CLI tool to analyze programming language and technology trends from Hacker News "Who is Hiring?" posts.

## 🚀 Features

- **Real-time Trend Analysis**: Fetches and analyzes the latest hiring posts from Hacker News
- **Technology Detection**: Automatically identifies 40+ programming languages, frameworks, databases, and tools
- **Growth Tracking**: Shows which technologies are rising, declining, or stable
- **Smart Caching**: Caches data locally to avoid unnecessary API calls
- **Flexible Time Ranges**: Analyze trends from the last 6, 12, 24 months or more
- **Technology Comparison**: Compare adoption rates between specific technologies
- **Beautiful CLI Output**: Colorized tables, charts, and progress indicators

## 📦 Installation

```bash
# Install dependencies
npm install

# Build the project
npm run build

# Link for global use (optional)
npm link
```

## 🛠 Usage

### Quick Start

Get a quick overview of current trends:
```bash
hn-trends quick
```

Check the status of cached data:
```bash
hn-trends status
```

### Detailed Analysis

Show comprehensive technology trends:
```bash
hn-trends trends show
hn-trends trends show --months 12 --limit 30
hn-trends trends show --category programming_language
```

Focus on programming languages:
```bash
hn-trends trends languages
hn-trends trends languages --months 18 --limit 20
```

Analyze growth trends:
```bash
hn-trends trends growth
hn-trends trends growth --rising
hn-trends trends growth --declining
```

Compare specific technologies:
```bash
hn-trends trends compare react vue angular
hn-trends trends compare python java javascript
hn-trends trends compare postgres mysql mongodb
```

### Cache Management

Check cache status:
```bash
hn-trends trends cache --status
```

Clear cached data:
```bash
hn-trends trends cache --clear
```

Force refresh data:
```bash
hn-trends trends show --force-refresh
```

## 📊 Supported Technologies

The tool automatically detects mentions of:

### Programming Languages
- JavaScript/TypeScript
- Python
- Java
- Go
- Rust
- Kotlin
- Swift
- C#/.NET
- C++
- PHP
- Ruby

### Frontend Frameworks
- React
- Vue.js
- Angular
- Svelte

### Backend Frameworks
- Node.js
- Express.js
- Django
- Flask
- Ruby on Rails
- Spring

### Databases
- PostgreSQL
- MySQL
- MongoDB
- Redis
- Elasticsearch

### Cloud Platforms
- AWS
- Google Cloud Platform
- Microsoft Azure

### Tools & Platforms
- Docker
- Kubernetes
- Git
- GitHub
- GitLab
- Terraform

## 🎯 Example Output

```
📈 Technology Trends Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 Time range: Jan 2023 - Jan 2025
📊 Total posts analyzed: 15,847
🔢 Technologies found: 42

Top Technologies
┌──────┬─────────────┬─────────────────────┬──────────┬───────┬───────┐
│ Rank │ Technology  │ Category            │ Mentions │ Posts │ %     │
├──────┼─────────────┼─────────────────────┼──────────┼───────┼───────┤
│ #1   │ JavaScript  │ programming_language│ 3,247    │ 2,891 │ 18.2% │
│ #2   │ Python      │ programming_language│ 2,834    │ 2,543 │ 15.9% │
│ #3   │ React       │ framework           │ 2,156    │ 1,987 │ 12.1% │
│ #4   │ AWS         │ platform            │ 1,823    │ 1,654 │ 10.2% │
│ #5   │ TypeScript  │ programming_language│ 1,567    │ 1,445 │ 8.8%  │
└──────┴─────────────┴─────────────────────┴──────────┴───────┴───────┘
```

## ⚙️ Configuration

### Custom Time Ranges
- `--months 6`: Last 6 months
- `--months 12`: Last 12 months (default for most commands)
- `--months 24`: Last 24 months (default for main trends)
- `--months 36`: Last 3 years

### Categories
- `programming_language`: Python, JavaScript, Java, etc.
- `framework`: React, Django, Spring, etc.
- `database`: PostgreSQL, MongoDB, Redis, etc.
- `tool`: Docker, Git, Terraform, etc.
- `platform`: AWS, GCP, Azure, GitHub, etc.

### Output Limits
- `--limit 10`: Show top 10 results
- `--limit 20`: Show top 20 results (default)
- `--limit 50`: Show top 50 results

## 🔧 Development

### Setup
```bash
# Install dependencies
npm install

# Run in development mode
npm run dev

# Build for production
npm run build

# Run tests
npm test

# Watch for changes
npm run watch
```

### Project Structure
```
hn-trends/
├── src/
│   ├── commands/          # CLI command implementations
│   ├── models/            # TypeScript interfaces and types
│   ├── services/          # Core business logic
│   │   ├── HackerNewsService.ts    # HN API integration
│   │   └── TechnologyAnalyzer.ts   # Trend analysis engine
│   ├── storage/           # Data caching and persistence
│   └── index.ts           # CLI entry point
├── dist/                  # Compiled JavaScript
└── package.json
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

### Adding New Technologies

To add support for a new technology, edit `src/services/TechnologyAnalyzer.ts`:

```typescript
newtech: {
  name: 'New Technology',
  category: 'framework', // or appropriate category
  aliases: ['newtech', 'new-tech'],
  patterns: [/\bnewtech\b/i, /\bnew-tech\b/i]
}
```

## 📈 Performance & Scaling

- **Caching**: Data is cached locally for 24 hours to reduce API calls
- **Rate Limiting**: Built-in delays to respect HN API limits
- **Progressive Loading**: Shows progress bars for long operations
- **Efficient Analysis**: Optimized regex patterns for fast text processing

## 🔒 Privacy & Data

- **Local Storage**: All data is stored locally in `~/.hn-trends/`
- **No Tracking**: No analytics or user tracking
- **Public Data**: Only analyzes publicly available HN posts
- **Respectful API Usage**: Implements proper rate limiting

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Hacker News API**: For providing access to hiring post data
- **Y Combinator**: For hosting the amazing HN community
- **Open Source Community**: For the excellent Node.js ecosystem

## 🐛 Bug Reports & Feature Requests

Please open an issue on GitHub with:
- Clear description of the problem or feature
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Your environment details

---

**Happy trend hunting! 📊🚀**
