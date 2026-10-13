import { IMediaObject, MediaObjectType } from "./SendMessageToWX";

export class WXFileObject implements IMediaObject {

  /**
   * 文件路径uri
   */
  fileUri?: string;

  type: number = MediaObjectType.TYPE_FILE;

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