import { BankListRes, questionBankTable, questionWrongTable, questionCollectionTable,questionTable, QuestionRes } from 'db'
import { LoadingStatus, Logger } from 'utils/Index'

const TAG = '[HomeModel]'

@Observed
export class HomeModel {
  private static instance: HomeModel
  loadingStatus: LoadingStatus = LoadingStatus.OFF

  private constructor() {
  }

  public static getInstance(): HomeModel {
    if (!HomeModel.instance) {
      HomeModel.instance = new HomeModel()
    }
    return HomeModel.instance
  }



  //获取数据库下载的题库
  public async getBankList(): Promise<BankListRes[]> {
    let bankResultList = await questionBankTable.querySync(0) ?? [];

    Logger.info(TAG, '下载的题库--------' + bankResultList.length)
    return bankResultList
  }
  //获取题库中的题目
  public async getBankQuestionList(qid:number): Promise<QuestionRes[]> {
    let resultList = await questionTable.querySync(qid,false) ?? [];

    Logger.info(TAG, '题库的题目--------' + JSON.stringify(resultList))
    return resultList
  }

  //获取数据库错题的题库
  public async getWrongBankList(): Promise<BankListRes[]> {
    const bankList: BankListRes[] = []
    let wrongResultList = await questionWrongTable.querySync(0) ?? [];
    if (wrongResultList.length > 0) {
      for (const item of wrongResultList) {
        let bankResultList = await questionBankTable.querySync(item.qId, false) ?? [];
        if (bankResultList.length > 0) {
          bankList.push(bankResultList[0])
        }
      }
    }
    Logger.info(TAG, '错题的题库--------' + bankList.length)
    return bankList
  }

  //获取数据库错题的题目
  public async getWrongQuestionList(qId: number): Promise<QuestionRes[]> {
    let wrongResultList = await questionWrongTable.querySync(qId, false) ?? [];
    return wrongResultList
  }

  //获取数据库收藏的题库
  public async getCollectionBankList(): Promise<BankListRes[]> {
    const bankList: BankListRes[] = []
    let collectionResultList = await questionCollectionTable.querySync(0) ?? [];
    if (collectionResultList.length > 0) {
      for (const item of collectionResultList) {
        let bankResultList = await questionBankTable.querySync(item.qId, false) ?? [];
        if (bankResultList.length > 0) {
          bankList.push(bankResultList[0])
        }
      }
    }
    Logger.info(TAG, '收藏的题库--------' + bankList.length)
    return bankList
  }

  //获取数据库收藏的题目
  public async getCollectionQuestionList(qId: number): Promise<QuestionRes[]> {
    let collectionResultList = await questionCollectionTable.querySync(qId, false) ?? [];
    return collectionResultList
  }

  //查询题库信息
  public async queryQuestionBankList(qId:number): Promise<BankListRes[]> {
    let QuestionBankList = await questionBankTable.querySync(qId, false) ?? [];
    return QuestionBankList
  }
}