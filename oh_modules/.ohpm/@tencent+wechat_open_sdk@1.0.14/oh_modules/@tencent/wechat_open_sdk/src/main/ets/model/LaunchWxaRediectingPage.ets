import { Command } from "./Constants";
import { BaseReq, BaseResp } from "./Base";

export class LaunchWxaRedirectingPageReq extends BaseReq {

  invokeTicket?: string

  mediaUri?: string

  checkArgs(): boolean {
    if (!this.invokeTicket || this.invokeTicket.length === 0) {
      return false
    }
    return true
  }

  serializeTo(to: object): void {
    super.serializeTo(to)
    to['invokeTicket'] = this.invokeTicket
    to['mediaUri'] = this.mediaUri
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    this.invokeTicket = from['invokeTicket']
    this.mediaUri = from['mediaUri']
  }

  get type() {
    return Command.kCommandWxaRedirectingPage
  }
}

export class LaunchWxaRedirectingPageResp extends BaseResp {

  serializeTo(to: object): void {
    super.serializeTo(to)
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
  }

  get type() {
    return Command.kCommandWxaRedirectingPage
  }
}
