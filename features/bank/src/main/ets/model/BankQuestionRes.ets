//题目表
export class BankQuestionRes {
  qId: string = ""
  q: string = ""
  //数据库存储需数组转换成string存储，拿的时候再转换成数组显示
  a: string[] = []
  ans: string = ""
}