import { ChangeNotifier } from "../ChangeNotifier";
import { ImageCropperActionDetails } from "./ImageCropperActionDetails";
import { ImageCropperConfig } from "./ImageCropperConfig";
export interface FlipOptions {
    animation?: boolean;
    duration?: number;
}
export interface RotateOptions {
    degree?: number;
    animation?: boolean;
    duration?: number;
    rotateCropRect?: boolean;
}
export declare class ImageCropperController extends ChangeNotifier {
    flip: (options?: FlipOptions) => void;
    reset: () => void;
    rotate: (options?: RotateOptions) => void;
    canRedo: () => boolean;
    canUndo: () => boolean;
    redo: () => void;
    undo: () => void;
    getActionDetails: () => ImageCropperActionDetails;
    get rotateDegrees(): number;
    get cropAspectRatio(): number | null;
    get originalCropAspectRatio(): number | null;
    updateCropAspectRatio: (aspectRatio: number | null) => void;
    saveCurrentState: () => void;
    getHistory: () => Array<ImageCropperActionDetails>;
    getCurrentIndex: () => number;
    getCroppedImage: () => Promise<PixelMap | null>;
    getCurrentConfig: () => ImageCropperConfig | null;
}
