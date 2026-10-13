import { BankTrigger } from './BankTrigger';
import { BaseResponse, HttpUtils } from 'network/Index';
import axios, { AxiosResponse, AxiosProgressEvent } from '@ohos/axios';
import { BankCategory } from '../model/BankCategory';
import { BusinessError } from '@kit.BasicServicesKit';
import { BankListRes } from 'db'
import { Logger } from 'utils'
import fs, { ReadTextOptions } from '@ohos.file.fs';
import { SearchQuestionRes } from '../model/SearchQuestionRes';

const TAG = '[BankNet]'

export class BankNet {
  //搜索题目
  public getSearchQuestionList(content: string, pageNo: string): Promise<SearchQuestionRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance()
        .get(BankTrigger.HOME_SEARCH_TITLE_LIST_URL, {
          params: {
            "word": content,
            "pageNum": pageNo,
            "pageSize": "10"
          }
        })
        .then((res: AxiosResponse<BaseResponse<SearchQuestionRes[]>>) => {
          const code = res.data.code;
          if (code === "0" && res.data.data) {
            resolve(res.data.data);
          } else {
            reject(new Error(`Request failed with code: ${code}`));
          }
        })
        .catch((error: BusinessError) => {
          reject(error);
        });
    });
  }

  //搜索题库
  public getSearchBankList(content: string, pageNo: number): Promise<BankListRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance()
        .get(BankTrigger.HOME_SEARCH_BANK_LIST_URL, {
          params: {
            "word": content,
            "pageNo": pageNo,
            "pageSize": 10
          }
        })
        .then((res: AxiosResponse<BaseResponse<BankListRes[]>>) => {
          const code = res.data.code;
          if (code === "0" && res.data.data) {
            resolve(res.data.data);
          } else {
            reject(new Error(`Request failed with code: ${code}`));
          }
        })
        .catch((error: BusinessError) => {
          reject(error);
        });
    });
  }


  //获取热门搜索列表
  public getHotSearchList(): Promise<string[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(BankTrigger.HOME_HOTSEARCH_LIST_URL)
        .then((res: AxiosResponse<BaseResponse<BankCategory[]>>) => {
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

  //获取题库tab类型列表
  public getBankTypeList(): Promise<BankCategory[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance().get(BankTrigger.HOME_CATEGORY_LIST_URL)
        .then((res: AxiosResponse<BaseResponse<BankCategory[]>>) => {
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

  //获取题库列表
  public getBankList(aid: string, pageNo: number): Promise<BankListRes[]> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance()
        .get(BankTrigger.HOME_BANK_LIST_URL, { params: { "aid": aid, "pageSize": 10, "pageNo": pageNo } })
        .then((res: AxiosResponse<BaseResponse<BankListRes[]>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        })
        .catch((error: BusinessError) => {
          reject(error);
        })
    })
  }

  //获取单个题库
  public getBankDetail(id: string): Promise<BankListRes> {
    return new Promise((resolve: Function, reject: Function) => {
      HttpUtils.getInstance()
        .get(BankTrigger.HOME_BANK_INFO_URL, { params: { "id": id } })
        .then((res: AxiosResponse<BaseResponse<BankListRes>>) => {
          let code = res.data.code
          if (code === "0") {
            resolve(res.data.data);
          } else {
            reject("data is null");
          }
        })
        .catch((error: BusinessError) => {
          reject(error);
        })
    })
  }

  //获取题库文件内容
  public getDownloadQuestionBank(downloadUrl: string): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      let filePath = getContext(this).cacheDir + '/import.data'
      // Download the file. If the file already exists, delete the existing one first.
      try {
        //检查文件是否存在
        fs.accessSync(filePath);
        //删除文件
        fs.unlinkSync(filePath);
      } catch (err) {
        Logger.info(TAG, 'fs err--------' + err)
      }

      axios({
        url: downloadUrl,
        method: 'get',
        context: getContext(this),
        filePath: filePath,
        onDownloadProgress: (progressEvent: AxiosProgressEvent): void => {
          Logger.info(TAG,
            '下载文件-------' + "progress: " + progressEvent && progressEvent.loaded && progressEvent.total ?
            Math.ceil(progressEvent.loaded / progressEvent.total * 100) : 0)
        }
      }).then((res: AxiosResponse) => {
        console.info("result: " + JSON.stringify(res.data));

        try {
          let readTextOptions: ReadTextOptions = {
            offset: 0,
            length: 0,
            encoding: 'utf-8'
          };
          let stat = fs.statSync(filePath);
          readTextOptions.length = stat.size;
          let str = fs.readTextSync(filePath, readTextOptions)
          // Logger.info(TAG, "读取的长度----" + str)
          resolve(str);
        } catch (e) {
          Logger.info(TAG, "读取文件内容失败----" + e)
        }
      }).catch((error: BusinessError) => {
        console.error("error:" + JSON.stringify(error));
      })
    })
  }
}