import { Command } from 'commander';
import { FileStorage } from '../storage/FileStorage';
export declare class AddCommand {
    private storage;
    constructor(storage: FileStorage);
    register(program: Command): void;
    private addCard;
    private addDeck;
    private quickAdd;
    private createDefaultDeck;
}
//# sourceMappingURL=AddCommand.d.ts.map