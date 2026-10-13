import { AxiosResponse } from "@ohos/axios";
import { BaseResponse, HttpUtils } from "network";
import { SearchResultRes } from "../model/SearchResultRes";
import { SearchResultTrigger } from "./SearchResultTrigger";
import { BusinessError } from "@kit.BasicServicesKit";

export class SearchResultNet {
  //获取搜索结果列表
  public getSearchResultList(word: string): Promise<SearchResultRes[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      (await HttpUtils.getInstance())
        .get(SearchResultTrigger.SEARCH_URL, { params: { "word": word, "pageNum": '1', "pageSize": '20' } })
        .then((res: AxiosResponse<BaseResponse<SearchResultRes[]>>) => {
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
}