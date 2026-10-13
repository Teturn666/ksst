import { IMediaObject, MediaObjectType } from './SendMessageToWX';

export class WXWebpageObject implements IMediaObject {

  type: number = MediaObjectType.TYPE_URL

  /**
   * html 链接
   * @note 长度大于0且不超过10KB
   */
  webpageUrl?: string

  /**
   * 拓展信息
   */
  extInfo?: string

  /**
   * canvas链接
   */
  canvasPageXml?: string

  /**
   * 是否是私密消息
   */
  isSecretMessage?: boolean = false

  /**
   * 业务所需的额外信息
   */
  private extraInfoMap?: Map<string, string>

  serializeTo(to: object): void {
    to['wx_webpage_url'] = this.webpageUrl
    to['wx_webpage_extinfo'] = this.extInfo
    to['wx_webpage_canvaspagexml'] = this.canvasPageXml
    to['wx_webpage_issecretmsg'] = this.isSecretMessage
    if (this.extraInfoMap != undefined) {
      const extraInfoObject: Record<string, string> = {}
      this.extraInfoMap.forEach((value, key) => {
        extraInfoObject[key] = value
      })
      to['wx_webpage_extrainfo'] = extraInfoObject
    }
  }

  deserializeFrom (from: object): void {
    this.webpageUrl = from["wx_webpage_url"]
    this.extInfo = from['wx_webpage_extinfo']
    this.canvasPageXml = from['wx_webpage_canvaspagexml']
    this.isSecretMessage = from['wx_webpage_issecretmsg']
    if (from["wx_webpage_extrainfo"] != undefined) {
      const extraInfoObject: Record<string, string> = from["wx_webpage_extrainfo"]
      this.extraInfoMap = new Map(Object.entries(extraInfoObject))
    }
  }

  checkArgs(): boolean {
    if (this.webpageUrl == undefined || this.webpageUrl.length == 0 || this.webpageUrl.length > 1024 * 10) {
      return false
    }
    return true
  }

  putExtra(key: string, value: string): void {
    if (this.extraInfoMap == undefined) {
      this.extraInfoMap = new Map()
    }
    this.extraInfoMap!.set(key, value)
  }

  getExtra(key: string, defaultValue: string): string {
    return this.extraInfoMap?.get(key) ?? defaultValue
  }
}