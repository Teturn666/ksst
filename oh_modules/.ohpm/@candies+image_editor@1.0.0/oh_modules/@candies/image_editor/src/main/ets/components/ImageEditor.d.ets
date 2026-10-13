import { ImageMergeOption } from "./option/ImageMergeOption";
import { image } from "@kit.ImageKit";
import { EditOption } from "./option/Option";
import resourceManager from "@ohos.resourceManager";
export declare class ImageEditor {
    private constructor();
    private static _instance;
    static instance: ImageEditor;
    handleImageRawfile(rawfile: resourceManager.RawFileDescriptor, options: Array<EditOption>): Promise<PixelMap>;
    handleImageUri(uri: string, options: Array<EditOption>): Promise<PixelMap>;
    handleImageFileDescriptor(fd: number, options: Array<EditOption>): Promise<PixelMap>;
    handleImageBuffer(buffer: ArrayBuffer, options: Array<EditOption>): Promise<PixelMap>;
    handleImageSource(imageSource: image.ImageSource, packOptions: image.PackingOption, options: Array<EditOption>): Promise<Uint8Array>;
    handleImageWithOptions(imageSource: image.ImageSource, options: Array<EditOption>): Promise<PixelMap>;
    mergeImage(width: number, height: number, images: Array<ImageMergeOption>): Promise<PixelMap>;
}
