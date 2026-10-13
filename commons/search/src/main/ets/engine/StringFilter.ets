import { Logger, StringUtils } from 'utils'

export class StringFilter {
  private static readonly ALPLIST = "ABCDEFGHIJKLMNOPQRST"

  public static formatString(s: string): string {
    if (StringUtils.isNullOrEmpty(s)) {
      return ''
    }
    let newS = s.replace(" ", "_")
    // 删除 .之前内容
    let arr: string[] = newS.split("、", 2)
    if (arr.length < 1) {
      arr = newS.split(".", 2);
    }

    if (arr.length > 1) {
      let ary = arr[0].match('\\d+')
      let result = StringFilter.ALPLIST.search(arr[0].toUpperCase())
      //ary是数字
      if (ary != null) {
        newS = newS.substring(arr[0].length + 1).trim()
      } else if (result != -1) {
        //包含搜索的结果
        newS = newS.substring(arr[0].length + 1).trim()
      }
    }

    Logger.error("====ary===" + newS)

    return newS
  }
}