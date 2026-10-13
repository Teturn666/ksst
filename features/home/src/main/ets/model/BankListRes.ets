//题库表
@Observed
export class BankListRes {
  // id: number = 0
  qid: number = 0
  name: string = ''
  desc: string = ''
  time: string = ''
  url: string = ''
  num: string = ''
  version: string = ''
  position: number = 0
  //1=已下载，2=未下载
  downloadedState: number = 2
}