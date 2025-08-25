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
export declare class ChartRenderer {
    private readonly defaultOptions;
    /**
     * Renders a horizontal bar chart
     */
    renderBarChart(data: ChartData[], options?: ChartOptions): string;
    /**
     * Renders a vertical bar chart
     */
    renderVerticalBarChart(data: ChartData[], options?: ChartOptions): string;
    /**
     * Renders a pie chart (ASCII representation)
     */
    renderPieChart(data: ChartData[], options?: ChartOptions): string;
    /**
     * Renders a trend chart showing growth/decline
     */
    renderTrendChart(data: Array<{
        label: string;
        value: number;
        trend: 'rising' | 'declining' | 'stable';
    }>, options?: ChartOptions): string;
    /**
     * Renders a comparison chart between technologies
     */
    renderComparisonChart(data: ChartData[], options?: ChartOptions): string;
    /**
     * Gets color for chart elements
     */
    private getColor;
    /**
     * Renders a timeline chart showing trends over time
     */
    renderTimelineChart(data: Array<{
        period: string;
        values: Record<string, number>;
    }>, options?: ChartOptions): string;
}
//# sourceMappingURL=ChartRenderer.d.ts.map