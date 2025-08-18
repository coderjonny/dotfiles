import chalk from 'chalk';
import stringWidth from 'string-width';

export interface ChartData {
  label: string;
  value: number;
  color?: string;
  percentage?: number;
}

export interface ChartOptions {
  width?: number;
  height?: number;
  showValues?: boolean;
  showPercentages?: boolean;
  title?: string;
  sortBy?: 'value' | 'label' | 'none';
  maxItems?: number;
  barChar?: string;
  showLegend?: boolean;
}

export class ChartRenderer {
  private readonly defaultOptions: ChartOptions = {
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
  renderBarChart(data: ChartData[], options: ChartOptions = {}): string {
    const opts = { ...this.defaultOptions, ...options };
    let chartData = [...data];

    // Sort data
    if (opts.sortBy === 'value') {
      chartData.sort((a, b) => b.value - a.value);
    } else if (opts.sortBy === 'label') {
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
    const maxLabelLength = Math.max(...chartData.map(d => stringWidth(d.label)));

    let output = '';

    // Title
    if (opts.title) {
      output += chalk.blue.bold(`\n${opts.title}\n`);
      output += chalk.dim('━'.repeat(opts.width! + maxLabelLength + 20)) + '\n';
    }

    // Chart bars
    chartData.forEach((item, index) => {
      const barLength = Math.round((item.value / maxValue) * opts.width!);
      const bar = opts.barChar!.repeat(barLength);
      const color = this.getColor(item.color, index);
      
      // Label with padding
      const paddedLabel = item.label.padEnd(maxLabelLength);
      
      // Bar with color
      const coloredBar = color(bar);
      
      // Value and percentage
      let valueText = '';
      if (opts.showValues) {
        valueText += chalk.gray(` ${item.value.toLocaleString()}`);
      }
      if (opts.showPercentages) {
        valueText += chalk.yellow(` (${item.percentage!.toFixed(1)}%)`);
      }
      
      output += `${paddedLabel} │${coloredBar}${valueText}\n`;
    });

    // Footer
    output += chalk.dim('━'.repeat(opts.width! + maxLabelLength + 20)) + '\n';
    
    if (opts.showLegend) {
      output += chalk.dim(`Total: ${total.toLocaleString()} mentions\n`);
    }

    return output;
  }

  /**
   * Renders a vertical bar chart
   */
  renderVerticalBarChart(data: ChartData[], options: ChartOptions = {}): string {
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
    const maxLabelLength = Math.max(...chartData.map(d => stringWidth(d.label)));
    const chartHeight = Math.min(opts.height!, 20);

    let output = '';

    // Title
    if (opts.title) {
      output += chalk.blue.bold(`\n${opts.title}\n`);
      output += chalk.dim('━'.repeat(chartData.length * 3 + maxLabelLength)) + '\n';
    }

    // Vertical bars
    for (let row = chartHeight; row >= 0; row--) {
      let line = '';
      
      chartData.forEach((item, index) => {
        const barHeight = Math.round((item.value / maxValue) * chartHeight);
        const color = this.getColor(item.color, index);
        
        if (row <= barHeight) {
          line += color(' █ ') + ' ';
        } else {
          line += '   ';
        }
      });
      
      // Y-axis labels
      if (row % 5 === 0 || row === 0) {
        const value = Math.round((row / chartHeight) * maxValue);
        line = chalk.gray(value.toString().padStart(4)) + ' ' + line;
      } else {
        line = '     ' + line;
      }
      
      output += line + '\n';
    }

    // X-axis
    output += chalk.dim('━'.repeat(chartData.length * 3 + 5)) + '\n';
    
    // X-axis labels
    let labelLine = '     ';
    chartData.forEach(item => {
      const label = item.label.length > 2 ? item.label.substring(0, 2) : item.label;
      labelLine += chalk.gray(label.padStart(3));
    });
    output += labelLine + '\n';

    // Values below bars
    if (opts.showValues) {
      let valueLine = '     ';
      chartData.forEach(item => {
        valueLine += chalk.cyan(item.value.toString().padStart(3));
      });
      output += valueLine + '\n';
    }

    return output;
  }

  /**
   * Renders a pie chart (ASCII representation)
   */
  renderPieChart(data: ChartData[], options: ChartOptions = {}): string {
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
      output += chalk.blue.bold(`\n${opts.title}\n`);
      output += chalk.dim('━'.repeat(50)) + '\n';
    }

    // Pie chart representation
    const pieChars = ['◐', '◑', '◒', '◓', '◔', '◕', '●', '○', '◉', '◎'];
    
    chartData.forEach((item, index) => {
      const color = this.getColor(item.color, index);
      const pieChar = pieChars[index % pieChars.length];
      const coloredPie = color(pieChar);
      
      output += `${coloredPie} ${item.label.padEnd(15)} ${item.percentage!.toFixed(1)}% (${item.value.toLocaleString()})\n`;
    });

    output += chalk.dim('━'.repeat(50)) + '\n';
    output += chalk.dim(`Total: ${total.toLocaleString()}\n`);

    return output;
  }

  /**
   * Renders a trend chart showing growth/decline
   */
  renderTrendChart(data: Array<{label: string; value: number; trend: 'rising' | 'declining' | 'stable'}>, options: ChartOptions = {}): string {
    const opts = { ...this.defaultOptions, ...options };
    let chartData = [...data];

    // Sort by absolute value
    chartData.sort((a, b) => Math.abs(b.value) - Math.abs(a.value));
    if (opts.maxItems) {
      chartData = chartData.slice(0, opts.maxItems);
    }

    const maxValue = Math.max(...chartData.map(d => Math.abs(d.value)));
    const maxLabelLength = Math.max(...chartData.map(d => stringWidth(d.label)));

    let output = '';

    // Title
    if (opts.title) {
      output += chalk.blue.bold(`\n${opts.title}\n`);
      output += chalk.dim('━'.repeat(opts.width! + maxLabelLength + 20)) + '\n';
    }

    // Trend bars
    chartData.forEach((item) => {
      const barLength = Math.round((Math.abs(item.value) / maxValue) * opts.width!);
      const bar = opts.barChar!.repeat(barLength);
      
      // Color based on trend
      let color;
      let trendIcon;
      if (item.trend === 'rising') {
        color = chalk.green;
        trendIcon = '📈';
      } else if (item.trend === 'declining') {
        color = chalk.red;
        trendIcon = '📉';
      } else {
        color = chalk.yellow;
        trendIcon = '📊';
      }
      
      const coloredBar = color(bar);
      const paddedLabel = item.label.padEnd(maxLabelLength);
      const valueText = chalk.cyan(` ${item.value > 0 ? '+' : ''}${item.value.toFixed(1)}%`);
      
      output += `${paddedLabel} │${coloredBar}${valueText} ${trendIcon}\n`;
    });

    output += chalk.dim('━'.repeat(opts.width! + maxLabelLength + 20)) + '\n';

    return output;
  }

  /**
   * Renders a comparison chart between technologies
   */
  renderComparisonChart(data: ChartData[], options: ChartOptions = {}): string {
    const opts = { ...this.defaultOptions, ...options };
    let chartData = [...data];

    // Calculate percentages
    const total = chartData.reduce((sum, item) => sum + item.value, 0);
    chartData = chartData.map(item => ({
      ...item,
      percentage: item.percentage || ((item.value / total) * 100)
    }));

    const maxLabelLength = Math.max(...chartData.map(d => stringWidth(d.label)));

    let output = '';

    // Title
    if (opts.title) {
      output += chalk.blue.bold(`\n${opts.title}\n`);
      output += chalk.dim('━'.repeat(80)) + '\n';
    }

    // Comparison bars
    chartData.forEach((item, index) => {
      const color = this.getColor(item.color, index);
      const paddedLabel = item.label.padEnd(maxLabelLength);
      const bar = opts.barChar!.repeat(Math.round(item.percentage! / 2)); // Scale for display
      const coloredBar = color(bar);
      
      output += `${paddedLabel} │${coloredBar} ${item.value.toLocaleString()} (${item.percentage!.toFixed(1)}%)\n`;
    });

    output += chalk.dim('━'.repeat(80)) + '\n';
    output += chalk.dim(`Total mentions: ${total.toLocaleString()}\n`);

    return output;
  }

  /**
   * Gets color for chart elements
   */
  private getColor(colorName?: string, index: number = 0): any {
    if (colorName) {
      const colorMap: Record<string, any> = {
        'blue': chalk.blue,
        'green': chalk.green,
        'red': chalk.red,
        'yellow': chalk.yellow,
        'magenta': chalk.magenta,
        'cyan': chalk.cyan,
        'gray': chalk.gray
      };
      return colorMap[colorName] || chalk.white;
    }

    // Default color rotation
    const colors = [chalk.blue, chalk.green, chalk.magenta, chalk.cyan, chalk.yellow, chalk.red];
    return colors[index % colors.length];
  }

  /**
   * Renders a timeline chart showing trends over time
   */
  renderTimelineChart(data: Array<{period: string; values: Record<string, number>}>, options: ChartOptions = {}): string {
    const opts = { ...this.defaultOptions, ...options };
    
    let output = '';

    // Title
    if (opts.title) {
      output += chalk.blue.bold(`\n${opts.title}\n`);
      output += chalk.dim('━'.repeat(80)) + '\n';
    }

    // Get all unique technologies
    const technologies = new Set<string>();
    data.forEach(period => {
      Object.keys(period.values).forEach(tech => technologies.add(tech));
    });

    const techArray = Array.from(technologies);

    // Render timeline
    data.forEach((period) => {
      output += chalk.cyan.bold(`\n${period.period}:\n`);
      
      techArray.forEach((tech, techIndex) => {
        const value = period.values[tech] || 0;
        if (value > 0) {
          const color = this.getColor(undefined, techIndex);
          const bar = opts.barChar!.repeat(Math.min(value, 30)); // Cap at 30 chars
          const coloredBar = color(bar);
          
          output += `  ${tech.padEnd(15)} ${coloredBar} ${value}\n`;
        }
      });
    });

    return output;
  }
}
