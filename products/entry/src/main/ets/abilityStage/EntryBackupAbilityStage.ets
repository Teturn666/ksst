import AbilityStage from '@ohos.app.ability.AbilityStage';
import { preInit, InternalPlugin, setLogEnabled, init, onEventObject } from '@umeng/analytics';

setLogEnabled(true); // 开发时，打开调试日志，可观察sdk是否集成成功

export default class EntryBackupAbilityStage extends AbilityStage {
  onCreate() {
    preInit({
      context: this.context.getApplicationContext(),
      plugins: [new InternalPlugin()]
    });
  }
}