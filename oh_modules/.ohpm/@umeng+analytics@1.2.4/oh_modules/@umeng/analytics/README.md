# 统计sdk
## 系统API要求
鸿蒙NEXT API12及以上stage模式的普通应用，暂不支持元服务
## 快速开始
### 安装sdk
1. 在项目的根目录下执行如下命令
```shell
ohpm install @umeng/common --registry=https://ohpm.openharmony.cn/ohpm
ohpm install @umeng/analytics --registry=https://ohpm.openharmony.cn/ohpm
```
### 集成
1. 在项目的`AppScope/resources/rawfile`目录下新增一个配置文件`umconfig.json`,
![截图](https://img.alicdn.com/imgextra/i2/O1CN01yDtdNv1FJTUnb2JCa_!!6000000000466-0-tps-1126-700.jpg)
内容如下
```json
{
  "appKey": "你的apppkey",
  "channel": "你的渠道"
}
```

2. 在应用模块目录下，添加`abilityStage`工程文件,例如`entry/src/main/ets/abilityStage/MyAbilityStage.ets`，具体位置如截图
![截图1](https://img.alicdn.com/imgextra/i2/O1CN011CjLxp1LwIlf0aK2L_!!6000000001363-0-tps-1140-1236.jpg)
参考代码如下

```typescript
import AbilityStage from '@ohos.app.ability.AbilityStage';
import { preInit, InternalPlugin, setLogEnabled, init, onEventObject } from '@umeng/analytics';

setLogEnabled(true); // 开发时，打开调试日志，可观察sdk是否集成成功
export default class MyAbilityStage extends AbilityStage {
  onCreate() {
    preInit({
      context: this.context.getApplicationContext(),
      plugins: [new InternalPlugin()]
    });
    init(); // 在用户同意隐私政策后再调用此方法
    onEventObject("eventA", {
      "key": "value"
    }); // 埋个点
  }
}
```
3. 在模块的的`module.json5`文件中添加 `srcEntry` ，指向`abilityStage`文件的地址
![截图2](https://img.alicdn.com/imgextra/i1/O1CN01KFd80d251TxIFzWRG_!!6000000007466-0-tps-2266-1284.jpg)
4. 在模块的module.json5文件中添加权限声明
```json
    "requestPermissions": [
      {
        "name": "ohos.permission.INTERNET"
      },
      {
        "name": "ohos.permission.GET_NETWORK_INFO"
      }
    ],
```
![截图3](https://img.alicdn.com/imgextra/i4/O1CN01UOVvES1jbHMpfTiqa_!!6000000004566-0-tps-1404-581.jpg)
5. `在适当位置(preInit方法调用之后)，经用户授权同意隐私政策后调用init方法，才会开始日志的采集和传输`。

### 方法说明
- preInit(context:common.ApplicationContext,plugins:[internalPlugin])
  - 预初始化,需要在abilityStage的onCreate方法内调用
- init()
  - 用户同意隐私政策后调用,方法调用后才会进行采集和日志传输,需要开发者自行记录用户是否同意了隐私政策，并在判断用户同意隐私政策时才可调用init方法
- onEventObject(eventID: string, params?: Record<string, string | number>)
  - 自定义事件，可在用户同意init之前调用，最多缓存1000事件
  - eventID，事件id，字符串128位以内的非空字符串
  - params, 事件属性，可选参数，属性key，128位以内的非空字符串，value为256位以内的数值或字符串
  - `特别的`，事件id和属性key不能为一下保留关键字["id", "ts", "du", "ds", "duration", "pn", "token", "device_name", "device_model", "device_brand", "country", "city", "channel", "province", "appkey", "app_version", "access", "launch", "pre_app_version", "terminate", "no_first_pay", "is_newpayer", "first_pay_at", "first_pay_level", "first_pay_source", "first_pay_user_level", "first_pay_version", "type"];
- onProfileSignIn(provider:string,puid:string)
  - 账号登入，用户同意隐私政策后调用
  - provider 开发者自定义的账号类型，非空字符串，且长度不超过32
  - puid 开发者自定义的账号，非空字符串，且长度不超过64
- onProfileSignOff()
  - 账号登出，用户同意隐私政策后调用
- setLogEnabled(enable:boolean)
  - 日志开关，默认关闭
### 自定义事件示例
  - 在UI线程中埋点，以下代码演示了如何在某个页面的某个按钮的点击事件埋点
    ```js  
    import { onEventObject } from '@umeng/analytics';
    Button('自定义事件X1').onClick(() => {
          onEventObject("eventid", {
            param: "value"
          });
    });
    ```
- 在worker线程中, 以下代码演示了如何在worker线程中埋点
  ```js
  import worker, { ThreadWorkerGlobalScope, MessageEvents, ErrorEvent } from '@ohos.worker';
  import { onEventObject } from '@umeng/analytics';
  
  
  
  const workerPort: ThreadWorkerGlobalScope = worker.workerPort;
  
  /**
   * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
   * The event handler is executed in the worker thread.
   *
   * @param e message data
   */
  workerPort.onmessage = function (e: MessageEvents) {
    onEventObject("workerevent4", {
      a: 1
    })
  }
  
  /**
   * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
   * The event handler is executed in the worker thread.
   *
   * @param e message data
   */
  workerPort.onmessageerror = function (e: MessageEvents) {
  }
  
  /**
   * Defines the event handler to be called when an exception occurs during worker execution.
   * The event handler is executed in the worker thread.
   *
   * @param e error message
   */
  workerPort.onerror = function (e: ErrorEvent) {
  }
  ```
- 暂未提供c++中直接调用的方法，需要参考鸿蒙官网c++和arkts互通的知识，通过NAPI的方式来调onEventObject方法实现埋点