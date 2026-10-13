import { hilog } from "@kit.PerformanceAnalysisKit"
import { systemShare } from '@kit.ShareKit';
import { preferences, uniformTypeDescriptor as utd } from '@kit.ArkData';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, router } from '@kit.ArkUI';
import { OfficialDialog } from './OfficialDialog';
import MineConstants from "../Constants/MineConstants";
import MineMobClickConstants from "../Constants/MineMobClickConstants";
import { onEventObject } from "@umeng/analytics";
import { productViewManager } from "@kit.StoreKit";
import { LoginConstants } from 'login/Index';

import('login/src/main/ets/pages/LoginPage')
import('points/src/main/ets/pages/PointsPage')
import('setting/src/main/ets/pages/SettingPage')


const context = (getContext(this) as common.UIAbilityContext)


@Builder
function buildsupportText() {
  Column() {
    Text('支持我们')
      .fontSize(18)
      .textAlign(TextAlign.Start)
      .fontColor(0xFF3E3E3E)
      .margin({ top: 10, left: 16 })
      .width('100%');
    // 定义渐变颜色数组
    // const gradientColors = ['#9A7013', '#D6B677', '#9E730F', '#FFE083', '#C39118', '#E2B85C'];
    //
    // // 使用 map 方法动态生成星星
    // Row({ space: 10 }) {
    //   gradientColors.map((color, index) => {
    //     Text() {
    //       SymbolSpan($r('sys.symbol.ohos_star'))
    //     }
    //     .fontSize(32)
    //     .textAlign(TextAlign.Start)
    //     .fontColor(color); // 设置渐变颜色
    //   });
    // }

    Text('如果你喜欢我们的应用，请给我们一个五星好评，帮助我们做得更好！')
      .fontSize(16)
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.c_282828'))
      .padding({ top: 16, left: 16, right: 16 })
      .width('100%');

    Button($r('app.string.i_know'))
      .onClick(() => {
        const request: Want = {
          parameters: {
            bundleName: 'com.chznai.ikst',
          }
        };
        productViewManager.loadProduct(context, request, {
          onError: (error: BusinessError) => {
            hilog.info(0, 'Support', `loadProduct onError. code is ${error.code}, message is ${error.message}`);
          }
        });
        OfficialDialog.closeDialog();
      })
      .margin({ top: 32, bottom: 32 });
  }
  .width('90%')
  .backgroundColor($r('app.color.start_window_background'))
  .borderRadius(10);
}

@Builder
function buildText() {
  Column() {
    Text("关注题库公众号")
      .fontSize(18)
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.c_9d9d9d'))
      .margin({ top: 10, left: 16 })
      .width('100%')
    Image('http://xxqg.thootv.com/images/wxgzh1.jpg').padding({ top: 10, left: 16, right: 16 }).width('100%')
    Text("欢迎关注题库公众号，保持题库最新更全，微信公众号搜索“答题大全”添加关注即可")
      .fontSize(16)
      .textAlign(TextAlign.Start)
      .fontColor($r('app.color.c_282828'))
      .padding({ top: 16, left: 16, right: 16 })
      .width('100%')
    Button($r('app.string.i_know'))
      .onClick(() => {
        OfficialDialog.closeDialog()
      })
      .margin({ top: 32, bottom: 32 })
  }.width('90%')
  .backgroundColor($r('app.color.start_window_background'))
  .borderRadius(10)
}

@Entry
@Component
export struct MinePage {
  @State message: string = "hello"
  private ctx: UIContext = this.getUIContext();
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildText));
  //@Consume 配合 @Provide 使用，只是只读的状态
  @Consume nickName: string
  @Consume avatarUrl: string
  @Consume loginState: string

  aboutToAppear(): void {
    OfficialDialog.setContext(this.ctx);
    OfficialDialog.setContentNode(this.contentNode);
    OfficialDialog.setOptions({ alignment: DialogAlignment.Center, isModal: true });
  }

  private isLogin(): boolean {
    let sp = preferences.getPreferencesSync(context, LoginConstants.SP_OPTIONS)
    let loginStatus = sp.getSync(LoginConstants.SP_IS_LOGIN, '0')
    if (typeof loginStatus === 'string') {
      this.loginState = loginStatus
    }
    let name = sp.getSync(LoginConstants.SP_NICK_NAME, '')
    if (typeof name === 'string') {
      this.nickName = name
    }
    let avatar = sp.getSync(LoginConstants.SP_AVATAR_URL, '')
    if (typeof avatar === 'string') {
      this.avatarUrl = avatar
    }
    return this.loginState === '1'
  }

  private jumpToLogin() {
    router.pushNamedRoute({ name: MineConstants.ROUTER_LOGIN }, router.RouterMode.Single)
  }

  private jumpToSearchResult() {
    router.pushNamedRoute({ name: MineConstants.ROUTER_ABOUT_US }, router.RouterMode.Single)
  }

  private jumpToSetting() {
    router.pushNamedRoute({ name: MineConstants.ROUTER_SETTING }, router.RouterMode.Single)
  }

  private jumpToPoints() {
    if (this.isLogin()) {
      router.pushNamedRoute({ name: MineConstants.ROUTER_POINTS }, router.RouterMode.Single)
    } else {
      this.jumpToLogin()
    }
  }

  private jumpToHelpCenter() {
    router.pushNamedRoute({
      name: MineConstants.ROUTER_WEB, params: {
        url: MineConstants.USER_HELP_URL,
        title: "帮助中心"
      }
    }, router.RouterMode.Single)
  }

  private jumpToAppStore() {
    context.openLink(MineConstants.APP_STORE_URL, { appLinkingOnly: false })
      .then(() => {
        console.info('Link opened successfully');
      })
      .catch((error: BusinessError) => {
        console.error('Failed to open link:', error);
      })
  }

  private async share() {
    let shareData: systemShare.SharedData = new systemShare.SharedData({
      utd: utd.UniformDataType.TEXT,
      content: '我正在使用快搜答题神器，支持各类答题平台，快来一起轻松答题吧!官方下载链接:' + MineConstants.APP_STORE_URL,
      title: '快搜搜题',
      description: '我正在使用快搜答题神器，支持各类答题平台，快来一起轻松答题吧！',
      thumbnail: new Uint8Array()
    });

    let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
    let context = getContext(this) as common.UIAbilityContext;
    controller.show(context, {
      selectionMode: systemShare.SelectionMode.SINGLE,
      previewMode: systemShare.SharePreviewMode.DEFAULT,
    }).then(() => {

    }).catch((error: BusinessError) => {

    });
  }

  private goFeedback() {
    context.openLink(MineConstants.FEEDBACK_URL, { appLinkingOnly: false })
      .then(() => {
        console.info('Link opened successfully');
      })
      .catch((error: BusinessError) => {
        console.error('Failed to open link:', error);
      })
  }

  build() {
    Column() {
      Row() {
        Image(this.isLogin() ? this.avatarUrl : $r('app.media.user_icon'))
          .alt($r('app.media.user_icon'))
          .objectFit(ImageFit.Contain)
          .width(48)
          .height(48)
        Column() {
          Text(this.isLogin() ? this.nickName : "立即登录")
            .fontSize(14)
            .fontColor($r("app.color.c_3e3e3e"))
            .textAlign(TextAlign.Start)
            .padding({ left: 16 })
            .lineHeight(20)
          Text(this.isLogin() ? "欢迎使用快搜搜题" : "考试答题，快人一步")
            .fontSize(12)
            .fontColor($r("app.color.c_9d9d9d"))
            .textAlign(TextAlign.Start)
            .padding({ left: 16 })
            .lineHeight(20)
        }.alignItems(HorizontalAlign.Start)
        .width('60%') // 限制左侧部分宽度
        .onClick(() => {
          //跳转登录页面
          this.jumpToLogin()
        })

        // Column() {
        //   Text("签到+2积分")
        //     .fontSize(12)
        //     .lineHeight(22)
        //     .fontColor($r("app.color.c_F75A23"))
        //     .textAlign(TextAlign.Start)
        //     .width('100%')
        //     .onClick(() => {
        //       this.jumpToPoints()
        //     })
        // }
        // .width('30%')
        // .margin({ right: 8 })
      }
      .alignItems(VerticalAlign.Top)
      .margin({ left: 28, top: 40, bottom: 0 })
      .visibility(Visibility.Visible)


      // 会员
      // Row() {
      //   Stack({ alignContent: Alignment.TopStart }) {
      //     Image($r('app.media.rectangle_icon'))
      //       .objectFit(ImageFit.Cover)
      //       .width('auto')
      //       .height(98)
      //
      //     Button('去充值')
      //       .fontSize(10)
      //       .fontColor(Color.Black)
      //       .backgroundColor('#D4AF37')
      //       .borderRadius(50)
      //       .width('auto')
      //       .height(20)
      //       .position({ x: 250, y: 6 })
      //     Stack({ alignContent: Alignment.Center }) {
      //       Image($r('app.media.subtract_icon'))
      //         .objectFit(ImageFit.Cover)
      //         .width(146)
      //         .height(26)
      //       Text('VIP会员中心')
      //         .fontSize(12)
      //         .fontColor(Color.White)
      //         .textAlign(TextAlign.Center)
      //         .width(146)
      //     }
      //     .margin({ top: -8, left: 1 })
      //
      //     Row({ space: 18 }) {
      //       Column() {
      //         Image($r('app.media.group_icon'))
      //           .objectFit(ImageFit.Cover)
      //           .width(28)
      //         Text("免广告搜题")
      //           .fontSize(10)
      //           .fontColor(Color.White)
      //           .textAlign(TextAlign.Center)
      //           .margin({ top: 10 })
      //       }
      //       .width('auto')
      //       .padding(8)
      //       Column() {
      //         Image($r('app.media.group_icon'))
      //           .objectFit(ImageFit.Cover)
      //           .width(28)
      //         Text("隐藏悬浮窗")
      //           .fontSize(10)
      //           .fontColor(Color.White)
      //           .textAlign(TextAlign.Center)
      //           .margin({ top: 10 })
      //       }
      //       .width('auto')
      //       .padding(8)
      //       Column() {
      //         Image($r('app.media.group_icon'))
      //           .objectFit(ImageFit.Cover)
      //           .width(28)
      //         Text("指定搜索题库")
      //           .fontSize(10)
      //           .fontColor(Color.White)
      //           .textAlign(TextAlign.Center)
      //           .margin({ top: 10 })
      //       }
      //       .width('auto')
      //       .padding(8)
      //       Column() {
      //         Image($r('app.media.group_icon'))
      //           .objectFit(ImageFit.Cover)
      //           .width(28)
      //         Text("积分会员")
      //           .fontSize(10)
      //           .fontColor(Color.White)
      //           .textAlign(TextAlign.Center)
      //           .margin({ top: 10 })
      //       }
      //       .width('auto')
      //       .padding(8)
      //     }
      //     .width('90%')
      //     .justifyContent(FlexAlign.SpaceAround)
      //     .margin({ top: 25,left:10 })
      //   }
      //   .width('90%')
      //   .height('auto')
      // }
      // .width('100%')
      // .justifyContent(FlexAlign.Center)

      List() {
        // ListItem() {
        //   UserListItem({
        //     name: $r('app.string.Recharge'),
        //     click: () => {
        //     }
        //   })
        // }

        ListItem() {
          UserListItem({
            name: $r('app.string.my_points'),
            isShow: true,
            // value: "15",
            click: () => {
              this.jumpToPoints()
            }
          })
        }

        ListItem() {
          UserListItem({
            name: $r('app.string.operation_settings'),
            isShow: true,
            click: () => {
              this.jumpToSetting()
            }
          })
        }

        ListItem() {
          UserListItem({
            name: $r('app.string.support_us'),
            isShow: true,
            click: () => {
              // 设置为支持我们内容节点
              // OfficialDialog.setContentNode(this.supportContentNode);
              // OfficialDialog.setOptions({ alignment: DialogAlignment.Center, isModal: true });
              // OfficialDialog.openDialog();
              // onEventObject(MineMobClickConstants.MENU_SUPPORT_US);
              this.jumpToAppStore()
            }
          })
        }

        ListItem() {
          UserListItem({
            name: $r('app.string.share_friend'),
            isShow: true,
            click: () => {
              this.share()
            }
          })
        }

        ListItem() {
          UserListItem({
            name: $r('app.string.follow_official_account'),
            isShow: true,
            click: () => {
              // 设置为关注公众号内容节点
              OfficialDialog.setContentNode(this.contentNode);
              OfficialDialog.openDialog();
              onEventObject(MineMobClickConstants.MENU_MY_CODE)
            }
          })
        }

        ListItem() {
          UserListItem({
            name: $r('app.string.help_center'),
            isShow: true,
            click: () => {
              this.jumpToHelpCenter()
            }
          })
        }


        ListItem() {
          UserListItem({
            name: $r('app.string.feedback'),
            isShow: true,
            click: () => {
              this.goFeedback()
            }
          })
        }

        ListItem() {
          UserListItem({
            name: $r('app.string.about_us'),
            isShow: false,
            click: () => {
              this.jumpToSearchResult()
              onEventObject(MineMobClickConstants.MENU_ABOUT)
            }
          })
        }
      }.margin({ top: 40 })
      .alignListItem(ListItemAlign.Center)
    }
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
  }
}

@Component
struct UserListItem {
  @Prop name: Resource
  isShow: boolean = true
  @Prop value?: string
  click: () => void = () => {

  }

  build() {
    Column() {

      Row({ space: 10 }) {
        Text(this.name)
          .fontSize(16)
          .fontColor($r("app.color.c_3e3e3e"))
          .textAlign(TextAlign.Start)
          .padding({ left: 32 })
          .width('auto')
          .height(54)


        if (this.value) {
          Text(this.value)
            .fontSize(12)
            .fontColor($r("app.color.c_3e3e3e"))
            .textAlign(TextAlign.Start)
            .padding({ right: 32 })
            .width('auto')
            .height(54)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {

      }
      .width('90%')
      .height(1)
      .backgroundColor($r("app.color.c_ebebeb"))
      .margin({ left: 32, right: 32 })
      // .linearGradient({
      //   angle: 90,
      //   colors: [
      //     [$r("app.color.c_transparent"), 0.0],
      //     [$r("app.color.c_ebebeb"), 1],
      //   ]
      // })
      .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)
    }.onClick(() => this.click()).width('100%')
  }
}