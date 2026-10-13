import { image } from '@kit.ImageKit';
import { ImageCropperConfig } from '../common/ImageCropperConfig';
import { geometry } from '../model/Geometry';
declare enum _MoveType {
    topLeft = 0,
    topRight = 1,
    bottomRight = 2,
    bottomLeft = 3,
    top = 4,
    right = 5,
    bottom = 6,
    left = 7
}
@Component
export declare struct ImageCropper {
    @Link
    image: image.ImageSource;
    @Link
    config?: ImageCropperConfig;
    @State
    pixelMap: PixelMap | null;
    @State
    private _actionDetails;
    @State
    private _area;
    @State
    private _refreshTag;
    @State
    private _rotationYRadians;
    private _config;
    private imageInfo;
    private _startingOffset;
    private _detailsScale;
    private _startingScale;
    private settings;
    private imageContext;
    private cropLayerContext;
    private _imageContextReady;
    private _cropLayerContextReady;
    private _pointerDown;
    private _cropRectMoveType;
    private _cropRectAutoCenterAnimator;
    private _cropRectAutoCenterRect;
    private _flipOrRotateAnimator;
    @State
    _isAnimating: boolean;
    private _history;
    private _currentIndex;
    private _debounceSaveCurrentEditActionDetails;
    private _brandColor;
    private _backgroundColor;
    onWillApplyTheme(theme: Theme): void;
    initSystemColor(theme: Theme): Promise<void>;
    onImageChanged(changedPropertyName: string): void;
    onConfigChanged(changedPropertyName: string): void;
    aboutToAppear(): void;
    dispose(): void;
    _startFlipOrRotateAnimation(begin: number, end: number, duration: number, flip: boolean, willRotateCropRect?: boolean): void;
    _startCropRectAutoCenterAnimation(begin: geometry.Rect, end: geometry.Rect): void;
    initImageInfo(): Promise<void>;
    init(): void;
    build(): void;
    private handleScaleStart;
    private handleScaleUpdate;
    initImageRect(outputSize: geometry.Size, inputSize: geometry.Size): void;
    setState(fn: () => void): void;
    private getNewCropRect;
    private initCropRect;
    private calculateCropRectFromAspectRatio;
    _updateRotationYRadians(rotationYRadians: number, pointerDown?: boolean): void;
    _updateRotateRadians(rotateRadians: number, pointerDown?: boolean): void;
    private flip;
    private _rotate;
    private reset;
    _drawImage(): void;
    _drawLayer(): void;
    touchOnCropRect(offset: geometry.Offset): _MoveType | null;
    moveCropRect(delta: geometry.Offset): void;
    _handleAspectRatio(gWidth: number, moveType: _MoveType, result: geometry.Rect, layerDestinationRect: geometry.Rect, delta: geometry.Offset): geometry.Rect;
    _doAspectRatioH(minD: number, result: geometry.Rect, aspectRatio: number, layerDestinationRect: geometry.Rect, isLeft: boolean): geometry.Rect;
    _doAspectRatioV(minD: number, result: geometry.Rect, aspectRatio: number, layerDestinationRect: geometry.Rect, isTop: boolean): geometry.Rect;
    _doWithMaxScale(rect: geometry.Rect): geometry.Rect | null;
    _doCropAutoCenterAnimation(newScreenCropRect: geometry.Rect): void;
    _updateUIIfNeed(fn: () => void): void;
    private _rotateCropRectStartRect;
    private _rotateCropRectStartTotalScale;
    private _cropRectRotateRadians;
    _rotateCropRectStart(): void;
    _rotateCropRect(rotateRadiansDelta: number): void;
    _rotateCropRectEnd(): void;
    private canRedo;
    private canUndo;
    private redo;
    private undo;
    _saveCurrentState(): void;
    private geActionDetails;
    updateCropAspectRatio(aspectRatio: number | null): void;
    _recalculateCropRect(): geometry.Rect;
    private _onEditActionDetailsIsChanged;
    private _getHistory;
    private _getCurrentIndex;
    private _getCroppedImage;
    _getImageCropRect(): geometry.Rect | null;
    private _getCurrentConfig;
}
export {};
