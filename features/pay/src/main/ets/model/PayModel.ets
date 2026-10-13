import { PayNet } from "../service/PayNet"
import { PriceInfoRes } from "./PriceInfoRes"

@Observed
export class PayModel {
  private payNet: PayNet
  private static instance: PayModel

  private constructor() {
    this.payNet = new PayNet()
  }

  public static getInstance(): PayModel {
    if (!PayModel.instance) {
      PayModel.instance = new PayModel()
    }
    return PayModel.instance
  }

  //获取会员价格列表
  public async getPayPriceList(): Promise<PriceInfoRes[]> {
    try {
      let data = await this.payNet.getBankTypeList()
      return data
    } catch (e) {
      return []
    }
  }
}