import bundleManager from '@ohos.bundle.bundleManager';
import * as wxOpenSdk from '@tencent/wechat_open_sdk';
import { OnWXResp, WXApi, WXEventHandler, APP_ID } from '../model/WXApiWrap';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction, router } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { ErrCode } from '@tencent/wechat_open_sdk';
import http from '@ohos.net.http';
import { authentication, loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { LoginConstants } from '../Constants/LoginConstants';
import { preferences } from '@kit.ArkData';
import { huaweiAuthManager } from 'utils';
import json from '@ohos.util.json';


interface AccessTokenResponse {
  access_token?: string;
  expires_in?: number;
  refresh_token?: string;
  openid?: string;
  scope?: string;
  errcode?: number;
  errmsg?: string;
}

interface UserInfoResponse {
  openid?: string;
  nickname?: string;
  headimgurl?: string;
  sex?: number;
  province?: string;
  city?: string;
  country?: string;
  unionid?: string;
  errcode?: number;
  errmsg?: string;
}


@Entry({ routeName: 'login' })
@Component
export struct LoginPage {
  @State agreementChecked: boolean = false;
  private wxApi = WXApi
  @State nickname: string = '';
  @State avatarUrl: string = '';
  @State unionId: string = '';
  @State openId: string = '';
  @State quickLoginAnonymousPhone: string = '';
  private context = (getContext(this) as common.UIAbilityContext)
  private wxEventHandler = WXEventHandler
  logTag: string = 'QuickLoginButtonComponent';
  domainId: number = 0x0000;
  // 构造LoginWithHuaweiIDButton组件的控制器
  controller: loginComponentManager.LoginWithHuaweiIDButtonController =
    new loginComponentManager.LoginWithHuaweiIDButtonController()
      /**
       * 当应用使用自定义的登录页时，如果用户未同意协议，需要设置协议状态为NOT_ACCEPTED，当用户同意协议后再设置
       * 协议状态为ACCEPTED，才可以使用华为账号一键登录功能
       */
      .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
      .onClickLoginWithHuaweiIDButton(async (error: BusinessError | undefined,
        response: loginComponentManager.HuaweiIDCredential) => {
        // promptAction.showToast({
        //   message:'111'
        // })
         const code = (await huaweiAuthManager.launchAuth())! // 拉起华为登录
        promptAction.showToast({
          message:code
        })
        //   this.handleLoginWithHuaweiIDButton(error, response);
      })
      .onClickEvent((error: BusinessError, clickEvent: loginComponentManager.ClickEvent) => {
        if (error) {
          this.dealAllError(error);
          return;
        }
        hilog.info(this.domainId, this.logTag, `onClickEvent clickEvent: ${clickEvent}`);
      });

  async handleLoginWithHuaweiIDButton(error: BusinessError | undefined,
    response: loginComponentManager.HuaweiIDCredential) {

    if (error) {
      hilog.error(this.domainId, this.logTag,
        `Failed to login with LoginWithHuaweiIDButton. errCode is ${error.code}, errMessage is ${error.message}`)
      promptAction.showToast({ message: '服务或网络异常，请稍后重试' })
      return
    }

    try {
      if (response) {
        hilog.info(this.domainId, this.logTag, 'Succeeded in clicking LoginWithHuaweiIDButton.');
        // 开发者根据实际业务情况使用以下信息
        const authCode = response.authorizationCode;
        const openID = response.openID;
        const unionID = response.unionID;
        const idToken = response.idToken;
      }
    } catch (err) {
      hilog.error(this.domainId, this.logTag,
        `Failed to login with LoginWithHuaweiIDButton, errCode: ${err.code}, errMessage: ${err.message}`);
      promptAction.showToast({ message: '服务或网络异常，请稍后重试' })
    }
  }

  aboutToAppear(): void {
    this.wxEventHandler.registerOnWXRespCallback(this.onWXResp)
    this.getQuickLoginAnonymousPhone()
  }

  aboutToDisappear(): void {
    this.wxEventHandler.unregisterOnWXRespCallback(this.onWXResp)
  }

  private onWXResp: OnWXResp = async (resp) => {
    if (resp.errCode === ErrCode.ERR_OK) {
      promptAction.showToast({ message: '微信授权成功' });
      const authResp = resp as wxOpenSdk.SendAuthResp;
      if (authResp.code) {
        try {
          await this.fetchUserInfo(authResp.code);
        } catch (err) {
          promptAction.showToast({ message: '获取用户信息失败' });
          hilog.error(0x0000, 'TAG', `获取用户信息失败: ${err}`);
        }
      } else {
        promptAction.showToast({ message: '未获取到授权码' });
        hilog.error(0x0000, 'TAG', '授权响应缺少 code');
      }
    } else {
      promptAction.showToast({ message: `授权失败: ${resp.errStr || '未知错误'}` });
      hilog.error(0x0000, 'TAG', `授权失败: errCode=${resp.errCode}, errStr=${resp.errStr}`);
    }
  };

  async fetchUserInfo(code: string) {
    let httpClient = http.createHttp();
    const APP_SECRET = '7c65844efba6af55e632f0145d11962f';
    let accessTokenUrl =
      `https://api.weixin.qq.com/sns/oauth2/access_token?appid=${APP_ID}&secret=${APP_SECRET}&code=${code}&grant_type=authorization_code`;

    try {
      // 获取 access_token
      let accessTokenResponse = await httpClient.request(accessTokenUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 10000,
        readTimeout: 10000
      });
      if (!accessTokenResponse.result) {
        throw new Error('获取 access_token 响应失败');
      }
      let tokenData: AccessTokenResponse = JSON.parse(accessTokenResponse.result.toString());
      if (!tokenData.access_token || !tokenData.openid) {
        throw new Error(`获取 access_token 失败: ${tokenData.errcode || '未知错误'}, ${tokenData.errmsg || ''}`);
      }

      // 获取用户信息
      let userInfoUrl =
        `https://api.weixin.qq.com/sns/userinfo?access_token=${tokenData.access_token}&openid=${tokenData.openid}`;
      let userInfoResponse = await httpClient.request(userInfoUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 10000,
        readTimeout: 10000
      });
      if (!userInfoResponse.result) {
        throw new Error('无法获取用户信息');
      }
      let userInfo: UserInfoResponse = JSON.parse(userInfoResponse.result.toString());
      if (userInfo.nickname) {
        this.nickname = userInfo.nickname;
      }
      if (userInfo.headimgurl) {
        this.avatarUrl = userInfo.headimgurl;
      }
      if (userInfo.unionid) {
        this.unionId = userInfo.unionid
      }
      if (userInfo.openid) {
        this.openId = userInfo.openid
      }

      this.wxLoginSuccess()
      // promptAction.showToast({ message: '用户信息获取成功' });
      // hilog.info(0x0000, 'TAG', `用户信息: nickname=${userInfo.nickname}, headimgurl=${userInfo.headimgurl}`);
    } catch (err) {
      throw new Error(String(err));
    } finally {
      httpClient.destroy();
    }
  }

  async wechatLogin() {
    if (!this.agreementChecked) {
      promptAction.showToast({ message: '请先勾选并同意用户协议和隐私政策' });
      return;
    }
    try {
      let link = 'weixin://';
      let data = await bundleManager.canOpenLink(link);
      if (data) {
        let req = new wxOpenSdk.SendAuthReq();
        req.isOption1 = false;
        req.nonAutomatic = true;
        req.scope = 'snsapi_userinfo';
        req.state = 'none';
        req.transaction = 'auth_' + Date.now();

        let finished = await this.wxApi.sendReq(getContext(this) as common.UIAbilityContext, req);
        hilog.info(0x0000, 'TAG', `发送授权请求完成: ${finished}`);
      } else {
        promptAction.showToast({ message: '请安装微信' });
        hilog.warn(0x0000, 'TAG', '微信未安装');
      }
    } catch (err) {
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'TAG', `canOpenLink 失败: ${message}`);
      promptAction.showToast({ message: '检查微信安装失败' });
    }
  }

  wxLoginSuccess() {
    let sp = preferences.getPreferencesSync(this.context, LoginConstants.SP_OPTIONS)
    sp.putSync(LoginConstants.SP_IS_LOGIN, '1')
    sp.putSync(LoginConstants.SP_NICK_NAME, this.nickname)
    sp.putSync(LoginConstants.SP_AVATAR_URL, this.avatarUrl)
    sp.putSync(LoginConstants.SP_UNION_ID, this.unionId)
    sp.putSync(LoginConstants.SP_OPEN_ID, this.openId)
    sp.flushSync()

    let index = Number(router.getLength()) - 1
    router.back(
      index, {
      nickName: this.nickname,
      avatarUrl: this.avatarUrl,
      loginState: '1'
    })
  }

  huaweiLogin() {
    if (!this.agreementChecked) {
      promptAction.showToast({ message: '请先勾选并同意用户协议和隐私政策' });
      return;
    }
    this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED)

    try {
      this.controller.continueLogin(
        (error: BusinessError) => {
          if (error) {
            hilog.error(this.domainId, this.logTag,
              `Failed to login with agreementDialog. errCode is ${error.code}, errMessage is ${error.message}`);
          } else {
            hilog.info(this.domainId, this.logTag,
              'Succeeded in clicking agreementDialog continueLogin.');
          }
        })
    } catch (e) {
      hilog.error(this.domainId, this.logTag,
        `Failed to login with agreementDialog. errCode is ${e}`);
    }
  }

  getQuickLoginAnonymousPhone() {
    // 创建授权请求，并设置参数
    const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取匿名手机号需传quickLoginAnonymousPhone这个scope，传参之前需要先申请"华为账号一键登录"权限
    authRequest.scopes = ['quickLoginAnonymousPhone'];
    // 用于防跨站点请求伪造
    authRequest.state = util.generateRandomUUID();
    // 一键登录场景该参数必须设置为false
    authRequest.forceAuthorization = false;
    const controller = new authentication.AuthenticationController();

    try {
      controller.executeRequest(authRequest).then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
        // 获取到UnionID、OpenID、匿名手机号
        const unionID = response.data?.unionID;
        const openID = response.data?.openID;
        const anonymousPhone = response.data?.extraInfo?.quickLoginAnonymousPhone as string;
        if (anonymousPhone) {
          hilog.info(0x0000, 'testTag', 'Succeeded in authentication.');
          this.quickLoginAnonymousPhone = anonymousPhone;
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in authentication. AnonymousPhone is empty.');
        // 未获取到匿名手机号需要跳转到应用自定义的登录页面
      }).catch((error: BusinessError) => {
        this.dealAllError(error);
      })
    } catch (error) {
      this.dealAllError(error);
    }
  }

  // 错误处理
  dealAllError(error: BusinessError): void {
    hilog.error(0x0000, 'testTag',
      `Failed to get quickLoginAnonymousPhone, errorCode is ${error.code}, errorMessage is ${error.message}`);
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(32)
          .height(32)
          .margin({ left: 16, top: 12 })
          .onClick(() => {
            router.back();
          })
        Text('登录')
          .fontSize(18)
          .textAlign(TextAlign.Center)
          .fontWeight(600)
          .flexGrow(1)
          .margin({ top: 12 })

        Blank()
          .width(32)
          .margin({ right: 16, top: 12 })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)

      Blank()
      Image($r('app.media.ic_logo'))
        .width(218)
        .height(60)

      Blank()
      Text(this.quickLoginAnonymousPhone)
        .visibility(this.quickLoginAnonymousPhone != '' ? Visibility.Visible : Visibility.Hidden)
        .width('80%')
        .height(48)
        .margin({ top: 50 })
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .fontSize(24)
      Text("华为账号绑定号码")
        .visibility(this.quickLoginAnonymousPhone != '' ? Visibility.Visible : Visibility.Hidden)
        .width('80%')
        .textAlign(TextAlign.Center)
        .fontSize(12)

      // Button('华为账号一键登录', { type: ButtonType.Normal, stateEffect: true })
      //   .visibility(this.quickLoginAnonymousPhone != '' ? Visibility.Visible : Visibility.Hidden)
      //   .borderRadius(8)
      //   .backgroundColor('#f64e4d')
      //   .width('60%')
      //   .height(48)
      //   .margin({ top: 20 })
      //
      //   .onClick(async () => {
      //     //Todo
      //     promptAction.showToast({
      //       message:'111'
      //     })
      //     const code = (await huaweiAuthManager.launchAuth())! // 拉起华为登录
      //
      //    })

      LoginWithHuaweiIDButton({
        params: {
          // LoginWithHuaweiIDButton支持的样式
          style: loginComponentManager.Style.BUTTON_RED,
          // 账号登录按钮在登录过程中展示加载态
          extraStyle: {
            buttonStyle: new loginComponentManager.ButtonStyle().loadingStyle({
              show: true
            })
          },
          // LoginWithHuaweiIDButton的边框圆角半径
          borderRadius: 24,
          // LoginWithHuaweiIDButton支持的登录类型
          loginType: loginComponentManager.LoginType.QUICK_LOGIN,
          // LoginWithHuaweiIDButton支持按钮的样式跟随系统深浅色模式切换
          supportDarkMode: true,
          // verifyPhoneNumber：如果华为账号用户在过去90天内未进行短信验证，是否拉起Account Kit提供的短信验证码页面
          verifyPhoneNumber: true
        },
        controller: this.controller
      })
        .width('60%')
        .height(48)
        .backgroundColor('#eb5555')
        .borderRadius(24)
        .margin({ top: 20 })

Button("华为账号一键登录")
  .borderRadius(8)
  .backgroundColor('#f64e4d')
  .width('60%')
  .height(48)
  .margin({ top: 20 })
        .onClick(async () => {
          //Todo
          // promptAction.showToast({
          //   message:'111'
          // })
         const code = (await huaweiAuthManager.launchAuth())! // 拉起华为登录
promptAction.showToast({
  message:code
})
         })


      Button('微信快捷登录', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor('#0ac160')
        .width('60%')
        .height(48)
        .margin({ top: 12 })
        .onClick(() => {
          this.wechatLogin()
        })

      // 底部协议部分
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Image(this.agreementChecked ? $r('app.media.ic_protocoled') : $r('app.media.ic_protocol'))
          .width(12)
          .height(12)
          .margin({ right: 4 })
          .onClick(() => {
            this.agreementChecked = !this.agreementChecked;
            if (this.agreementChecked) {
              this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED);
            } else {
              this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED);
            }
          })
        Text('我已阅读并同意')
          .fontSize(12)
          .fontColor(Color.Black)
          .margin({ right: 4 })
        Text('《用户协议》')
          .fontSize(12)
          .fontColor('#007AFF')
          .onClick(() => {
            router.pushNamedRoute({
              name: LoginConstants.ROUTER_WEB, params: {
                url: LoginConstants.USER_AGREEMENT_URL,
                title: "用户协议"
              }
            }, router.RouterMode.Single)
          })
          .margin({ right: 4 })
        Text('《隐私政策》')
          .fontSize(12)
          .fontColor('#007AFF')
          .onClick(() => {
            router.pushNamedRoute({
              name: LoginConstants.ROUTER_WEB, params: {
                url: LoginConstants.USER_PRIVACY_URL,
                title: "隐私政策"
              }
            }, router.RouterMode.Single)
          })
          .margin({ right: 4 })
        Text('和')
          .fontSize(12)
          .fontColor(Color.Black)
          .margin({ right: 4 })
        Text('《华为账号用户认证协议》')
          .fontSize(12)
          .fontColor('#007AFF')
          .onClick(() => {
            router.pushNamedRoute({
              name: LoginConstants.ROUTER_WEB, params: {
                url: LoginConstants.USER_HUAWEI_URL,
                title: ""
              }
            }, router.RouterMode.Single)
          })
      }
      .width('80%')
      .margin({ top: 40, bottom: 40 })
    }
    .height('100%')
    .width('100%')
  }
}
