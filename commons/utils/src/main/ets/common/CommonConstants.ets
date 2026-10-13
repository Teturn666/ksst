import dataPreferences from '@ohos.data.preferences'

export class CommonConstants {
  // percent
  static readonly FULL_PERCENT: string = '100%';
  static readonly EIGHTY_PERCENT: string = '80%';
  static readonly SIXTY_PERCENT: string = '60%';
  static readonly FORTY_FIVE_PERCENT: string = '45%';
  static readonly TWENTY_FIVE_PERCENT: string = '25%';
  static readonly TWENTY_PERCENT: string = '20%';
  // space
  static readonly SPACE_16: number = 16;
  //height
  static readonly HEIGHT_160: number = 160;
  static readonly HEIGHT_30: number = 30;
  static readonly HEIGHT_70: number = 70;
  static readonly HEIGHT_60: number = 60;
  static readonly HEIGHT_56: number = 56;
  //圆角
  static readonly RADIUS_10: number = 10;
  static readonly RADIUS_8: number = 8;
  //内边距
  static readonly PADDING_8: number = 8;
  static readonly SP_OPTIONS: dataPreferences.Options = {
    name: 'isLogin',
  }
  //union-id
  static readonly SP_UNION_ID = 'union-id'
  //open-id
  static readonly SP_OPEN_ID = 'open-id'
}