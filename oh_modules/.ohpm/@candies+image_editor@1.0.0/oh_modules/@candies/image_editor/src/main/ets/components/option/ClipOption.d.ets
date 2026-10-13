import image from '@ohos.multimedia.image';
import { EditOption } from './Option';
export declare class ClipOption implements EditOption {
    static readonly key: string;
    x: number;
    y: number;
    width: number;
    height: number;
    constructor(x: number, y: number, width: number, height: number);
    static fromMap(data: Map<string, ESObject>): ClipOption;
    canIgnore(): boolean;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
}
