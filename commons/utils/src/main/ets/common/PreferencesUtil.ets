import { common } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData';

let dataPreferences: preferences.Preferences | null = null;

export default class PreferencesUtils {
  private context = getContext(this) as common.UIAbilityContext

  getPreferences() {
    try {
      let options: preferences.Options = {
        name: 'myStore'
      };
      dataPreferences = preferences.getPreferencesSync(this.context, options);
      console.info('success getPreferences' + dataPreferences)

    } catch (error) {
      console.info('error  getPreferences')
      console.error('error  getPreferences')
    }
  }

  //定义方法
  //存  putSync(key: string, value: ValueType): void   此为同步接口。
  write(key: string, value: string) {
    //判断preference对象是否存在
    if (!dataPreferences) {
      this.getPreferences()
    }
    ;
    try {
      dataPreferences!!.putSync(key, value);

      //持久化存储
      dataPreferences!!.flush();
    } catch (error) {
      console.info('error  getPreferences write')
      console.error(error)
    }
  }

  //获取
  // getSync(key: string, defValue: ValueType): ValueType 此为同步接口。
  read(key: string, defValue?: string): string | undefined {
    //判断preference对象是否存在
    if (!dataPreferences) {
      this.getPreferences()
    }
    ;
    let value: preferences.ValueType | undefined = undefined;
    try {
      value = dataPreferences!!.getSync(key, defValue);
      console.info('success read ' + value)

    } catch (error) {
      console.info('error  getPreferences read')
      console.error(error)
    }
    return value as string | undefined //返回的是string | undefined
  }
}