//搜索结果页数据
export class SearchResultRes {
  //题库名称
  Name: string = ''
  id: string = ''
  aid: string = ''
  qid: string = ''
  //问题
  q: string = ''
  a: string = ''
  //正确答案
  ans: string = ''
  father: number = 0
  //选项
  ASlice: string[] = []
  //答案,存在多选答案的情况,存储正确选项的位置
  answerAry: number[] = []
}