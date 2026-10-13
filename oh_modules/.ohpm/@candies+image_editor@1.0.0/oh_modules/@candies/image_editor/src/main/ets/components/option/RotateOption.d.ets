import image from '@ohos.multimedia.image';
import { EditOption } from './Option';
export declare class RotateOption implements EditOption {
    static readonly key: string;
    constructor(degree: number);
    degree: number;
    canIgnore(): boolean;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
    static fromMap(data: Map<string, ESObject>): RotateOption;
}
