import { Offset } from '@kit.ArkUI';
export declare class ImageMergeOption {
    image: PixelMap;
    offset: Offset;
    width: number;
    height: number;
    constructor(image: PixelMap, offset: Offset, width: number, height: number);
    handle(context: OffscreenCanvasRenderingContext2D): Promise<void>;
}
