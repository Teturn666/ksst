import util from '@ohos.util';
import { Logger, StringUtils } from 'utils'
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

export class ChAesUtils {
  private static KEY: string = "QGKINVCYHLJXDYHLYYPZJXLLCBFMJHCH"
  private static newKey: string = ''

  //根据文件名不同走的解密方式也不同
  static async getAesStr(suffix: string, message: string, name: string): Promise<string> {
    let nKey = await ChAesUtils.getNewKey()
    ChAesUtils.newKey = nKey.substring(0, 16)
    if (".crypto2" === suffix) {
      return await ChAesUtils.aesDecryptNewSync(message, name)
    }
    return await ChAesUtils.aesDecryptSync(message, name)
  }

  //旧解密异步方法
  private static async aesDecryptSync(message: string, name: string): Promise<string> {

    let iv = (name + ChAesUtils.KEY).substring(0, 16)

    let paramsSpec: cryptoFramework.IvParamsSpec = {
      iv: { data: StringUtils.stringToUint8Array(iv) },
      algName: "IvParamsSpec"
    }

    let aesGenerator = cryptoFramework.createSymKeyGenerator('AES256');
    let cipher = cryptoFramework.createCipher('AES256|CBC|PKCS5');
    let that = new util.Base64Helper();
    let pubKeyBlob: cryptoFramework.DataBlob = { data: StringUtils.stringToUint8Array(ChAesUtils.KEY) };
    try {
      let symKey = await aesGenerator.convertKey(pubKeyBlob)

      await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, paramsSpec)

      let newMessage = that.decodeSync(message);
      let input: cryptoFramework.DataBlob = { data: newMessage };
      let data = cipher.doFinalSync(input);

      Logger.info("DecryptOutPut is " + data.data);
      let result = StringUtils.uint8ArrayToString(data.data)
      Logger.info("result is " + result);
      return result
    } catch (e) {
      Logger.debug("xxx" + e)
      return ""
    }
  }

  //新解密异步方法
  private static async aesDecryptNewSync(message: string, name: string) {
    let iv = (name + ChAesUtils.newKey).substring(0, 16)

    let paramsSpec: cryptoFramework.IvParamsSpec = {
      iv: { data: StringUtils.stringToUint8Array(iv) },
      algName: "IvParamsSpec"
    }

    let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let cipher = cryptoFramework.createCipher('AES128|CBC|PKCS5');
    let that = new util.Base64Helper();
    let pubKeyBlob: cryptoFramework.DataBlob = { data: StringUtils.stringToUint8Array(ChAesUtils.newKey) };
    try {
      let symKey = await aesGenerator.convertKey(pubKeyBlob)

      cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, paramsSpec)

      let newMessage = that.decodeSync(message);
      let input: cryptoFramework.DataBlob = { data: newMessage };
      let data = cipher.doFinalSync(input);

      Logger.info("DecryptOutPut is " + data.data);
      let result = StringUtils.uint8ArrayToString(data.data)
      Logger.info("result is " + result);
      return result
    } catch (e) {
      Logger.debug("xxx" + e)
      return ""
    }
  }

  /**
   * 新解密获取的key
   */
  private static async getNewKey(): Promise<string> {
    let endKey = '8F79D5657ECACF09D92B731989D13ED1'
    let reverseKey = ChAesUtils.KEY.split('').reverse().join('')
    let newKey = reverseKey + endKey
    let md = cryptoFramework.createMd('MD5')
    // 数据量较少时，可以只做一次update，将数据全部传入，接口未对入参长度做限制
    await md.update({ data: new Uint8Array(buffer.from(newKey, 'utf-8').buffer) });
    let mdResult = await md.digest();
    let value = buffer.from(mdResult.data).toString('hex')
    console.info('Md result:' + value);
    return value
  }
}