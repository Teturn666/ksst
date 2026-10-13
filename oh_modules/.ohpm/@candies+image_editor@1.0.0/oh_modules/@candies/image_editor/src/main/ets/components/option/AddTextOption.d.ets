import image from '@ohos.multimedia.image';
import { EditOption } from './Option';
import { common2D, drawing } from '@kit.ArkGraphics2D';
export declare class AddTextOption implements EditOption {
    static readonly key: string;
    texts: Array<EditorText>;
    constructor(texts: Array<EditorText>);
    static fromMap(data: Map<string, ESObject>): AddTextOption;
    canIgnore(): boolean;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
}
export declare class EditorText {
    text: string;
    fontName: string | null;
    x: number;
    y: number;
    size: number;
    color: common2D.Color;
    fontFilePath: string | null;
    constructor(text: string, x: number, y: number, size: number, color: common2D.Color, fontFilePath?: string | null, fontName?: string | null);
    static fromMap(data: Map<string, ESObject>): EditorText;
    canIgnore(): boolean;
    handle(canvas: drawing.Canvas): Promise<void>;
}
