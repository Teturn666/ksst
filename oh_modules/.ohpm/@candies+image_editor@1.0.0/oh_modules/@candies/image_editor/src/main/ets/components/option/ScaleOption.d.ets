import image from '@ohos.multimedia.image';
import { EditOption } from './Option';
export declare class ScaleOption implements EditOption {
    static readonly key: string;
    constructor(width: number, height: number, keepRatio: boolean, keepWidthFirst: boolean);
    width: number;
    height: number;
    keepRatio: boolean;
    keepWidthFirst: boolean;
    canIgnore(): boolean;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
    static fromMap(data: Map<string, ESObject>): ScaleOption;
}
