import { drawing } from '@kit.ArkGraphics2D';
import { EditOption } from './Option';
import image from '@ohos.multimedia.image';
export declare class MixImageOption implements EditOption {
    static readonly key: string;
    private static blendModeMap;
    constructor(target: Uint8Array, x: number, y: number, width: number, height: number, blendModeStr: drawing.BlendMode | undefined);
    static fromMap(data: Map<string, ESObject>): MixImageOption;
    target: Uint8Array;
    x: number;
    y: number;
    width: number;
    height: number;
    blendMode: drawing.BlendMode | undefined;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
    canIgnore(): boolean;
}
