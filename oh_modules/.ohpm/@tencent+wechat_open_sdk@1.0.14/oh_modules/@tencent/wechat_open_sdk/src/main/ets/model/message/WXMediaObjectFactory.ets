import { MediaObjectType } from './SendMessageToWX';
import { IMediaObject } from './SendMessageToWX';
import { WXFileObject } from './WXFileObject';
import { WXImageObject } from './WXImageObject';
import { WXMiniProgramObject } from './WXMiniProgramObject';
import { WXTextObject } from './WXTextObject';
import { WXWebpageObject } from './WXWebpageObject';
import { WXVideoFileObject } from './WXVideoFileObject';
import { WXVideoObject } from './WXVideoObject';

export class WXMediaObjectFactory {
  static createMediaObject(type: number): IMediaObject | undefined {
    if (type === MediaObjectType.TYPE_TEXT) {
      return new WXTextObject
    } else if (type === MediaObjectType.TYPE_IMAGE) {
      return new WXImageObject
    } else if(type === MediaObjectType.TYPE_URL) {
      return new WXWebpageObject()
    } else if(type === MediaObjectType.TYPE_OPENSDK_APPBRAND) {
      return new WXMiniProgramObject()
    } else if (type === MediaObjectType.TYPE_FILE) {
      return new WXFileObject()
    } else if (type === MediaObjectType.TYPE_VIDEO_FILE) {
      return new WXVideoFileObject()
    } else if (type === MediaObjectType.TYPE_VIDEO) {
      return new WXVideoObject()
    }
    // add more object convert
    return undefined
  }
}