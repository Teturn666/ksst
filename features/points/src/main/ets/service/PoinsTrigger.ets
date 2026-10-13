export enum PointsTrigger {


  // 获取签到表信息 /m/checkin/map?vip=bool
  URL_SIGN_MAP = "/m/checkin/map",

  // 获取签到状态信息（正数为可以签到，负数为已签到） /m/checkin/state
  URL_SIGN_STATE = "/m/checkin/state",

  // 签到领积分行为 /m/checkin/action
  URL_SIGN_ACTION = "/m/checkin/action",

  // 请求我的邀请码 /m/invite/code
  URL_INVITE_CODE = "/m/invite/code",

  // 绑定邀请码 /m/invite/submit
  URL_INVITE_SUBMIT = "/m/invite/submit",

  // 返回已绑定的邀请码 /m/invite/bound
  URL_INVITE_BOUND = "/m/invite/bound",

  // 积分历史明细 /m/point/history
  URL_POINT_HISTORY = "/m/point/history",

  // 积分增加历史 /m/point/history/increase
  URL_POINT_HISTORY_INCREASE = "/m/point/history/increase",

  // 积分消耗历史 /m/point/history/reduce
  URL_POINT_HISTORY_REDUCE = "/m/point/history/reduce",

  // 获取我的积分 /m/point/numb
  URL_POINT_NUMB = "/m/point/numb",

  // 我邀请的好友 /m/point/invite
  URL_INVITE_MY = "/m/point/invite",

  // 看广告获取积分 /m/point/ad
  URL_INVITE_AD = "/m/point/ad",

  // 查询用户裂变相关内容 /m/activity/invite
  URL_ACTIVITY_INVITE = "/m/activity/invite",

  // 查询还有多少次看广告机会 /m/point/ad/count
  URL_INVITE_AD_COUNT = "/m/point/ad/count",


}