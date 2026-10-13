import dataPreferences from '@ohos.data.preferences';

export default class HomeConstants {
  /**
   * sp config.
   */
  static readonly SP_OPTIONS: dataPreferences.Options = {
    name: 'myFirstDb',
  }
  static readonly HAS_DATA = 'hasData'
  /**
   * 路由跳转的页面名称
   */
  //搜索结果页
  static readonly ROUTER_SEARCH_RESULT = 'searchResultPage'
  //我的下载页
  static readonly ROUTER_MY_DOWNLOAD = 'myDownloadPage'
  //web页面
  static readonly ROUTER_WEB = 'webPage'
  //练习列表页面(题库练习、错题练习、收藏练习共用)
  static readonly ROUTER_BANK_LIST = 'bankListPage'
  //题库练习
  static readonly ROUTER_EXERCISE_LIST = 'exercisePage'
  //模拟考试
  static readonly ROUTER_EXERCISE_COMMON_LIST = 'exerciseCommonPage'
  //练习详情
  static readonly ROUTER_EXERCISE_DETAILS_LIST = 'exerciseDetailsPage'
  //解密字符串的正则
  static readonly IMAGE_REGEX = /\$\{.*?\}/g
  //使用教程链接
  static readonly USE_TEACH_URL = 'https://ti.iksdt.com/static/doc/stjc.webm'
}