import { ActionDetailsIsChanged, EditorMaskColorHandler } from "../Declare";
import { geometry } from '../model/Geometry';
import { ImageCropperController } from "./ImageCropperController";
import { ImageCropperLayerPainter } from "./ImageCropperLayerPainter";
export declare class CropAspectRatios {
    static custom: number | null;
    static original: number;
    static ratio1_1: number;
    static ratio3_4: number;
    static ratio4_3: number;
    static ratio9_16: number;
    static ratio16_9: number;
}
export declare enum InitCropRectType {
    imageRect = 0,
    layoutRect = 1
}
export interface ImageCropperConfigOptions {
    maxScale?: number;
    cropRectPadding?: geometry.EdgeInsets;
    cornerSize?: geometry.Size;
    cornerColor?: string | number | CanvasGradient | CanvasPattern;
    lineColor?: string | number | CanvasGradient | CanvasPattern;
    lineHeight?: number;
    editorMaskColorHandler?: EditorMaskColorHandler;
    hitTestSize?: number;
    cropRectAutoCenterAnimationDuration?: number;
    cropAspectRatio?: number | null;
    initialCropAspectRatio?: number | null;
    initCropRectType?: InitCropRectType;
    cropLayerPainter?: ImageCropperLayerPainter;
    speed?: number;
    actionDetailsIsChanged?: ActionDetailsIsChanged;
    controller?: ImageCropperController;
}
export declare class ImageCropperConfig {
    maxScale: number;
    cropRectPadding: geometry.EdgeInsets;
    cornerSize: geometry.Size;
    cornerColor?: string | number | CanvasGradient | CanvasPattern;
    lineColor?: string | number | CanvasGradient | CanvasPattern;
    lineHeight: number;
    editorMaskColorHandler?: EditorMaskColorHandler;
    hitTestSize: number;
    cropRectAutoCenterAnimationDuration: number;
    cropAspectRatio: number | null;
    initialCropAspectRatio: number | null;
    initCropRectType: InitCropRectType;
    cropLayerPainter: ImageCropperLayerPainter;
    speed: number;
    actionDetailsIsChanged?: ActionDetailsIsChanged;
    controller?: ImageCropperController;
    constructor(options?: ImageCropperConfigOptions);
    copyWith(option?: ImageCropperConfigOptions): ImageCropperConfig;
}
