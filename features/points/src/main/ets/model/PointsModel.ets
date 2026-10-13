import { questionBankTable, questionTable, BankListRes, QuestionRes } from 'db'
import { SearchDecryptUtils } from 'search'
import { Logger, StringUtils } from 'utils'
import { plainToClass } from 'class-transformer'
import { PointsNet } from '../service/PointsNet'
import CheckDataRes, { PointEventRes } from './CheckDataRes'

const TAG = '[PointsModel]'


@Observed
export class PointsModel {
  private PointsNet: PointsNet
  private static instance: PointsModel

  private constructor() {
    this.PointsNet = new PointsNet()
  }

  public static getInstance(): PointsModel {
    if (!PointsModel.instance) {
      PointsModel.instance = new PointsModel()
    }
    return PointsModel.instance
  }


  //获取签到积分list
  public async getSignMapList(): Promise<CheckDataRes[]> {
    try {
      let data = await this.PointsNet.getListSignMap(false)
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }

  //获取连续签到天数
  public async getSignState(): Promise<number> {
    try {
      let data = await this.PointsNet.getSignState()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return 2
    }
  }

  //获取总积分
  public async getMyNumb(): Promise<string> {
    try {
      let data = await this.PointsNet.getMyNumb()
      Logger.info(TAG, '返回数据--------' + data)
      return String(data)
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return 'wrong'
    }
  }

  //今日签到
  public async getTodayPoint(): Promise<boolean> {
    try {
      let data = await this.PointsNet.getSigningPoint()
      // Logger.info(TAG, '返回数据--------' + data)
      if (data == 0) {
        return true
      } else {
        return false
      }
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return false
    }
  }

  // 历史细节
  public async getHistoryPoint(): Promise<PointEventRes[]> {
    try {
      let data = await this.PointsNet.getHistoryPointDetail()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }

  // 历史增长细节
  public async getHistoryPsIncrease(): Promise<PointEventRes[]> {
    try {
      let data = await this.PointsNet.getHistoryPointIncrease()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }

  // 历史消耗细节
  public async getHistoryPsConsumer(): Promise<PointEventRes[]> {
    try {
      let data = await this.PointsNet.getHistoryPointConsumer()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }

  // 邀请记录
  public async getMyPeople(): Promise<PointEventRes[]> {
    try {
      let data = await this.PointsNet.getMyInvitePeople()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return []
    }
  }

  // 我的邀请码
  public async getMyCode(): Promise<string> {
    try {
      let data = await this.PointsNet.getMyInviteCode()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return ''
    }
  }

  // 被绑定邀请码是什么
  public async getBoundCode(): Promise<string> {
    try {
      let data = await this.PointsNet.getBoundCode()
      // Logger.info(TAG, '返回数据--------' + data)
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return ''
    }
  }

  // 绑定邀请码action
  public async submitBoundCode(code: string): Promise<string> {
    try {
      let data = await this.PointsNet.submitBoundCode(code)
      // Logger.info(TAG, '返回数据--------' + data)
      if (data == null) {
        return "绑定失败，请检查邀请码是否正确"
      }
      return data
    } catch (e) {
      Logger.info(TAG, 'err--------' + e)
      return ''
    }
  }
}