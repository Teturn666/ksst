import { EditOption } from './Option';
import image from '@ohos.multimedia.image';
export declare class FlipOption implements EditOption {
    static readonly key: string;
    horizontal: boolean;
    vertical: boolean;
    constructor(horizontal: boolean, vertical: boolean);
    static fromMap(data: Map<string, ESObject>): FlipOption;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
    canIgnore(): boolean;
}
