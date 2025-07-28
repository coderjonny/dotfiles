import { Command } from 'commander';
import { FileStorage } from '../storage/FileStorage';
export declare class ListCommand {
    private storage;
    constructor(storage: FileStorage);
    register(program: Command): void;
    private listDecks;
    private listCards;
    private getCardStatus;
}
//# sourceMappingURL=ListCommand.d.ts.map