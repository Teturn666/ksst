import common from '@ohos.app.ability.common';
import { Command, kWechatBundleName, kWechatEntryAbility } from '../model/Constants';
import { bundleManager, OpenLinkOptions, Want, wantConstant } from '@kit.AbilityKit';
import { BaseReq, BaseResp, SendReqResult, SendReqResultWrap } from '../model/Base';
import { SendAuthReq, SendAuthResp } from '../model/SendAuth';
import { JointPayReq, JointPayResp, PayReq, PayResp } from '../model/Pay';
import { Log } from '../log/Log';
import { SendTdiAuthReq, SendTdiAuthResp } from '../model/SendTdiAuth';
import { MediaObjectType, SendMessageToWXReq, SendMessageToWXResp } from '../model/message/SendMessageToWX';
import { WXImageObject } from '../model/message/WXImageObject';
import { LaunchMiniProgramReq, LaunchMiniProgramResp } from '../model/LaunchMiniProgram';
import { BusinessError } from '@kit.BasicServicesKit';
import { OpenBusinessViewReq, OpenBusinessViewResp } from '../model/OpenBusinessView';
import { LaunchFromWXReq } from '../model/LaunchFromWX';
import { LaunchWxaRedirectingPageReq, LaunchWxaRedirectingPageResp } from '../model/LaunchWxaRediectingPage';
import { WXFileObject } from '../model/message/WXFileObject';
import { WXVideoFileObject } from '../model/message/WXVideoFileObject';

type RespWrap = BaseResp | PromiseLike<BaseResp>
type RespCallback = (resp: RespWrap) => void

const kTag = 'wxopensdk::WXApi'

const kWantCallerBundleNameKey = "ohos.aafwk.param.callerBundleName"
const kWantRequestKey = "wxopensdk_request"
const kWantResponseKey = "wxopensdk_response"
const kWantAppidKey = "wxopensdk_appid"

const kWechatBundleNameCandidates = [
  "com.tencent.wechat.debug",
  "com.tencent.wechat.red",
  "com.tencent.wechat.purple",
  "com.tencent.wechat.blue",
  "com.tencent.wechat.yellow"
]

const kWechatLink = "wxopensdk://open_sdk_request_link"

export interface WXApi {
  sendReq(context: common.UIAbilityContext, req: BaseReq): SendReqResultWrap

  openWechat(context: common.UIAbilityContext): SendReqResultWrap

  handleWant(want: Want, eventHandler: WXApiEventHandler): boolean

  isWXAppInstalled(): boolean

  /*
  sendReqHelper(context: common.UIAbilityContext, req: Base.BaseReq): Base.BaseResp | Promise<Base.BaseResp>

  onResult(response: Base.BaseResp): void
  */
}

export interface WXApiEventHandler {
  onReq(req: BaseReq): void

  onResp(req: BaseResp): void
}

export class WXAPIFactory {
  static createWXAPI(appId: string): WXApi {
    return new WXApiImpl(appId)
  }

  static createReq(wantParameters: object): BaseReq | undefined {
    let type: number = wantParameters['__type__'] ?? -1
    let req =
      ((): BaseReq | undefined => {
        switch (type) {
          case Command.kCommandSendAuth: return new SendAuthReq
          case Command.kCommandSendTdiAuth: return new SendTdiAuthReq
          case Command.kCommandSendMessageToWX: return new SendMessageToWXReq
          case Command.kCommandPay: return new PayReq()
          case Command.kCommandJointPay: return new JointPayReq()
          case Command.kCommandLaunchFromWX: return new LaunchFromWXReq
          case Command.kCommandLaunchMiniProgram: return new LaunchMiniProgramReq
          case Command.kCommandOpenBusinessView: return new OpenBusinessViewReq
          case Command.kCommandWxaRedirectingPage: return new LaunchWxaRedirectingPageReq
          default: return
        }
      })()
    req?.deserializeFrom(wantParameters)
    return req
  }

  static createResp(wantParameters: object): BaseResp | undefined {
    let type: number = wantParameters['__type__'] ?? -1
    let resp =
      ((): BaseResp | undefined => {
        switch (type) {
          case Command.kCommandSendAuth: return new SendAuthResp
          case Command.kCommandSendTdiAuth: return new SendTdiAuthResp
          case Command.kCommandSendMessageToWX: return new SendMessageToWXResp
          case Command.kCommandPay: return new PayResp
          case Command.kCommandJointPay: return new JointPayResp
          case Command.kCommandLaunchMiniProgram: return new LaunchMiniProgramResp
          case Command.kCommandOpenBusinessView: return new OpenBusinessViewResp
          case Command.kCommandWxaRedirectingPage: return new LaunchWxaRedirectingPageResp
          default: return
        }
      })()
    resp?.deserializeFrom(wantParameters)
    return resp
  }
}

class WXApiImpl implements WXApi {
  private readonly appId: string
  constructor(appId: string) {
    this.appId = appId;
  }

  private static NextId = 0;
  private resolves = new Map<number, RespCallback>();
  private eventHandler?: WXApiEventHandler

  static reqToWantObject(req?: BaseReq): object | undefined {
    if (req) {
      let obj: ESObject = {}
      req.serializeTo(obj)
      if (obj['__type__'] !== req.type) {
        Log.e(kTag, 'super.serializedTo must be called')
      }
      return obj
    } else {
      return undefined
    }
  }

  private makeParameters(request?: BaseReq): Record<string, Object> {
    let parameters: Record<string, Object> = {}
    parameters[kWantRequestKey] = WXApiImpl.reqToWantObject(request) ?? ""
    parameters[kWantAppidKey] = this.appId
    parameters["from"] = "_wechat_open_sdk"
    parameters["linkFeature"] = "Pay"
    return parameters
  }

  private makeWant(request?: BaseReq, wechatBundleName?: string): Want {
    let uri: string | undefined = undefined
    let action: string | undefined = undefined
    let flags: number | undefined = undefined

    if (request && request.type === Command.kCommandSendMessageToWX) {
      let sendMessageReq = request as SendMessageToWXReq
      if (sendMessageReq.checkArgs()) {
        if (sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_IMAGE) {
          let imageObject = sendMessageReq.message?.mediaObject as WXImageObject
          uri = imageObject.uri
        } else if (sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_FILE) {
          let fileObject = sendMessageReq.message?.mediaObject as WXFileObject
          uri = fileObject.fileUri
        } else if (sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_VIDEO_FILE) {
          let videoFileObject = sendMessageReq.message?.mediaObject as WXVideoFileObject
          uri = videoFileObject.fileUri
        }

      }
    } else if (request && request.type === Command.kCommandWxaRedirectingPage) {
      uri = (request as LaunchWxaRedirectingPageReq).mediaUri?.trim()
    }
    if (uri != undefined && uri.length > 0) {
      action = 'ohos.want.action.sendData'
      flags = wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION
    }

    return {
      bundleName: wechatBundleName ?? kWechatBundleName,
      abilityName:kWechatEntryAbility,
      parameters: this.makeParameters(request),
      action: action,
      uri: uri,
      flags: flags
    }
  }

  private openWeChatWithLink(context: common.UIAbilityContext, req?: BaseReq): SendReqResultWrap {
    return new Promise<SendReqResult>(async (resolve) => {
      const linkOptions: OpenLinkOptions = {
        appLinkingOnly: false,
        parameters: this.makeParameters(req)
      }
      try {
        await context.openLink(kWechatLink, linkOptions, (err, abilityResult) => {
          if (err && err.code != 0) {
            Log.e(kTag, `openWeChatWithLink result err: ${err.message}`)
            return
          }
          this.handleResult(abilityResult)
        })
        resolve(true)
      } catch (e) {
        Log.e(kTag, `openWeChatWithLink fail by err: ${e.message}`)
        resolve(false)
      }
    })
  }

  private openWechatWithWant(context: common.UIAbilityContext, req?: BaseReq): SendReqResultWrap {
    return new Promise<SendReqResult>((resolve) => {
      let bundleNames: Array<string> = []
      bundleNames.push(kWechatBundleName)
      bundleNames.push(...kWechatBundleNameCandidates)

      ;(async () => {
        let openSucceed = false
        for (let name of bundleNames) {
          let want = this.makeWant(req, name)
          try {
            await context.startAbility(want)
            openSucceed = true
            resolve(true)
            return
          } catch (e) {
            Log.e(kTag, `openWechatWithWant fail by err: ${e.message}`)
          }
        }
        resolve(openSucceed)
      })()
    })
  }

  private handleResult(result: common.AbilityResult) {
    Log.i(kTag, `handleResult, result = ${JSON.stringify(result)}`)
    if (result.resultCode != 0) {
      return
    }
    this.handleWantInternal(result.want)
  }

  private handleWantInternal(want?: Want): void {
    if (want?.parameters === undefined) {
      return
    }

    let reqWrap = want.parameters[kWantRequestKey]
    if (reqWrap) {
      let req = WXAPIFactory.createReq(reqWrap)
      if (req) {
        this.eventHandler?.onReq(req)
      }
    }

    let respWrap = want.parameters[kWantResponseKey]
    if (respWrap) {
      let resp = WXAPIFactory.createResp(respWrap)
      if (resp) {
        this.eventHandler?.onResp(resp)
      }
    }
  }

  private canOpenWithLink(req: BaseReq): boolean {
    try {
      if (!bundleManager.canOpenLink(kWechatLink)) {
        return false
      }
    } catch (e) {
      Log.e(kTag, `canOpenLink fail by err: ${e.message}`)
      return false
    }

    if (req.type === Command.kCommandSendMessageToWX) {
      const sendMessageReq = req as SendMessageToWXReq
      if (sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_IMAGE) {
        const imageObject = sendMessageReq.message!.mediaObject as WXImageObject
        return imageObject.uri === undefined || imageObject.uri.trim().length === 0
      } else if (sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_FILE) {
        const fileObject = sendMessageReq.message!.mediaObject as WXFileObject
        return fileObject.fileUri === undefined || fileObject.fileUri.trim().length === 0
      } else if (sendMessageReq.message?.mediaObject?.type === MediaObjectType.TYPE_VIDEO_FILE) {
        const videoFileObject = sendMessageReq.message!.mediaObject as WXVideoFileObject
        return videoFileObject.fileUri === undefined || videoFileObject.fileUri.trim().length === 0
      }
    } else if (req.type === Command.kCommandWxaRedirectingPage) {
      const launchReq = req as LaunchWxaRedirectingPageReq
      return launchReq.mediaUri === undefined || launchReq.mediaUri.trim().length === 0
    }

    return true
  }

  sendReq(context: common.UIAbilityContext, req: BaseReq): SendReqResultWrap {
    if (this.canOpenWithLink(req)) {
      Log.i(kTag, 'sendReq, use link')
      return this.openWeChatWithLink(context, req)
    }
    Log.i(kTag, 'sendReq, use want')
    return this.openWechatWithWant(context, req)
  }

  openWechat(context: common.UIAbilityContext): SendReqResultWrap {
    return this.openWechatWithWant(context, undefined)
  }

  handleWant(want: Want, eventHandler: WXApiEventHandler): boolean {
    this.eventHandler = eventHandler
    if (want.parameters && typeof want.parameters[kWantCallerBundleNameKey] === 'string') {
      let callerBundleName = want.parameters[kWantCallerBundleNameKey]
      if (callerBundleName !== kWechatBundleName && !kWechatBundleNameCandidates.includes(callerBundleName)) {
        return false
      }
      this.handleWantInternal(want)
      return true
    } else {
      return false
    }
  }

  isWXAppInstalled(): boolean {
    try {
      return bundleManager.canOpenLink("weixin://")
    } catch (e) {
      let code = (e as BusinessError)?.code
      let msg = (e as BusinessError)?.message ?? ''
      if (code !== undefined) {
        if (code === 17700056) {
          msg += ` Please include "weixin" inside the "querySchemes" element of module.json5 in your app module.`
        }
        Log.e(kTag, `isWXAppInstalled get error ${msg}`)
      } else {
        Log.e(kTag, `isWXAppInstalled get error ${e}`)
      }
      return false
    }
  }

  /*
  sendReqHelper(context: common.UIAbilityContext, request: Base.BaseReq): Promise<Base.BaseResp> {
    let id = this.id++;
    request.id = id;
    return new Promise<Base.BaseResp>((resolve) => {
      context.startAbility(this.makeWant(request)).then(() => {
        this.resolves.set(this.id, resolve);
        setTimeout(() => {
          let response = new Base.BaseResp()
          response.errCode = ErrorCode.TIMEOUT
          response.errMsg = 'timeout'
          resolve(response)
          this.resolves.delete(id)
        }, 5000)
      }).catch((err: BusinessError) => {
        Log.Logw.e(kTag, 'sendReq fail by err:%s', JSON.stringify(err))
        let response = new BaseResponse()
        response.errCode = ErrorCode.REQUEST_FAILED
        response.errMsg = err.message
        resolve(response)
        this.resolves.delete(id)
      });
    });
  }
  */

}

