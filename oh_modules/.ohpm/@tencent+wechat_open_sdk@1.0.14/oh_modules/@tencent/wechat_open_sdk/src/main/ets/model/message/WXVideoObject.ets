import { IMediaObject, MediaObjectType } from "./SendMessageToWX";

export class WXVideoObject implements IMediaObject {

  /**
   * 视频链接
   * @note 长度大于0且不超过10KB
   */
  videoUrl?: string

  /**
   * 供低带宽的环境下使用的视频链接
   * @note 长度大于0且不超过10KB
   */
  videoLowBandUrl?: string

  type: number = MediaObjectType.TYPE_VIDEO

  serializeTo(to: object): void {
    to['videoUrl'] = this.videoUrl
    to['videoLowBandUrl'] = this.videoLowBandUrl
  }

  deserializeFrom (from: object): void {
    this.videoUrl = from["videoUrl"]
    this.videoLowBandUrl = from["videoLowBandUrl"]
  }

  checkArgs(): boolean {
    if ((this.videoUrl == undefined || this.videoUrl.length == 0)
      && (this.videoLowBandUrl == undefined || this.videoLowBandUrl.length == 0)) {
      return false
    }
    return true
  }
}