"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TechnologyAnalyzer = void 0;
class TechnologyAnalyzer {
    // OPTIMIZATION: Pre-compiled regex patterns for O(1) lookup
    technologyPatterns = new Map();
    technologyMap = new Map();
    constructor() {
        this.initializeTechnologyPatterns();
    }
    /**
     * OPTIMIZATION: Build-time pattern compilation for maximum performance
     */
    initializeTechnologyPatterns() {
        const technologies = {
            // Programming Languages
            javascript: {
                name: 'JavaScript',
                category: 'programming_language',
                aliases: ['js', 'javascript', 'ecmascript', 'es6', 'es2015', 'es2020'],
                patterns: [/\bjavascript\b/i, /\bjs\b/i, /\becmascript\b/i, /\bes[0-9]+\b/i]
            },
            typescript: {
                name: 'TypeScript',
                category: 'programming_language',
                aliases: ['ts', 'typescript'],
                patterns: [/\btypescript\b/i, /\bts\b/i]
            },
            python: {
                name: 'Python',
                category: 'programming_language',
                aliases: ['python', 'py'],
                patterns: [/\bpython\b/i, /\bpy\b/i]
            },
            java: {
                name: 'Java',
                category: 'programming_language',
                aliases: ['java'],
                patterns: [/\bjava\b/i]
            },
            go: {
                name: 'Go',
                category: 'programming_language',
                aliases: ['go', 'golang'],
                patterns: [/\bgo\b/i, /\bgolang\b/i]
            },
            rust: {
                name: 'Rust',
                category: 'programming_language',
                aliases: ['rust'],
                patterns: [/\brust\b/i]
            },
            kotlin: {
                name: 'Kotlin',
                category: 'programming_language',
                aliases: ['kotlin'],
                patterns: [/\bkotlin\b/i]
            },
            swift: {
                name: 'Swift',
                category: 'programming_language',
                aliases: ['swift'],
                patterns: [/\bswift\b/i]
            },
            csharp: {
                name: 'C#',
                category: 'programming_language',
                aliases: ['c#', 'csharp', 'c-sharp'],
                patterns: [/\bc#\b/i, /\bcsharp\b/i, /\bc-sharp\b/i, /\bdotnet\b/i, /\.net/i]
            },
            cpp: {
                name: 'C++',
                category: 'programming_language',
                aliases: ['c++', 'cpp'],
                patterns: [/\bc\+\+\b/i, /\bcpp\b/i]
            },
            php: {
                name: 'PHP',
                category: 'programming_language',
                aliases: ['php'],
                patterns: [/\bphp\b/i]
            },
            ruby: {
                name: 'Ruby',
                category: 'programming_language',
                aliases: ['ruby'],
                patterns: [/\bruby\b/i]
            },
            // Frontend Frameworks
            react: {
                name: 'React',
                category: 'framework',
                aliases: ['react', 'reactjs', 'react.js'],
                patterns: [/\breact\b/i, /\breactjs\b/i, /\breact\.js\b/i]
            },
            vue: {
                name: 'Vue.js',
                category: 'framework',
                aliases: ['vue', 'vuejs', 'vue.js'],
                patterns: [/\bvue\b/i, /\bvuejs\b/i, /\bvue\.js\b/i]
            },
            angular: {
                name: 'Angular',
                category: 'framework',
                aliases: ['angular', 'angularjs'],
                patterns: [/\bangular\b/i, /\bangularjs\b/i]
            },
            svelte: {
                name: 'Svelte',
                category: 'framework',
                aliases: ['svelte'],
                patterns: [/\bsvelte\b/i]
            },
            // Backend Frameworks
            nodejs: {
                name: 'Node.js',
                category: 'framework',
                aliases: ['node', 'nodejs', 'node.js'],
                patterns: [/\bnode\b/i, /\bnodejs\b/i, /\bnode\.js\b/i]
            },
            express: {
                name: 'Express.js',
                category: 'framework',
                aliases: ['express', 'expressjs'],
                patterns: [/\bexpress\b/i, /\bexpressjs\b/i]
            },
            django: {
                name: 'Django',
                category: 'framework',
                aliases: ['django'],
                patterns: [/\bdjango\b/i]
            },
            flask: {
                name: 'Flask',
                category: 'framework',
                aliases: ['flask'],
                patterns: [/\bflask\b/i]
            },
            rails: {
                name: 'Ruby on Rails',
                category: 'framework',
                aliases: ['rails', 'ror', 'ruby on rails'],
                patterns: [/\brails\b/i, /\bror\b/i, /\bruby on rails\b/i]
            },
            spring: {
                name: 'Spring',
                category: 'framework',
                aliases: ['spring', 'spring boot'],
                patterns: [/\bspring\b/i, /\bspring boot\b/i]
            },
            // Databases
            postgresql: {
                name: 'PostgreSQL',
                category: 'database',
                aliases: ['postgresql', 'postgres', 'psql'],
                patterns: [/\bpostgresql\b/i, /\bpostgres\b/i, /\bpsql\b/i]
            },
            mysql: {
                name: 'MySQL',
                category: 'database',
                aliases: ['mysql'],
                patterns: [/\bmysql\b/i]
            },
            mongodb: {
                name: 'MongoDB',
                category: 'database',
                aliases: ['mongodb', 'mongo'],
                patterns: [/\bmongodb\b/i, /\bmongo\b/i]
            },
            redis: {
                name: 'Redis',
                category: 'database',
                aliases: ['redis'],
                patterns: [/\bredis\b/i]
            },
            elasticsearch: {
                name: 'Elasticsearch',
                category: 'database',
                aliases: ['elasticsearch', 'elastic'],
                patterns: [/\belasticsearch\b/i, /\belastic\b/i]
            },
            // Cloud Platforms
            aws: {
                name: 'AWS',
                category: 'platform',
                aliases: ['aws', 'amazon web services'],
                patterns: [/\baws\b/i, /\bamazon web services\b/i]
            },
            gcp: {
                name: 'Google Cloud',
                category: 'platform',
                aliases: ['gcp', 'google cloud', 'google cloud platform'],
                patterns: [/\bgcp\b/i, /\bgoogle cloud\b/i, /\bgoogle cloud platform\b/i]
            },
            azure: {
                name: 'Azure',
                category: 'platform',
                aliases: ['azure', 'microsoft azure'],
                patterns: [/\bazure\b/i, /\bmicrosoft azure\b/i]
            },
            // Tools
            docker: {
                name: 'Docker',
                category: 'tool',
                aliases: ['docker'],
                patterns: [/\bdocker\b/i]
            },
            kubernetes: {
                name: 'Kubernetes',
                category: 'tool',
                aliases: ['kubernetes', 'k8s'],
                patterns: [/\bkubernetes\b/i, /\bk8s\b/i]
            },
            git: {
                name: 'Git',
                category: 'tool',
                aliases: ['git'],
                patterns: [/\bgit\b/i]
            },
            github: {
                name: 'GitHub',
                category: 'platform',
                aliases: ['github'],
                patterns: [/\bgithub\b/i]
            },
            gitlab: {
                name: 'GitLab',
                category: 'platform',
                aliases: ['gitlab'],
                patterns: [/\bgitlab\b/i]
            },
            terraform: {
                name: 'Terraform',
                category: 'tool',
                aliases: ['terraform'],
                patterns: [/\bterraform\b/i]
            }
        };
        // OPTIMIZATION: Pre-compile all patterns into Maps for O(1) lookup
        Object.entries(technologies).forEach(([key, tech]) => {
            this.technologyPatterns.set(key, tech.patterns);
            this.technologyMap.set(key, {
                name: tech.name,
                category: tech.category,
                aliases: tech.aliases
            });
        });
    }
    /**
     * OPTIMIZED: Analyzes hiring posts with massive performance improvements
     */
    analyzeTrends(posts) {
        console.log(`📊 Analyzing ${posts.length} posts for technology trends...`);
        // OPTIMIZATION: Pre-process posts for faster analysis
        const processedPosts = this.preprocessPosts(posts);
        // OPTIMIZATION: Single-pass analysis with optimized data structures
        const analysis = this.singlePassAnalysis(processedPosts);
        return analysis;
    }
    /**
     * OPTIMIZATION: Pre-process posts to extract only needed data
     */
    preprocessPosts(posts) {
        return posts.map(post => ({
            id: post.id,
            time: post.time,
            text: post.text.toLowerCase(), // OPTIMIZATION: Pre-lowercase for faster matching
            year: new Date(post.time * 1000).getFullYear(),
            month: new Date(post.time * 1000).getMonth()
        }));
    }
    /**
     * OPTIMIZATION: Single-pass analysis with optimized data structures
     */
    singlePassAnalysis(posts) {
        // OPTIMIZATION: Use Maps for O(1) lookups instead of objects
        const periodStats = new Map();
        const overallStats = new Map();
        // OPTIMIZATION: Pre-allocate technology tracking
        this.technologyMap.forEach((_, key) => {
            overallStats.set(key, { count: 0, posts: new Set() });
        });
        // OPTIMIZATION: Single pass through all posts
        posts.forEach(post => {
            const periodKey = `${post.year}-${post.month}`;
            // Initialize period if needed
            if (!periodStats.has(periodKey)) {
                const periodTechs = new Map();
                this.technologyMap.forEach((_, key) => {
                    periodTechs.set(key, { count: 0, posts: new Set() });
                });
                periodStats.set(periodKey, {
                    year: post.year,
                    month: post.month,
                    totalPosts: 0,
                    technologies: periodTechs
                });
            }
            const period = periodStats.get(periodKey);
            period.totalPosts++;
            // OPTIMIZATION: Extract technologies in single pass
            const foundTechs = this.extractTechnologiesOptimized(post.text);
            foundTechs.forEach(techKey => {
                // Update period stats
                const periodTech = period.technologies.get(techKey);
                if (periodTech) {
                    periodTech.count++;
                    periodTech.posts.add(post.id);
                }
                // Update overall stats
                const overallTech = overallStats.get(techKey);
                if (overallTech) {
                    overallTech.count++;
                    overallTech.posts.add(post.id);
                }
            });
        });
        // OPTIMIZATION: Convert to required format efficiently
        const periods = this.convertPeriodStats(periodStats);
        const topTechnologies = this.convertOverallStats(overallStats);
        const growthTrends = this.calculateGrowthTrendsOptimized(periods);
        const timeRange = this.getTimeRangeOptimized(posts);
        return {
            timeRange,
            totalPosts: posts.length,
            periods,
            topTechnologies,
            growthTrends
        };
    }
    /**
     * OPTIMIZATION: Ultra-fast technology extraction using pre-compiled patterns
     */
    extractTechnologiesOptimized(text) {
        const found = [];
        // OPTIMIZATION: Use Map iteration for better performance
        for (const [techKey, patterns] of this.technologyPatterns) {
            for (const pattern of patterns) {
                if (pattern.test(text)) {
                    found.push(techKey);
                    break; // OPTIMIZATION: Don't double-count same technology
                }
            }
        }
        return found;
    }
    /**
     * OPTIMIZATION: Efficient period conversion
     */
    convertPeriodStats(periodStats) {
        return Array.from(periodStats.values()).map(period => {
            const technologies = {};
            period.technologies.forEach((tech, key) => {
                technologies[key] = {
                    name: this.technologyMap.get(key).name,
                    category: this.technologyMap.get(key).category,
                    count: tech.count,
                    posts: Array.from(tech.posts),
                    aliases: this.technologyMap.get(key).aliases
                };
            });
            return {
                year: period.year,
                month: period.month,
                totalPosts: period.totalPosts,
                technologies
            };
        }).sort((a, b) => a.year - b.year || a.month - b.month);
    }
    /**
     * OPTIMIZATION: Efficient overall stats conversion
     */
    convertOverallStats(overallStats) {
        const result = [];
        overallStats.forEach((tech, key) => {
            if (tech.count > 0) {
                result.push({
                    name: this.technologyMap.get(key).name,
                    category: this.technologyMap.get(key).category,
                    count: tech.count,
                    posts: Array.from(tech.posts),
                    aliases: this.technologyMap.get(key).aliases
                });
            }
        });
        return result.sort((a, b) => b.count - a.count);
    }
    /**
     * OPTIMIZATION: Efficient growth trends calculation
     */
    calculateGrowthTrendsOptimized(periods) {
        if (periods.length < 2)
            return [];
        const trends = [];
        const halfPoint = Math.floor(periods.length / 2);
        const firstHalf = periods.slice(0, halfPoint);
        const secondHalf = periods.slice(halfPoint);
        // OPTIMIZATION: Use Map for O(1) lookups
        const firstHalfTotals = new Map();
        const secondHalfTotals = new Map();
        // Calculate totals efficiently
        firstHalf.forEach(period => {
            Object.entries(period.technologies).forEach(([key, tech]) => {
                firstHalfTotals.set(key, (firstHalfTotals.get(key) || 0) + tech.count);
            });
        });
        secondHalf.forEach(period => {
            Object.entries(period.technologies).forEach(([key, tech]) => {
                secondHalfTotals.set(key, (secondHalfTotals.get(key) || 0) + tech.count);
            });
        });
        // Calculate growth trends
        this.technologyMap.forEach((tech, techKey) => {
            const firstHalfCount = firstHalfTotals.get(techKey) || 0;
            const secondHalfCount = secondHalfTotals.get(techKey) || 0;
            if (firstHalfCount > 0 || secondHalfCount > 0) {
                const growthRate = firstHalfCount === 0
                    ? (secondHalfCount > 0 ? 100 : 0)
                    : ((secondHalfCount - firstHalfCount) / firstHalfCount) * 100;
                let trend;
                if (Math.abs(growthRate) < 10) {
                    trend = 'stable';
                }
                else if (growthRate > 0) {
                    trend = 'rising';
                }
                else {
                    trend = 'declining';
                }
                const confidence = Math.min((firstHalfCount + secondHalfCount) / 50, 1);
                trends.push({
                    technology: tech.name,
                    category: tech.category,
                    trend,
                    growthRate,
                    confidence
                });
            }
        });
        return trends.sort((a, b) => Math.abs(b.growthRate) - Math.abs(a.growthRate));
    }
    /**
     * OPTIMIZATION: Efficient time range calculation
     */
    getTimeRangeOptimized(posts) {
        let minTime = Infinity;
        let maxTime = -Infinity;
        posts.forEach(post => {
            if (post.time < minTime)
                minTime = post.time;
            if (post.time > maxTime)
                maxTime = post.time;
        });
        return {
            start: new Date(minTime * 1000),
            end: new Date(maxTime * 1000)
        };
    }
    /**
     * Get available technology categories
     */
    getCategories() {
        const categories = new Set();
        this.technologyMap.forEach(tech => {
            categories.add(tech.category);
        });
        return Array.from(categories);
    }
    /**
     * Get technologies by category
     */
    getTechnologiesByCategory(category) {
        const techs = [];
        this.technologyMap.forEach((tech) => {
            if (tech.category === category) {
                techs.push(tech.name);
            }
        });
        return techs;
    }
}
exports.TechnologyAnalyzer = TechnologyAnalyzer;
//# sourceMappingURL=TechnologyAnalyzer.js.map