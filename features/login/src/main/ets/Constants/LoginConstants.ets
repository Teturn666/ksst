import dataPreferences from '@ohos.data.preferences';

export class LoginConstants {
  /**
   * sp config.
   */
  static readonly SP_OPTIONS: dataPreferences.Options = {
    name: 'isLogin',
  }
  //1=已登录
  static readonly SP_IS_LOGIN = 'isLogin'
  //用户昵称
  static readonly SP_NICK_NAME = 'nickName'
  //用户头像
  static readonly SP_AVATAR_URL = 'avatarUrl'
  //union-id
  static readonly SP_UNION_ID = 'union-id'
  //open-id
  static readonly SP_OPEN_ID = 'open-id'
  //隐私政策链接
  /**
   * 路由跳转的页面名称
   */
  //搜索结果页
  static readonly ROUTER_WEB = 'webPage'
  //隐私政策链接
  static readonly USER_PRIVACY_URL = 'https://ti.iksdt.com/static/doc/yszc.html'
  //用户协议链接
  static readonly USER_AGREEMENT_URL = 'https://ti.iksdt.com/static/doc/yhxy.html'
  //华为账号用户协议链接
  static readonly USER_HUAWEI_URL =
    'https://privacy.consumer.huawei.com/legal/id/authentication-terms.htm?code=CN&language=zh-CN'
}