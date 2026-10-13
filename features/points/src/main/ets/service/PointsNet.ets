import { PointsTrigger } from './PoinsTrigger';
import { BaseResponse, HttpUtils } from 'network/Index';
import axios, { AxiosResponse, AxiosProgressEvent } from '@ohos/axios';

import { BusinessError } from '@kit.BasicServicesKit';
import { BankListRes } from 'db'
import { Logger } from 'utils'
import fs, { ReadTextOptions } from '@ohos.file.fs';
import CheckDataRes, { PointEventRes } from '../model/CheckDataRes';


const TAG = '[PointsNet]'

export class PointsNet {
  // //搜索题目
  // public getSearchQuestionList(content: string, pageNo: string): Promise<SearchQuestionRes[]> {
  //   return new Promise((resolve: Function, reject: Function) => {
  //     HttpUtils.getInstance()
  //       .get(BankTrigger.HOME_SEARCH_TITLE_LIST_URL, {
  //         params: {
  //           "word": content,
  //           "pageNum": pageNo,
  //           "pageSize": "10"
  //         }
  //       })
  //       .then((res: AxiosResponse<BaseResponse<SearchQuestionRes[]>>) => {
  //         const code = res.data.code;
  //         if (code === "0" && res.data.data) {
  //           resolve(res.data.data);
  //         } else {
  //           reject(new Error(`Request failed with code: ${code}`));
  //         }
  //       })
  //       .catch((error: BusinessError) => {
  //         reject(error);
  //       });
  //   });
  // }
  //
  // //搜索题库
  // public getSearchBankList(content: string, pageNo: number): Promise<BankListRes[]> {
  //   return new Promise((resolve: Function, reject: Function) => {
  //     HttpUtils.getInstance()
  //       .get(BankTrigger.HOME_SEARCH_BANK_LIST_URL, {
  //         params: {
  //           "word": content,
  //           "pageNo": pageNo,
  //           "pageSize": 10
  //         }
  //       })
  //       .then((res: AxiosResponse<BaseResponse<BankListRes[]>>) => {
  //         const code = res.data.code;
  //         if (code === "0" && res.data.data) {
  //           resolve(res.data.data);
  //         } else {
  //           reject(new Error(`Request failed with code: ${code}`));
  //         }
  //       })
  //       .catch((error: BusinessError) => {
  //         reject(error);
  //       });
  //   });
  // }
  //

  // 获取签到积分列表
  public getListSignMap(vib: boolean): Promise<CheckDataRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_SIGN_MAP,
        {
          params: {
            vip: vib
          }
        })
        .then((res: AxiosResponse<BaseResponse<CheckDataRes[]>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  // 获取签到状态
  public getSignState(): Promise<number> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_SIGN_STATE)
        .then((res: AxiosResponse<BaseResponse<number>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  // 获取我的积分
  public getMyNumb(): Promise<number> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_POINT_NUMB)
        .then((res: AxiosResponse<BaseResponse<number>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  // 今日签到积分
  public getSigningPoint(): Promise<number> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_SIGN_ACTION)
        .then((res: AxiosResponse<BaseResponse<number>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(0);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  // 积分历史明细
  public getHistoryPointDetail(): Promise<PointEventRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_POINT_HISTORY)
        .then((res: AxiosResponse<BaseResponse<PointEventRes[]>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }
  // 积分历史增加
  public getHistoryPointIncrease(): Promise<PointEventRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_POINT_HISTORY_INCREASE)
        .then((res: AxiosResponse<BaseResponse<PointEventRes[]>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }
  // 积分历史消耗
  public getHistoryPointConsumer(): Promise<PointEventRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_POINT_HISTORY_REDUCE)
        .then((res: AxiosResponse<BaseResponse<PointEventRes[]>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  public getMyInvitePeople(): Promise<PointEventRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_INVITE_MY)
        .then((res: AxiosResponse<BaseResponse<PointEventRes[]>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  public getMyInviteCode(): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_INVITE_CODE)
        .then((res: AxiosResponse<BaseResponse<string>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  public getBoundCode(): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_INVITE_BOUND)
        .then((res: AxiosResponse<BaseResponse<string>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }

  // 绑定邀请码
  public submitBoundCode(codeText:string): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(PointsTrigger.URL_INVITE_SUBMIT,{
        params: {
          code: codeText
        }
      })
        .then((res: AxiosResponse<BaseResponse<string>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve("done");
          } else if(code === "300"){
              resolve("您已注册超过30天，无法填写邀请码")
          }
          else {
            resolve("绑定失败，请检查邀请码是否正确")
            // reject("data is null");
          }
        }).catch((error: BusinessError) => {
        reject(error);
      })
    })
  }
}