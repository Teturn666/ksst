import { IMediaObject, MediaObjectType } from "./SendMessageToWX";

/**
 * 目前只支持分享到朋友圈
 */
export class WXVideoFileObject implements IMediaObject {

  /**
   * 文件路径uri
   */
  fileUri?: string;

  type: number = MediaObjectType.TYPE_VIDEO_FILE;

  serializeTo(to: object): void {
    to['fileUri'] = this.fileUri;
  }

  deserializeFrom(from: object): void {
    this.fileUri = from["fileUri"];
  };

  checkArgs(): boolean {
    if (this.fileUri == undefined) {
      return false;
    }
    return true;
  }
}