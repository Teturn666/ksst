import bundleManager from '@ohos.bundle.bundleManager';
import Logger from './Logger';
import { buffer, util } from '@kit.ArkTS';
import { preferences } from '@kit.ArkData';
import { CommonConstants } from '../common/CommonConstants';

let context = getContext()

export class ChPackageUtils {
  static getPackage() {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then(bundleInfo => {
        Logger.info("---->" + bundleInfo.name)
      })
  }

  static async getVersionName(): Promise<string> {
    let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
    Logger.info("---->" + bundleInfo.versionName)
    return bundleInfo.versionName
  }

  static getDeviceId(): string {
    let uuId: string = util.generateRandomUUID(true)
    let base64 = new util.Base64Helper()
    let uint8Array = new Uint8Array(buffer.from(uuId).buffer)
    let deviceId = base64.encodeToStringSync(uint8Array)
    return deviceId
  }

  static getChannel(): string {
    let base64 = new util.Base64Helper()
    let uint8Array = new Uint8Array(buffer.from("harmony").buffer)
    let channel = base64.encodeToStringSync(uint8Array)
    return channel
  }

  static getUnionId(): string {
    let base64 = new util.Base64Helper()
    let sp = preferences.getPreferencesSync(context, CommonConstants.SP_OPTIONS)
    let unionId = sp.getSync(CommonConstants.SP_UNION_ID, '')
    if (typeof unionId === 'string' && unionId != '') {
      let uint8Array = new Uint8Array(buffer.from(unionId).buffer)
      return base64.encodeToStringSync(uint8Array)
    }
    return ""
  }

  static getOpenId(): string {
    let base64 = new util.Base64Helper()
    let sp = preferences.getPreferencesSync(context, CommonConstants.SP_OPTIONS)
    let openId = sp.getSync(CommonConstants.SP_OPEN_ID, '')
    if (typeof openId === 'string' && openId != '') {
      let uint8Array = new Uint8Array(buffer.from(openId).buffer)
      return base64.encodeToStringSync(uint8Array)
    }
    return ""
  }
}