# 🎬 HN Trends Demo

This demo showcases the capabilities of the HN Trends CLI tool.

## 🚀 Quick Start Demo

```bash
# 1. First, check the status
hn-trends status

# 2. Get a quick overview of trends
hn-trends quick

# 3. Show detailed technology trends
hn-trends trends show

# 4. Focus on programming languages
hn-trends trends languages

# 5. See growth trends
hn-trends trends growth --rising

# 6. Compare popular frameworks
hn-trends trends compare react vue angular

# 7. Compare programming languages
hn-trends trends compare javascript python java go rust

# 8. Check cache status
hn-trends trends cache --status
```

## 📊 Sample Output

### Quick Analysis
```
🚀 Running quick trend analysis (last 12 months)...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Quick Trends Overview
Based on 8,234 hiring posts from 1/1/2024 to 1/1/2025

PROGRAMMING LANGUAGE:
  1. JavaScript (1,247 mentions)
  2. Python (1,089 mentions)
  3. TypeScript (856 mentions)
  4. Java (678 mentions)
  5. Go (445 mentions)

FRAMEWORK:
  1. React (892 mentions)
  2. Node.js (634 mentions)
  3. Django (289 mentions)
  4. Express.js (245 mentions)
  5. Vue.js (198 mentions)

DATABASE:
  1. PostgreSQL (567 mentions)
  2. MongoDB (334 mentions)
  3. MySQL (289 mentions)
  4. Redis (234 mentions)
  5. Elasticsearch (156 mentions)

TOP GROWTH TRENDS:
  📈 Rust +45.2%
  📈 TypeScript +32.1%
  📈 Kubernetes +28.7%
  📉 jQuery -15.4%
  📉 PHP -8.9%
```

### Detailed Language Analysis
```
💻 Programming Languages Trends
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 Time range: Jan 2023 - Jan 2025
📊 Total posts analyzed: 15,847
🔢 Technologies found: 42

Top Programming Languages
┌──────┬─────────────┬─────────────────────┬──────────┬───────┬───────┐
│ Rank │ Technology  │ Category            │ Mentions │ Posts │ %     │
├──────┼─────────────┼─────────────────────┼──────────┼───────┼───────┤
│ #1   │ JavaScript  │ programming_language│ 3,247    │ 2,891 │ 18.2% │
│ #2   │ Python      │ programming_language│ 2,834    │ 2,543 │ 15.9% │
│ #3   │ TypeScript  │ programming_language│ 1,567    │ 1,445 │ 8.8%  │
│ #4   │ Java        │ programming_language│ 1,234    │ 1,156 │ 6.9%  │
│ #5   │ Go          │ programming_language│ 987      │ 934   │ 5.5%  │
│ #6   │ Rust        │ programming_language│ 634      │ 598   │ 3.6%  │
│ #7   │ C#          │ programming_language│ 456      │ 423   │ 2.6%  │
│ #8   │ Swift       │ programming_language│ 345      │ 329   │ 1.9%  │
│ #9   │ Kotlin      │ programming_language│ 298      │ 287   │ 1.7%  │
│ #10  │ Ruby        │ programming_language│ 234      │ 221   │ 1.3%  │
└──────┴─────────────┴─────────────────────┴──────────┴───────┴───────┘

📊 Language Distribution
JavaScript   │████████████████████████████████████████│ 18.2%
Python       │███████████████████████████████████████░│ 15.9%
TypeScript   │██████████████████░░░░░░░░░░░░░░░░░░░░░░░│ 8.8%
Java         │██████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 6.9%
Go           │███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 5.5%
Rust         │███████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 3.6%
C#           │█████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 2.6%
Swift        │███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 1.9%
Kotlin       │███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 1.7%
Ruby         │██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░│ 1.3%
```

### Technology Comparison
```
⚔️  Technology Comparison: react vs vue vs angular
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 Time range: Jan 2023 - Jan 2025
📊 Total posts analyzed: 15,847
🔢 Technologies found: 42

Direct Comparison
┌─────────┬──────────┬───────┬──────────────┐
│ Technology │ Mentions │ Posts │ Market Share │
├─────────┼──────────┼───────┼──────────────┤
│ React   │ 2,156    │ 1,987 │ 56.3%        │
│ Vue.js  │ 892      │ 834   │ 23.3%        │
│ Angular │ 781      │ 743   │ 20.4%        │
└─────────┴──────────┴───────┴──────────────┘

📈 Timeline Comparison
Showing trends over the analyzed period...

Q1 2023:
  React           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ 156
  Vue.js          ▓▓▓▓▓▓ 67
  Angular         ▓▓▓▓▓ 54

Q2 2023:
  React           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ 178
  Vue.js          ▓▓▓▓▓▓▓ 72
  Angular         ▓▓▓▓▓▓ 61

...
```

### Growth Trends
```
📊 Growth Trends Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Growth Trends
┌─────────────┬─────────────────────┬─────────┬─────────────┬────────────┐
│ Technology  │ Category            │ Trend   │ Growth Rate │ Confidence │
├─────────────┼─────────────────────┼─────────┼─────────────┼────────────┤
│ Rust        │ programming_language│ 📈 rising│ +45.2%      │ 78%        │
│ TypeScript  │ programming_language│ 📈 rising│ +32.1%      │ 92%        │
│ Kubernetes  │ tool                │ 📈 rising│ +28.7%      │ 85%        │
│ Go          │ programming_language│ 📈 rising│ +24.3%      │ 88%        │
│ Docker      │ tool                │ 📈 rising│ +19.8%      │ 91%        │
│ Svelte      │ framework           │ 📈 rising│ +67.4%      │ 45%        │
│ GraphQL     │ tool                │ 📈 rising│ +15.2%      │ 67%        │
│ jQuery      │ framework           │ 📉 declining│ -15.4%   │ 73%        │
│ PHP         │ programming_language│ 📉 declining│ -8.9%    │ 81%        │
│ AngularJS   │ framework           │ 📉 declining│ -22.1%   │ 69%        │
└─────────────┴─────────────────────┴─────────┴─────────────┴────────────┘
```

## 💡 Insights from the Data

Based on this analysis, here are some key trends:

### 🔥 Hot Technologies (Rising Fast)
- **Rust**: +45% growth - Systems programming is gaining traction
- **TypeScript**: +32% growth - JavaScript with types is becoming standard
- **Kubernetes**: +29% growth - Container orchestration is essential
- **Svelte**: +67% growth - Emerging React alternative (lower confidence due to smaller sample)

### 📊 Stable Leaders
- **JavaScript**: Still the most mentioned language (18.2% market share)
- **Python**: Close second with strong data science/ML demand (15.9%)
- **React**: Dominates frontend framework space (56% among major frameworks)

### 📉 Declining Technologies
- **jQuery**: -15% decline - Modern frameworks taking over
- **PHP**: -9% decline - Though still relevant for WordPress/web
- **AngularJS**: -22% decline - Being replaced by modern Angular

### 🌟 Category Leaders
- **Frontend**: React ecosystem dominates, but Vue.js gaining ground
- **Backend**: Node.js + Express.js for JavaScript, Django for Python
- **Cloud**: AWS still leads, but multi-cloud strategies growing
- **DevOps**: Docker + Kubernetes becoming standard stack

## 🎯 Using This Data

### For Job Seekers
- **High Demand**: Focus on JavaScript/TypeScript + React
- **Growing Markets**: Learn Rust, Go, or Kubernetes for competitive edge
- **Safe Bets**: Python + Django/Flask for backend roles
- **Emerging**: Keep eye on Svelte, GraphQL

### For Hiring Managers
- **Talent Availability**: JavaScript/Python developers most available
- **Premium Skills**: Rust, Kubernetes, TypeScript developers command higher salaries
- **Future-Proofing**: Invest in teams learning emerging technologies

### For Technology Leaders
- **Migration Planning**: Consider moving from jQuery to modern frameworks
- **Stack Evolution**: TypeScript adoption shows maturity benefits
- **Cloud Strategy**: Kubernetes skills becoming essential for scaling

---

*This demo data is simulated for illustration. Run the actual tool to get real-time trends from Hacker News!*
