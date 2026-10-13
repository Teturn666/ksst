export class PriceInfoRes {
  id: string = ""
  name: string = ""
  showtext: string = ""
  days: number = 1
  price: number = 1
  amount: number = 1

  constructor(data?: Partial<PriceInfoRes>) {
    if (data) {
      this.id = data.id ?? "";
      this.name = data.name ?? "";
      this.showtext = data.showtext ?? "";
      this.days = data.days ?? 1;
      this.price = data.price ?? 1;
      this.amount = data.amount ?? 1;
    }
  }


  get priceTr() {
    return this.amount * 1.0 / 100
  }

  get priceOrigin() {
    return this.price * 1.0 / 100
  }

}