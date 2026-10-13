import { HomePage } from 'home/Index';
import { BankPage } from 'bank/Index';
import { MinePage } from 'mine/Index';
import { CustomTabBar } from '../components/CustomTabBar';
import { AppConstants } from '../constants/AppConstants';
import { TabBarType } from '../model/TabBarModel';
import router from '@ohos.router'
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { init, onEventObject } from '@umeng/analytics';
import { questionBankTable, questionTable, questionWrongTable, questionCollectionTable } from 'db'

const context = (getContext(this) as common.UIAbilityContext)

@Entry
@Component
struct MainPage {
  @LocalStorageLink('mainTabIndex') currentIndex: TabBarType = TabBarType.HOME;
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();
  @State showDialog: boolean = false
  private sp: preferences.Preferences | null = null
  @Provide nickName: string = ''
  @Provide avatarUrl: string = ''
  @Provide loginState: string = '0' //0=未登录

  onPageShow(): void {
    const params = router.getParams() as Record<string, string>
    if (params) {
      this.nickName = params.nickName as string
      this.avatarUrl = params.avatarUrl as string
      this.loginState = params.loginState as string
    }
  }

  private initPreferences() {
    this.sp = preferences.getPreferencesSync(context, AppConstants.SP_OPTIONS)
    let show = this.sp.getSync("isFirstInstall", true)
    if (typeof show === 'boolean') {
      this.showDialog = show
    }
  }

  // 修改布尔值的方法
  updateBooleanValue(newValue: boolean) {
    try {
      // 同步更新布尔值
      this.sp?.putSync("isFirstInstall", newValue);
      // 同步保存更改
      this.sp?.flushSync();
    } catch (err) {
      console.error('更新布尔值失败:', err);
    }
  }

  aboutToAppear(): void {
    this.initPreferences()
    this.initDB()
  }

  initDB() {
    questionBankTable.getRdbStore()
    questionTable.getRdbStore()
    questionWrongTable.getRdbStore()
    questionCollectionTable.getRdbStore()
  }

  build() {
    RelativeContainer() {
      Navigation(this.appPathStack) {
        Flex({
          direction: FlexDirection.Column,
        }) {
          Tabs({ index: this.currentIndex }) {
            TabContent() {
              HomePage()
            }

            TabContent() {
              BankPage()
            }

            TabContent() {
              MinePage()
            }
          }
          .layoutWeight(1)
          .barHeight(0)
          .scrollable(false)
          .onChange((index) => {
            this.currentIndex = index
          })

          CustomTabBar({ currentIndex: $currentIndex })
        }
        .width(AppConstants.FULL_PERCENT)
        .height(AppConstants.FULL_PERCENT)
        .backgroundColor($r('app.color.start_window_background'))
      }
      .hideTitleBar(true)
      // .navDestination(this.appRouter)
      .mode(NavigationMode.Stack)

      if (this.showDialog) {
        Column() {
          Blank()
          Column() {
            Row() {
              Text("用户协议").fontColor($r('app.color.c_f75a23'))
                .fontSize(18).onClick(() => {
                router.pushNamedRoute({
                  name: "webPage", params: {
                    url: "https://ti.iksdt.com/static/doc/yszc.html",
                    title: "用户协议"
                  }
                })
              }).margin({ left: 12 })
              Text("和").fontColor($r('app.color.c_3e3e3e'))
                .fontSize(18)
              Text("隐私政策").fontColor($r('app.color.c_f75a23'))
                .fontSize(18).onClick(() => {
                router.pushNamedRoute({
                  name: "webPage", params: {
                    url: "https://ti.iksdt.com/static/doc/yszc.html",
                    title: "用户协议"
                  }
                })
              })
              Blank()
            }.width('100%').margin({ top: 32 })

            Row() {
              Text($r('app.string.privacy_hint'))
                .fontColor($r('app.color.c_8a8a8a'))
                .fontSize(14)
                .padding({ left: 12, right: 12 })
            }.width('100%')

            Row() {
              Blank()
              Text("不同意并退出")
                .fontColor($r('app.color.c_b1844e'))
                .fontSize(12)
                .width('40%')
                .height(80)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  context.terminateSelf()
                })
              Blank()
              Text("同意并继续")
                .fontColor($r('app.color.c_2a5089'))
                .fontSize(12)
                .width('40%')
                .height(80)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.showDialog = false
                  this.updateBooleanValue(false)
                  init(); // 在用户同意隐私政策后再调用此方法
                  // onEventObject("eventA", {
                  //   "key": "value"
                  // }); // 埋个点
                })
              Blank()
            }.width('100%')
          }.width('90%').linearGradient({
            colors: [
              [$r("app.color.c_f6eee3"), 0.0],
              [$r("app.color.c_f4f3fb"), 0.5],
              [$r("app.color.start_window_background"), 1],
            ]
          }).borderRadius(5)

          Blank()
        }.width('100%').height('100%').backgroundColor($r('app.color.c_99000000'))
      }

    }
  }
}