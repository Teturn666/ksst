import { HomeBankListRes } from '../model/HomeBankListRes';
import { HomeTrigger } from './HomeTrigger';
import { BusinessError } from '@kit.BasicServicesKit';
import { AxiosResponse } from '@ohos/axios';
import { BaseResponse, HttpUtils } from 'network/Index';
import { List } from '@kit.ArkTS';
import { HomeBankChapterRes } from '../model/HomeBankChapterRes';
import { UpdateRes } from '../model/UpdateRes';
// import { QuestionRes } from '../model/QuestionRes';
import { QuestionRes } from 'db/Index'

const TAG = '[HomeNet]';

export class HomeNet {
  //获取题库的列表
  public getHomeBankListRes(): Promise<List<HomeBankListRes>> {
    return new Promise((resolve: (value: List<HomeBankListRes> | PromiseLike<List<HomeBankListRes>>) => void,
      reject: (reason?: Object) => void) => {
      HttpUtils.getInstance().get(HomeTrigger.HOME_BANK_LIST)
        .then((res: AxiosResponse<BaseResponse<List<HomeBankListRes>>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data as List<HomeBankListRes>);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  //获取章节信息
  public getHomeBankChapterRes(bankId: number): Promise<HomeBankChapterRes> {
    return new Promise(async (resolve: (value: HomeBankChapterRes | PromiseLike<HomeBankChapterRes>) => void,
      reject: (reason?: Object) => void) => {
      (await HttpUtils.getInstance()).get(HomeTrigger.HOME_BANK_CHAPTER, { params: { "bankId": bankId } })
        .then((res: AxiosResponse<BaseResponse<HomeBankChapterRes>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data as HomeBankChapterRes);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  //根据题库Id获取题库信息
  public getHomeBankBaseInfoRes(): Promise<void | HomeBankListRes> {
    return new Promise((resolve: (value: HomeBankListRes | PromiseLike<HomeBankListRes>) => void,
      reject: (reason?: Object) => void) => {
      HttpUtils.getInstance().get(HomeTrigger.HOME_BANK_BASEINFO, { params: { "bankId": 2 } })
        .then((res: AxiosResponse<BaseResponse<HomeBankListRes>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data as HomeBankListRes);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    }).catch((error: BusinessError) => {
      console.info("---->" + error)
    })
  }

  //获取版本更新信息
  public getUpdateVersionRes(): Promise<void | UpdateRes> {
    return new Promise((resolve: (value: UpdateRes | PromiseLike<UpdateRes>) => void,
      reject: (reason?: Object) => void) => {
      HttpUtils.getInstance().get(HomeTrigger.UPDATE_VERSION, { params: { "version": "1.0.0" } })
        .then((res: AxiosResponse<BaseResponse<UpdateRes>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data as UpdateRes);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    }).catch((error: BusinessError) => {
      console.info("---->" + error)
    })
  }

  //获取配置列表的数据
  public getConfigRes(): Promise<void | string> {
    return new Promise((resolve: (value: string | PromiseLike<string>) => void,
      reject: (reason?: Object) => void) => {
      HttpUtils.getInstance().get(HomeTrigger.CONFIG_LIST)
        .then((res: AxiosResponse<BaseResponse<string>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data as string);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    }).catch((error: BusinessError) => {
      console.info("---->" + error)
    })
  }

  //获取题库信息
  public getQuestionListRes(chapterId: number): Promise<List<QuestionRes>> {
    return new Promise((resolve: (value: List<QuestionRes> | PromiseLike<List<QuestionRes>>) => void,
      reject: (reason?: Object) => void) => {
      HttpUtils.getInstance().get(HomeTrigger.QUESTION_LIST, { params: { "chapterId": chapterId } })
        .then((res: AxiosResponse<BaseResponse<List<QuestionRes>>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data as List<QuestionRes>);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }
}