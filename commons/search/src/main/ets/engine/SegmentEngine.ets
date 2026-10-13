//分词工具
import { List } from '@kit.ArkTS'

export class SegmentEngine {
  private static readonly TYPE_NONE = -1 //不处理
  private static readonly TYPE_ALP = 1 //字母和数字
  private static readonly TYPE_HAN = 2 //汉字
  private static delegate = new SegmentEngine()

  private constructor() {
  }

  public static getInstance(): SegmentEngine {
    return SegmentEngine.delegate
  }

  public cut(content: string): List<string> {
    let list = new List<string>()
    let str = "";
    for (let i = 0; i < content.length; i++) {
      //转换成ASCII编码
      const charCode = content.charCodeAt(i)
      const char = content.charAt(i)
      let curType = this.getCharType(charCode, char)
      if (curType === SegmentEngine.TYPE_ALP) {
        str += char
      } else if (curType === SegmentEngine.TYPE_HAN) {
        if (str.length > 0) {
          list.add(str)
          str = ''
        }
        list.add('' + char)
      } else {
        if (str.length > 0) {
          list.add(str)
          str = ''
        }
      }

    }
    if (str.length > 0) {
      list.add(str)
    }
    return list
  }

  //通过ASCII判断是什么类型
  private getCharType(charCode: number, char: string): number {
    if (this.isChinese(charCode, char)) {
      return SegmentEngine.TYPE_HAN
    } else if (charCode >= 48 && charCode <= 57) {
      return SegmentEngine.TYPE_ALP
    } else if (charCode >= 65 && charCode <= 90) {
      return SegmentEngine.TYPE_ALP
    } else if (charCode >= 97 && charCode <= 122) {
      return SegmentEngine.TYPE_ALP
    }
    return SegmentEngine.TYPE_NONE
  }

  //是否是汉字，不包含中文标点符号
  private isChinese(charCode: number, char: string): boolean {
    if (charCode > 127 && !this.isChinesePun(char)) {
      return true
    }
    return false
  }

  //判断是否是中文的标点符号，中文的标点符号值也大于127了
  private isChinesePun(s: string): boolean {
    if ('\u3000' <= s && s <= '\u303F') {
      return true
    }
    return false
  }
}