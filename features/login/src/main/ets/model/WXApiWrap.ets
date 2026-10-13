import * as wxOpenSdk from '@tencent/wechat_open_sdk';

export type OnWXReq = (req: wxOpenSdk.BaseReq) => void

export type OnWXResp = (resp: wxOpenSdk.BaseResp) => void

export const APP_ID = 'wx4f844b28fe56146f'

const tag = 'WXApiEventHandlerImpl'

class WXApiEventHandlerImpl implements wxOpenSdk.WXApiEventHandler {
  private onReqCallbacks: Map<OnWXReq, OnWXReq> = new Map
  private onRespCallbacks: Map<OnWXResp, OnWXResp> = new Map

  registerOnWXReqCallback(on: OnWXReq) {
    this.onReqCallbacks.set(on, on)
  }

  unregisterOnWXReqCallback(on: OnWXReq) {
    this.onReqCallbacks.delete(on)
  }

  registerOnWXRespCallback(on: OnWXResp) {
    this.onRespCallbacks.set(on, on)
  }

  unregisterOnWXRespCallback(on: OnWXResp) {
    this.onRespCallbacks.delete(on)
  }

  onReq(req: wxOpenSdk.BaseReq): void {
    wxOpenSdk.Log.i(tag, 'onReq:%s', JSON.stringify(req))
    this.onReqCallbacks.forEach((on) => {
      on(req)
    })
  }

  onResp(resp: wxOpenSdk.BaseResp): void {
    wxOpenSdk.Log.i(tag, 'onResp:%s', JSON.stringify(resp))
    this.onRespCallbacks.forEach((on) => {
      on(resp)
    })
  }
}

export const WXApi = wxOpenSdk.WXAPIFactory.createWXAPI(APP_ID)

export const WXEventHandler = new WXApiEventHandlerImpl

