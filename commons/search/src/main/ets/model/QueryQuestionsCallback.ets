import { QuestionRes } from 'db/Index'
import { QuestionBean } from './QuestionBean'

export interface QueryQuestionsCallback {

  //搜索后返回数组数据
  resultList(q: string, questions: Array<QuestionRes> | null): void

  //搜索后返回单个数据
  resultInfo(q: string, question: QuestionRes | null): void

  //获取拼接后的数据
  parser(q: string, questions: Array<QuestionBean> | null): void
}