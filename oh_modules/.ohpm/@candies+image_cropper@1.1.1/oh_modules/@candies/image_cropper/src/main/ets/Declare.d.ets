import { ImageCropperActionDetails } from './common/ImageCropperActionDetails';
import { image } from '@kit.ImageKit';
import { ImageCropperConfig } from './common/ImageCropperConfig';
export declare type EditorMaskColorHandler = (pointerDown: boolean) => string | number | CanvasGradient | CanvasPattern;
export declare type ActionDetailsIsChanged = (details: ImageCropperActionDetails | null) => void;
export declare type InitCropperConfigHandler = (imageInfo: image.ImageInfo) => ImageCropperConfig;
