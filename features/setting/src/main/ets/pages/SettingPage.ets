import { TitleBar } from 'widget/Index'
import { SettingConstants } from "../Constants/SettingConstants";
import { promptAction, router } from '@kit.ArkUI';
import { preferencesUtils } from '../Constants/PreferencesUtil'
import { preferences } from '@kit.ArkData';
import { LoginConstants } from 'login/Index';
import { common } from '@kit.AbilityKit';

const context = (getContext(this) as common.UIAbilityContext)
let sp = preferences.getPreferencesSync(context, LoginConstants.SP_OPTIONS)

@Entry({ routeName: 'settingPage' })
@Component
export struct SettingPage {
  @State maskOpacity: number = 0;
  @State title: string = '关于设置'
  @State isDialogVisible: boolean = false;
  @State questionCounts: string[] = SettingConstants.ROUTER_SETTING_NUMBERS_QUESTIONS;
  @State v: string = SettingConstants.ROUTER_SETTING_NUMBERS_QUESTIONS[0];
  private select: number | number[] = 0;
  @State loginState: string = "0"

  // 初始化时加载保存的题目数量
  aboutToAppear() {
    this.loadResource()
    sp.getSync(LoginConstants.SP_IS_LOGIN, '0')
    let loginStatus = sp.getSync(LoginConstants.SP_IS_LOGIN, '0')
    if (typeof loginStatus === 'string') {
      this.loginState = loginStatus
    }
  }

  loadResource() {
    preferencesUtils.getPreferences()
    this.questionCounts = SettingConstants.ROUTER_SETTING_NUMBERS_QUESTIONS
    let count = preferencesUtils.read(SettingConstants.ROUTER_SETTING_NAME_NUMBERS_QUESTIONS, 0)
    if (count != undefined) {
      this.v = this.questionCounts[Number(count)]
      this.select = Number(count)
    }
  }

  // 保存题目数量设置
  saveQuestionCount() {
    preferencesUtils.write(SettingConstants.ROUTER_SETTING_NAME_NUMBERS_QUESTIONS, String(this.select))
    preferencesUtils.write(SettingConstants.ROUTER_SETTING_NAME_NUMBERS_QUESTIONS_GLOBAL, this.v)
  }

  private isLogin() {
    return this.loginState === '1'
  }

  private loginOut() {
    sp.putSync(LoginConstants.SP_IS_LOGIN, '0')
    sp.putSync(LoginConstants.SP_NICK_NAME, '')
    sp.putSync(LoginConstants.SP_AVATAR_URL, '')
    sp.putSync(LoginConstants.SP_UNION_ID, '')
    sp.putSync(LoginConstants.SP_OPEN_ID, '')
    sp.flushSync()
    let index = Number(router.getLength()) - 1
    router.back(
      index, {
      nickName: '',
      avatarUrl: '',
      loginState: '0'
    })

  }

  build() {
    Column() {
      // 标题栏
      TitleBar({
        title: this.title, backClick: () => {
          router.back()
        }
      }).width('100%')
      // 考试设置标题
      Column() {
        Text('考试设置')
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
          .fontColor("#3e3e3e")
          .textAlign(TextAlign.Start)
          .padding({ left: 16, top: 16, bottom: 16 })
          .lineHeight(20)
          .margin({ left: 20 })
      }
      .margin({ top: 5 })
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)

      // 用户协议行（显示当前题目数量）
      Column() {
        Row() {
          Text("考试一轮题目数量")
            .fontSize(16)
            .fontColor("#3e3e3e")
            .textAlign(TextAlign.Start)
            .padding({ left: 16, top: 16, bottom: 16 })
            .lineHeight(20)
          Blank()
          Text(`${this.v} 题`)
            .fontSize(16)
            .fontColor("#007DFF")
            .textAlign(TextAlign.Start)
            .padding({ left: 16, top: 16, bottom: 16 })
            .lineHeight(20)
            .margin({ right: 10 })
          Image($r('app.media.ic_enter')).width(6).height(10)
            .margin({ right: 12 })
        }
        .width('100%')
        .onClick(() => {
          TextPickerDialog.show({
            // 建议使用 this.getUIContext().showTextPickerDialog()接口
            range: this.questionCounts,
            selected: this.select,
            disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
            textStyle: { color: Color.Black, font: { size: 20, weight: FontWeight.Normal } },
            selectedTextStyle: { color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } },
            onAccept: (value: TextPickerResult) => {
              // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
              this.select = value.index;
              console.log(this.select + '');
              // 点击确定后，被选到的文本数据展示到页面
              this.v = value.value as string;

              // 数据持久化
              this.saveQuestionCount()

              console.info("TextPickerDialog:onAccept()" + JSON.stringify(value));
            },
            onCancel: () => {
              console.info("TextPickerDialog:onCancel()");
            },
            onChange: (value: TextPickerResult) => {
              console.info("TextPickerDialog:onChange()" + JSON.stringify(value));
            },
            onScrollStop: (value: TextPickerResult) => {
              console.info("TextPickerDialog:onScrollStop()" + JSON.stringify(value));
            },
            onDidAppear: () => {
              console.info("TextPickerDialog:onDidAppear()");
            },
            onDidDisappear: () => {
              console.info("TextPickerDialog:onDidDisappear()");
            },
            onWillAppear: () => {
              console.info("TextPickerDialog:onWillAppear()");
            },
            onWillDisappear: () => {
              console.info("TextPickerDialog:onWillDisappear()");
            }
          });
          this.isDialogVisible = true
        })
      }
      .width('90%')
      .margin({ top: 1, left: 20 })
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#f9f9f9')
      .borderRadius(5)

      // 登录设置标题
      Column() {
        Text('登录设置')
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
          .fontColor("#3e3e3e")
          .textAlign(TextAlign.Start)
          .padding({ left: 16, top: 16, bottom: 16 })
          .lineHeight(20)
          .margin({ left: 20 })
      }
      .visibility(this.isLogin() ? Visibility.Visible : Visibility.Hidden)
      .margin({ top: 5 })
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)

      Column() {
        Row() {
          Text("退出登录")
            .fontSize(16)
            .fontColor("#3e3e3e")
            .textAlign(TextAlign.Start)
            .padding({ left: 16, top: 16, bottom: 16 })
            .lineHeight(20)
          Blank()
          Image($r('app.media.ic_enter')).width(6).height(10)
            .margin({ right: 12 })
        }
        .width('100%')
      }
      .visibility(this.isLogin() ? Visibility.Visible : Visibility.Hidden)
      .width('90%')
      .margin({ top: 1, left: 20 })
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#f9f9f9')
      .borderRadius(5)
      .onClick(() => {
        this.loginDialog('退出登录', '你确定要退出登录吗？')
      })

      Column() {
        Row() {
          Text("注销登录")
            .fontSize(16)
            .fontColor("#3e3e3e")
            .textAlign(TextAlign.Start)
            .padding({ left: 16, top: 16, bottom: 16 })
            .lineHeight(20)
          Blank()
          Image($r('app.media.ic_enter')).width(6).height(10)
            .margin({ right: 12 })
        }
        .width('100%')
      }
      .visibility(this.isLogin() ? Visibility.Visible : Visibility.Hidden)
      .width('90%')
      .margin({ top: 1, left: 20 })
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#f9f9f9')
      .borderRadius(5)
      .onClick(() => {
        this.loginDialog('注销登录', '你确定要注销登录吗？')
      })

      /* // 弹窗组件（使用半透明遮罩）
       if (this.isDialogVisible) {
         Stack() {
           // 背景遮罩
           // 弹窗内容
           Column() {
             // 标题
             Text('考试一轮题目数')
               .fontSize(18)
               .fontWeight(FontWeight.Bold)
               .margin({ top: 24, bottom: 16 })
             // 按钮区域
             Column() {
               ForEach(this.questionCounts, (count: string) => {
                 Row() {
                   Radio({
                     value: String(count) ,
                     group:'radioGroup'

                   }).checked( this.selectedCount == count ?true:false)
                     .onChange((isSelected:boolean) => {
                     if (isSelected) {
                       this.selectedCount = count;
                     }
                   })
                     .margin({ left: 10 })

                   Text(`${count}题`)
                     .fontSize(16)
                     .margin({ left: 10 })

                   Blank()
                 }
                 .width('100%')
                 .height(48)
                 .onClick(() => {
                   this.selectedCount = count;
                 })
               })
             }
             .width('90%')
             // 按钮区域
             Row() {
               Button('取消')
                 .onClick(() => {
                   this.isDialogVisible = false;
                 })
                 .width('40%')
                 .height(44)
                 .backgroundColor('#F5F5F5')
                 .fontColor('#333333')

               Button('确定')
                 .onClick(() => {
                   this.saveQuestionCount();
                   this.isDialogVisible = false;
                 })
                 .width('40%')
                 .height(44)
                 .backgroundColor('#007DFF')
                 .fontColor(Color.White)
             }
             .width('100%')
             .justifyContent(FlexAlign.SpaceAround)
             .margin({ top: 24, bottom: 16 })
           }
           .width(300)
           .height('auto')
           .backgroundColor("#ffa1c6ec")
           .borderRadius(12)
           .position({ x: '5%', y: '0%',  })
         }
         .width('100%')
         .height('100%')
         .borderRadius(12)
         .padding({ top: 8, })
         .backgroundColor(Color.White)
       }*/
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }

  //退出弹窗
  private loginDialog(title: string, content: string) {
    promptAction.showDialog({
      title: title,
      message: content,
      buttons: [
        { text: '取消', color: '#666666' },
        { text: '确定', color: '#d2a129' },
      ],
    }).then(async (data) => {
      if (data.index === 1) {
        this.loginOut()
      }
    })
  }
}