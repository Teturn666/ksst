import { ChAesUtils } from 'encryption';

//搜索后解密的工具类
export class SearchDecryptUtils {
  /**
   * 获取解密后的文本
   */
  static async getTrText(suffix: string, message: string, name: string): Promise<string> {
    return await ChAesUtils.getAesStr(suffix, message, name)
  }

  /**
   * 判断给到的选项下标是不是正确选项
   * 然后返回位置存储
   */
  static isCorrectAnswer(position: number, answer: string): number {
    let prefix = String.fromCharCode('A'.charCodeAt(0) + position)
    if (answer.includes(prefix)) {
      return position
    }
    return -1
  }
}