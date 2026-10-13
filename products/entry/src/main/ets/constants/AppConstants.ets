import dataPreferences from '@ohos.data.preferences';

export class AppConstants {
  static readonly FULL_PERCENT: string = '100%';
  static readonly TAB_HEIGHT: number = 60;
  static readonly TAB_FONT_WEIGHT: number = 600;
  /**
   * sp config.
   */
  static readonly SP_OPTIONS: dataPreferences.Options = {
    name: 'firstInstall',
  }
}