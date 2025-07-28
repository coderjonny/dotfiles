import { Command } from 'commander';
import { FileStorage } from '../storage/FileStorage';
export declare class ReviewCommand {
    private storage;
    constructor(storage: FileStorage);
    register(program: Command): void;
    private startReview;
    private showFeedback;
    private formatTime;
}
//# sourceMappingURL=ReviewCommand.d.ts.map