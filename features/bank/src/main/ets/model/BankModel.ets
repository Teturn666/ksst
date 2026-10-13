import { questionBankTable, questionTable, BankListRes, QuestionRes } from 'db'
import { SearchDecryptUtils } from 'search'
import { Logger, StringUtils } from 'utils'
import { plainToClass } from 'class-transformer'
import { BankNet } from '../service/BankNet'
import { BankCategory } from './BankCategory'
import { BankQuestionRes } from './BankQuestionRes'
import { SearchQuestionRes } from './SearchQuestionRes'

const TAG = '[BankModel]'


@Observed
export class BankModel {
  private bankNet: BankNet
  private static instance: BankModel

  private constructor() {
    this.bankNet = new BankNet()
  }

  public static getInstance(): BankModel {
    if (!BankModel.instance) {
      BankModel.instance = new BankModel()
    }
    return BankModel.instance
  }

  //删除数据库
  async deleteTable(qid: number) {
    //删除相应的题库表
    let bankResultList = await questionBankTable.querySync(qid, false) ?? [];
    if (bankResultList.length > 0) {
      let bankRes = bankResultList[0]
      questionBankTable.deleteData(bankRes, (resFlag: boolean) => {
        Logger.info(TAG, '题库deleteData--------' + resFlag)
      })
    }
    //删除相应的题目表
    let bankQaResultList = await questionTable.querySync(qid, false) ?? [];
    if (bankQaResultList.length > 0) {
      bankQaResultList.forEach((item) => {
        questionTable.deleteData(item, (resFlag: boolean) => {
          Logger.info(TAG, '题目deleteData--------' + resFlag)
        })
      })
    }
  }

  //获取热门搜索列表
  public async getHotSearchList(): Promise<string[]> {
    try {
      let data = await this.bankNet.getHotSearchList()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }


  //获取题库tab类型目录列表
  public async getBankTypeList(): Promise<BankCategory[]> {
    try {
      let data = await this.bankNet.getBankTypeList()
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }

  //获取数据库已经下载的题库
  public async getDownloadBankList():
    Promise<BankListRes[]> {
    let bankResultList = await questionBankTable.querySync(0) ?? [];

    Logger.info(TAG, '下载的题库--------' + bankResultList.length)
    return bankResultList
  }

  //获取题库列表
  public async getBankList(aid: string, pageNo: number): Promise<BankListRes[]> {
    let bankList: BankListRes[] = []
    try {
      let data = await this.bankNet.getBankList(aid, pageNo)
      for (let item of data) {
        let result = await questionBankTable.querySync(item.qid, false) ?? []
        Logger.info(TAG, 'result--------' + result)
        if (result.length > 0) {
          bankList.push(result[0])
        } else {
          bankList.push(item)
          // Logger.info(TAG, `Search bank result22: ${JSON.stringify(data)}`)
        }
      }
      return bankList
    } catch (e) {
      return []
    }
  }

  //搜索题库列表
  public async getSearchBankList(content: string, pageNo: number): Promise<BankListRes[]> {
    let bankList: BankListRes[] = []
    try {
      let data = await this.bankNet.getSearchBankList(content, pageNo)
      Logger.info(TAG, `Search bank result: ${JSON.stringify(data)}`)
      for (let item of data) {
        let result = await questionBankTable.querySync(item.qid, false) ?? []
        Logger.info(TAG, 'result--------' + result)
        if (result.length > 0) {
          bankList.push(result[0])
        } else {
          bankList.push(item)
          // Logger.info(TAG, `Search bank result22: ${JSON.stringify(data)}`)
        }
      }
      return bankList
    } catch (e) {
      // Logger.error(TAG, `Error in getSearchBankList: ${e}`);
      return []
    }
  }

  //搜索题目列表
  public async getSearchQuestionList(content: string, pageNo: number): Promise<SearchQuestionRes[]> {
    let questionList: SearchQuestionRes[] = []
    try {
      let data = await this.bankNet.getSearchQuestionList(content, pageNo.toString());
      Logger.info(TAG, `Search bank result: ${JSON.stringify(data)}`);
      for (let item of data) {
        let result = await questionBankTable.querySync(Number(item.qid), false) ?? []
        Logger.info(TAG, 'result--------' + result)

        if (result.length > 0) {
          item.downloadedState = 1
        } else {
          item.downloadedState = 2
        }
        questionList.push(item)
      }
      return questionList
    } catch (e) {
      Logger.error(TAG, `Error in getSearchBankList: ${e}`);
      return [];
    }
  }

  //单个题目详情
  public async getBankDetail(id: string): Promise<BankListRes> {
    try {
      let data = await this.bankNet.getBankDetail(id);
      Logger.info(TAG, `Search bank result: ${JSON.stringify(data)}`);
      return data;
    } catch (e) {
      Logger.error(TAG, `Error in getSearchBankList: ${e}`);
      return new BankListRes();
    }
  }

  //点击题库下载的操作
  public async downLoadBank(bankListRes: BankListRes): Promise<boolean> {
    try {
      let qid = bankListRes.qid
      let url = bankListRes.url
      let subTxtName = StringUtils.subUrl(url)
      // Logger.info(TAG, 'subTxtName--------' + subTxtName)
      let suffix = StringUtils.subLastIndex(subTxtName, '.')
      // Logger.info(TAG, 'suffix--------' + suffix)

      let str = await this.bankNet.getDownloadQuestionBank(url)
      // Logger.info(TAG, 'trStr--------' + str)

      let trStr = await SearchDecryptUtils.getTrText(suffix, str, subTxtName)
      Logger.info(TAG, 'trStr--------' + trStr)
      //转换成 题目的对象
      let lines = trStr.split('\n')
      // for (let line of lines) {
        for (let i = 0; i < lines.length; i++) {
          let line =  lines[i]

        if (line !== '') {
          const questionRes = plainToClass(BankQuestionRes, JSON.parse(line))
          console.info('instance:', JSON.stringify(questionRes))
          //题目数据插入存储
          let questionDb = new QuestionRes()
          questionDb.qId = qid
          questionDb.question = questionRes.q
          questionDb.answer = questionRes.ans
          questionDb.option = questionRes.a
          questionDb.questionID = qid+i+1
          let ret = await questionTable.insertDataAwait(questionDb)
          Logger.info(TAG, 'ret--------' + ret)
        }
      }
      //插入题库表,下载成功后的状态
      bankListRes.downloadedState = 1
      bankListRes.position = 0
      let ret = await questionBankTable.insertDataAwait(bankListRes)
      Logger.info(TAG, 'ret22--------' + ret)
      return true
    } catch (e) {
      Logger.info(TAG, "----->" + e)
      return false
    }
  }
}