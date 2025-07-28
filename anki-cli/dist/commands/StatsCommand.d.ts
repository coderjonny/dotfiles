import { Command } from 'commander';
import { FileStorage } from '../storage/FileStorage';
export declare class StatsCommand {
    private storage;
    constructor(storage: FileStorage);
    register(program: Command): void;
    private showStats;
    private showOverallStats;
    private showDeckStats;
    private showDetailedStats;
    private showDeckDetailedStats;
    private percentage;
}
//# sourceMappingURL=StatsCommand.d.ts.map