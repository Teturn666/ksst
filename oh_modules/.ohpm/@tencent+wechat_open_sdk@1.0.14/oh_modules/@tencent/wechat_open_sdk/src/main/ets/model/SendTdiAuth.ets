import { SendAuthReq, SendAuthResp } from './SendAuth'
import { Command } from './Constants'

export class SendTdiAuthReq extends SendAuthReq {

  get type() {
    return Command.kCommandSendTdiAuth
  }
}

export class SendTdiAuthResp extends SendAuthResp {
  tdiAuthBuffer?: Uint8Array

  serializeTo(to: object): void {
    super.serializeTo(to)
    if (this.tdiAuthBuffer != undefined) {
      to['tdiAuthBuffer'] = Array.from(this.tdiAuthBuffer)
    }
  }

  deserializeFrom(from: object): void {
    super.deserializeFrom(from)
    if (Array.isArray(from['tdiAuthBuffer'])) {
      this.tdiAuthBuffer = new Uint8Array(from['tdiAuthBuffer'])
    }
  }

  get type() {
    return Command.kCommandSendTdiAuth
  }
}
