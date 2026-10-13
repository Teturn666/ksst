import image from '@ohos.multimedia.image';
import { EditOption } from './Option';
import { common2D, drawing } from '@kit.ArkGraphics2D';
import { Offset } from '@kit.ArkUI';
export declare class DrawOption implements EditOption {
    static readonly key: string;
    draws: Array<DrawPart>;
    constructor(draws: Array<DrawPart>);
    static fromMap(data: Map<string, ESObject>): DrawOption;
    canIgnore(): boolean;
    handle(pixelMap: image.PixelMap): Promise<image.PixelMap>;
}
interface DrawPart {
    handle(canvas: drawing.Canvas): void;
    canIgnore(): boolean;
}
export declare class DrawPaint {
    static readonly key: string;
    color: common2D.Color;
    lineWeight: number;
    paintStyleFill: boolean;
    constructor(color: common2D.Color, lineWeight: number, paintStyleFill: boolean);
    static fromMap(data: Map<string, ESObject>): DrawPaint;
}
export declare class LineDrawPart implements DrawPart {
    static readonly key: string;
    start: Offset;
    end: Offset;
    paint: DrawPaint;
    constructor(paint: DrawPaint, start: Offset, end: Offset);
    static fromMap(data: Map<string, ESObject>): LineDrawPart;
    canIgnore(): boolean;
    handle(canvas: drawing.Canvas): void;
}
export declare class PointDrawPart implements DrawPart {
    static readonly key: string;
    offsets: Array<Offset>;
    paint: DrawPaint;
    constructor(paint: DrawPaint, offsets: Array<Offset>);
    static fromMap(data: Map<string, ESObject>): PointDrawPart;
    canIgnore(): boolean;
    handle(canvas: drawing.Canvas): void;
}
export declare class RectDrawPart implements DrawPart {
    static readonly key: string;
    rect: common2D.Rect;
    paint: DrawPaint;
    constructor(paint: DrawPaint, rect: common2D.Rect);
    static fromMap(data: Map<string, ESObject>): RectDrawPart;
    canIgnore(): boolean;
    handle(canvas: drawing.Canvas): void;
    drawRect(canvas: drawing.Canvas): void;
}
export declare class OvalDrawPart extends RectDrawPart {
    static readonly key: string;
    drawRect(canvas: drawing.Canvas): void;
}
export declare class PathDrawPart implements DrawPart {
    static readonly key: string;
    parts: Array<PathPart>;
    paint: DrawPaint;
    autoClose: boolean;
    constructor(paint: DrawPaint, parts: Array<PathPart>, autoClose: boolean);
    static fromMap(data: Map<string, ESObject>): PathDrawPart;
    canIgnore(): boolean;
    handle(canvas: drawing.Canvas): void;
    drawPath(canvas: drawing.Canvas): void;
}
declare abstract class PathPart {
    abstract handle(path: drawing.Path): void;
    canIgnore(): boolean;
}
export {};
