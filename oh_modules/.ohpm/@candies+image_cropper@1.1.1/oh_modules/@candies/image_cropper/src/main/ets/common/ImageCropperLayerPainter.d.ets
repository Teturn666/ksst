import { geometry } from '../model/Geometry';
export declare class ImageCropperLayerPainter {
    paint(config: ImageCropperLayerPainterConfig): void;
    protected paintCorners(config: ImageCropperLayerPainterConfig): void;
    protected paintMask(config: ImageCropperLayerPainterConfig): void;
    protected paintLines(config: ImageCropperLayerPainterConfig): void;
}
export interface ImageCropperLayerPainterConfig {
    canvas: CanvasRenderingContext2D;
    cropRect: geometry.Rect;
    layoutRect: geometry.Rect;
    cornerColor: string | number | CanvasGradient | CanvasPattern;
    lineColor: string | number | CanvasGradient | CanvasPattern;
    lineHeight: number;
    maskColor: string | number | CanvasGradient | CanvasPattern;
    pointerDown: boolean;
    cornerSize: geometry.Size;
}
