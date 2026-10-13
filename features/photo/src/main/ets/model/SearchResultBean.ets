//存储转换后搜索结果的对象
export class SearchResultBean {
  //问题
  question: string = '问题'
  //选项
  optionAry: string[] = ["A选项", "B选项", "C选项", "D选项"]
  //答案,存在多选答案的情况,存储正确选项的位置
  answerAry: number[] = [0, 1]
  //答案
  answer: string = '答案'
}