import { PriceInfoRes } from "./PriceInfoRes"

export class PayPriceRes {
  errno: number = 1
  msg: string = ""
  data: PriceInfoRes[] = []
}