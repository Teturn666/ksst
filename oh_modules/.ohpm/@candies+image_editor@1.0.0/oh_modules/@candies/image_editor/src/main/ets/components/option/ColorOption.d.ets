import image from '@ohos.multimedia.image';
import { EditOption } from './Option';
export declare class ColorOption implements EditOption {
    static readonly key: string;
    constructor(data: Map<string, ESObject>);
    matrix: ColorFilter;
    canIgnore(): boolean;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
}
