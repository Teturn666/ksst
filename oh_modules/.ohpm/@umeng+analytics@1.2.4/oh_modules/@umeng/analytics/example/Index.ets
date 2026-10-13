import AbilityStage from '@ohos.app.ability.AbilityStage';
import { preInit, InternalPlugin, setLogEnabled, init, onEventObject } from '@umeng/analytics';
import { PushPlugin } from '@umeng/push';

setLogEnabled(true); // 开发时，打开调试日志，可观察sdk是否集成成功
export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    preInit({
      context: this.context.getApplicationContext(),
      plugins: [new InternalPlugin(), new PushPlugin({
        token: "absc"
      })]
    });
    init(); // 在用户同意隐私政策后再调用此方法
    onEventObject("eventA", {
      "key": "value"
    }); // 埋个点
  }
}