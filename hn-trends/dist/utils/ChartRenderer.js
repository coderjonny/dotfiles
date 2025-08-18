"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChartRenderer = void 0;
const chalk_1 = __importDefault(require("chalk"));
const string_width_1 = __importDefault(require("string-width"));
class ChartRenderer {
    defaultOptions = {
        width: 60,
        height: 10,
        showValues: true,
        showPercentages: true,
        sortBy: 'value',
        maxItems: 20,
        barChar: '█',
        showLegend: true
    };
    /**
     * Renders a horizontal bar chart
     */
    renderBarChart(data, options = {}) {
        const opts = { ...this.defaultOptions, ...options };
        let chartData = [...data];
        // Sort data
        if (opts.sortBy === 'value') {
            chartData.sort((a, b) => b.value - a.value);
        }
        else if (opts.sortBy === 'label') {
            chartData.sort((a, b) => a.label.localeCompare(b.label));
        }
        // Limit items
        if (opts.maxItems) {
            chartData = chartData.slice(0, opts.maxItems);
        }
        // Calculate percentages if not provided
        const total = chartData.reduce((sum, item) => sum + item.value, 0);
        chartData = chartData.map(item => ({
            ...item,
            percentage: item.percentage || ((item.value / total) * 100)
        }));
        // Find max value for scaling
        const maxValue = Math.max(...chartData.map(d => d.value));
        const maxLabelLength = Math.max(...chartData.map(d => (0, string_width_1.default)(d.label)));
        let output = '';
        // Title
        if (opts.title) {
            output += chalk_1.default.blue.bold(`\n${opts.title}\n`);
            output += chalk_1.default.dim('━'.repeat(opts.width + maxLabelLength + 20)) + '\n';
        }
        // Chart bars
        chartData.forEach((item, index) => {
            const barLength = Math.round((item.value / maxValue) * opts.width);
            const bar = opts.barChar.repeat(barLength);
            const color = this.getColor(item.color, index);
            // Label with padding
            const paddedLabel = item.label.padEnd(maxLabelLength);
            // Bar with color
            const coloredBar = color(bar);
            // Value and percentage
            let valueText = '';
            if (opts.showValues) {
                valueText += chalk_1.default.gray(` ${item.value.toLocaleString()}`);
            }
            if (opts.showPercentages) {
                valueText += chalk_1.default.yellow(` (${item.percentage.toFixed(1)}%)`);
            }
            output += `${paddedLabel} │${coloredBar}${valueText}\n`;
        });
        // Footer
        output += chalk_1.default.dim('━'.repeat(opts.width + maxLabelLength + 20)) + '\n';
        if (opts.showLegend) {
            output += chalk_1.default.dim(`Total: ${total.toLocaleString()} mentions\n`);
        }
        return output;
    }
    /**
     * Renders a vertical bar chart
     */
    renderVerticalBarChart(data, options = {}) {
        const opts = { ...this.defaultOptions, ...options };
        let chartData = [...data];
        // Sort and limit data
        if (opts.sortBy === 'value') {
            chartData.sort((a, b) => b.value - a.value);
        }
        if (opts.maxItems) {
            chartData = chartData.slice(0, opts.maxItems);
        }
        const maxValue = Math.max(...chartData.map(d => d.value));
        const maxLabelLength = Math.max(...chartData.map(d => (0, string_width_1.default)(d.label)));
        const chartHeight = Math.min(opts.height, 20);
        let output = '';
        // Title
        if (opts.title) {
            output += chalk_1.default.blue.bold(`\n${opts.title}\n`);
            output += chalk_1.default.dim('━'.repeat(chartData.length * 3 + maxLabelLength)) + '\n';
        }
        // Vertical bars
        for (let row = chartHeight; row >= 0; row--) {
            let line = '';
            chartData.forEach((item, index) => {
                const barHeight = Math.round((item.value / maxValue) * chartHeight);
                const color = this.getColor(item.color, index);
                if (row <= barHeight) {
                    line += color(' █ ') + ' ';
                }
                else {
                    line += '   ';
                }
            });
            // Y-axis labels
            if (row % 5 === 0 || row === 0) {
                const value = Math.round((row / chartHeight) * maxValue);
                line = chalk_1.default.gray(value.toString().padStart(4)) + ' ' + line;
            }
            else {
                line = '     ' + line;
            }
            output += line + '\n';
        }
        // X-axis
        output += chalk_1.default.dim('━'.repeat(chartData.length * 3 + 5)) + '\n';
        // X-axis labels
        let labelLine = '     ';
        chartData.forEach(item => {
            const label = item.label.length > 2 ? item.label.substring(0, 2) : item.label;
            labelLine += chalk_1.default.gray(label.padStart(3));
        });
        output += labelLine + '\n';
        // Values below bars
        if (opts.showValues) {
            let valueLine = '     ';
            chartData.forEach(item => {
                valueLine += chalk_1.default.cyan(item.value.toString().padStart(3));
            });
            output += valueLine + '\n';
        }
        return output;
    }
    /**
     * Renders a pie chart (ASCII representation)
     */
    renderPieChart(data, options = {}) {
        const opts = { ...this.defaultOptions, ...options };
        let chartData = [...data];
        // Sort and limit
        if (opts.sortBy === 'value') {
            chartData.sort((a, b) => b.value - a.value);
        }
        if (opts.maxItems) {
            chartData = chartData.slice(0, opts.maxItems);
        }
        // Calculate percentages
        const total = chartData.reduce((sum, item) => sum + item.value, 0);
        chartData = chartData.map(item => ({
            ...item,
            percentage: item.percentage || ((item.value / total) * 100)
        }));
        let output = '';
        // Title
        if (opts.title) {
            output += chalk_1.default.blue.bold(`\n${opts.title}\n`);
            output += chalk_1.default.dim('━'.repeat(50)) + '\n';
        }
        // Pie chart representation
        const pieChars = ['◐', '◑', '◒', '◓', '◔', '◕', '●', '○', '◉', '◎'];
        chartData.forEach((item, index) => {
            const color = this.getColor(item.color, index);
            const pieChar = pieChars[index % pieChars.length];
            const coloredPie = color(pieChar);
            output += `${coloredPie} ${item.label.padEnd(15)} ${item.percentage.toFixed(1)}% (${item.value.toLocaleString()})\n`;
        });
        output += chalk_1.default.dim('━'.repeat(50)) + '\n';
        output += chalk_1.default.dim(`Total: ${total.toLocaleString()}\n`);
        return output;
    }
    /**
     * Renders a trend chart showing growth/decline
     */
    renderTrendChart(data, options = {}) {
        const opts = { ...this.defaultOptions, ...options };
        let chartData = [...data];
        // Sort by absolute value
        chartData.sort((a, b) => Math.abs(b.value) - Math.abs(a.value));
        if (opts.maxItems) {
            chartData = chartData.slice(0, opts.maxItems);
        }
        const maxValue = Math.max(...chartData.map(d => Math.abs(d.value)));
        const maxLabelLength = Math.max(...chartData.map(d => (0, string_width_1.default)(d.label)));
        let output = '';
        // Title
        if (opts.title) {
            output += chalk_1.default.blue.bold(`\n${opts.title}\n`);
            output += chalk_1.default.dim('━'.repeat(opts.width + maxLabelLength + 20)) + '\n';
        }
        // Trend bars
        chartData.forEach((item) => {
            const barLength = Math.round((Math.abs(item.value) / maxValue) * opts.width);
            const bar = opts.barChar.repeat(barLength);
            // Color based on trend
            let color;
            let trendIcon;
            if (item.trend === 'rising') {
                color = chalk_1.default.green;
                trendIcon = '📈';
            }
            else if (item.trend === 'declining') {
                color = chalk_1.default.red;
                trendIcon = '📉';
            }
            else {
                color = chalk_1.default.yellow;
                trendIcon = '📊';
            }
            const coloredBar = color(bar);
            const paddedLabel = item.label.padEnd(maxLabelLength);
            const valueText = chalk_1.default.cyan(` ${item.value > 0 ? '+' : ''}${item.value.toFixed(1)}%`);
            output += `${paddedLabel} │${coloredBar}${valueText} ${trendIcon}\n`;
        });
        output += chalk_1.default.dim('━'.repeat(opts.width + maxLabelLength + 20)) + '\n';
        return output;
    }
    /**
     * Renders a comparison chart between technologies
     */
    renderComparisonChart(data, options = {}) {
        const opts = { ...this.defaultOptions, ...options };
        let chartData = [...data];
        // Calculate percentages
        const total = chartData.reduce((sum, item) => sum + item.value, 0);
        chartData = chartData.map(item => ({
            ...item,
            percentage: item.percentage || ((item.value / total) * 100)
        }));
        const maxLabelLength = Math.max(...chartData.map(d => (0, string_width_1.default)(d.label)));
        let output = '';
        // Title
        if (opts.title) {
            output += chalk_1.default.blue.bold(`\n${opts.title}\n`);
            output += chalk_1.default.dim('━'.repeat(80)) + '\n';
        }
        // Comparison bars
        chartData.forEach((item, index) => {
            const color = this.getColor(item.color, index);
            const paddedLabel = item.label.padEnd(maxLabelLength);
            const bar = opts.barChar.repeat(Math.round(item.percentage / 2)); // Scale for display
            const coloredBar = color(bar);
            output += `${paddedLabel} │${coloredBar} ${item.value.toLocaleString()} (${item.percentage.toFixed(1)}%)\n`;
        });
        output += chalk_1.default.dim('━'.repeat(80)) + '\n';
        output += chalk_1.default.dim(`Total mentions: ${total.toLocaleString()}\n`);
        return output;
    }
    /**
     * Gets color for chart elements
     */
    getColor(colorName, index = 0) {
        if (colorName) {
            const colorMap = {
                'blue': chalk_1.default.blue,
                'green': chalk_1.default.green,
                'red': chalk_1.default.red,
                'yellow': chalk_1.default.yellow,
                'magenta': chalk_1.default.magenta,
                'cyan': chalk_1.default.cyan,
                'gray': chalk_1.default.gray
            };
            return colorMap[colorName] || chalk_1.default.white;
        }
        // Default color rotation
        const colors = [chalk_1.default.blue, chalk_1.default.green, chalk_1.default.magenta, chalk_1.default.cyan, chalk_1.default.yellow, chalk_1.default.red];
        return colors[index % colors.length];
    }
    /**
     * Renders a timeline chart showing trends over time
     */
    renderTimelineChart(data, options = {}) {
        const opts = { ...this.defaultOptions, ...options };
        let output = '';
        // Title
        if (opts.title) {
            output += chalk_1.default.blue.bold(`\n${opts.title}\n`);
            output += chalk_1.default.dim('━'.repeat(80)) + '\n';
        }
        // Get all unique technologies
        const technologies = new Set();
        data.forEach(period => {
            Object.keys(period.values).forEach(tech => technologies.add(tech));
        });
        const techArray = Array.from(technologies);
        // Render timeline
        data.forEach((period) => {
            output += chalk_1.default.cyan.bold(`\n${period.period}:\n`);
            techArray.forEach((tech, techIndex) => {
                const value = period.values[tech] || 0;
                if (value > 0) {
                    const color = this.getColor(undefined, techIndex);
                    const bar = opts.barChar.repeat(Math.min(value, 30)); // Cap at 30 chars
                    const coloredBar = color(bar);
                    output += `  ${tech.padEnd(15)} ${coloredBar} ${value}\n`;
                }
            });
        });
        return output;
    }
}
exports.ChartRenderer = ChartRenderer;
//# sourceMappingURL=ChartRenderer.js.map