import { PayTrigger } from './PayTrigger';
import { HttpUtils } from 'network/Index';
import { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { PayPriceRes } from '../model/PayPriceRes';
import { PriceInfoRes } from '../model/PriceInfoRes';

const TAG = '[PayNet]'

export class PayNet {
  //获取支付结果
  public getBankTypeList(): Promise<PriceInfoRes[]> {
    let udid = '0'
    let data = "api=products&id=" + udid
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getVipInstance()
        .post(PayTrigger.PAY_PRICE_URL, data)
        .then((res: AxiosResponse<PayPriceRes>) => {
          let code = res.data.errno
          let data = res.data.data
          if (code === 0 && data != null && data.length > 0) {
            resolve(data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }
}