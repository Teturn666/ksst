import { router } from '@kit.ArkUI';
import { PointsModel } from '../model/PointsModel';
import promptAction from '@ohos.promptAction';

@Entry({ routeName: 'myBoundPage' })
@Component
struct BoundPage {
  @State title: string = "绑定邀请码";
  @State boundCode: string = "";
  @State PointsModel: PointsModel = PointsModel.getInstance()
  @State imageWidth: number = 200; // 固定宽度
  @State imageHeight: number = 200; // 自动计算高度
  @State inputValue: string = ''
  @State promptText: string = ''
  @State showToast: boolean = false;
  @State toastMessage: string = '';
  aboutToAppear(): void {
    this.loadResource()
  }
  async loadResource(): Promise<void>{
    // 获取数据
    this.boundCode = await this.PointsModel.getBoundCode()
    this.boundCode = ''
  }

  async submitBoundCode(code:string):Promise<void>{
    this.promptText = await this.PointsModel.submitBoundCode(code)
    if(this.promptText == "done"){
      this.boundCode = code
    }else{
      this.showToastMessage(this.promptText)
    }
  }
  // 显示 Toast 的方法
  showToastMessage(message: string) {
    this.toastMessage = message;
    this.showToast = true;

    // 3秒后自动隐藏
    setTimeout(() => {
      this.showToast = false;
    }, 3000);
  }

  build() {
    Column() {
      if(this.boundCode == ''){


        Column(){
          Text('').height('100')
          Image($r('app.media.hand'))
            .width(150)
            .height(150)

          TextInput()
            .width('90%') // 宽度
            .height('70')
            .margin({top:50})
            .onChange((value)=>{
              this.inputValue = value
            })

          Column(){
            Text("绑定邀请码")
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
              .fontColor('#ffb7771d')
              .margin({ left: 8, top:5 })
            Text("绑定后不可更改和解绑")
              .fontSize(17)
              .fontWeight(FontWeight.Bold)
              .fontColor('#fdcf8d')
              .margin({ left: 8, top:5 })
          }
          .backgroundColor('#ffeae6df')
          .margin({top:20})
          .width("80%")
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .onClick(async ()=>{
            await this.submitBoundCode(this.inputValue)
          })

          // Toast 组件
          if (this.showToast) {
            Column() {
              Text(this.toastMessage)
                .fontSize(14)
                .fontColor(Color.White)
                .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            }
            .backgroundColor('#333333') // 半透明黑色背景
            .borderRadius(24) // 圆角矩形
            .position({ x: '10%', y: '85%' }) // 屏幕底部
            .alignItems(HorizontalAlign.Center)
            .width('fit-content')
            .height('fit-content')
            .opacity(0.9) // 透明度
            .zIndex(999) // 确保在最上层
            .onClick(() => this.showToast = false) // 点击可提前关闭
          }


          Text("暂不填写/无邀请码")
            .fontSize(15)
            .fontColor('#F75A23')
            .margin({ top: 25 })
            .decoration({ type: TextDecorationType.Underline, color: '#F75A23' })
            .onClick(() => {
              router.back()
            })

          Text("积分可用于兑换会员权益")
            .fontSize(12)
            .fontColor('#ff0c0c0c')
            .margin({ top: 130 })
            .onClick(() => {
              router.back()
            })
          Text("30天内可到我的积分-我的邀请码页面进行绑定")
            .fontSize(12)
            .fontColor('#ff131211')
            .margin({ top: 1 })
            .onClick(() => {
              router.back()
            })

        }.alignItems(HorizontalAlign.Center)







      }else {
        Column(){
          Text('').height('100')
          Image($r('app.media.hand'))
            .width(100)
            .height(100)

          Text("已绑定邀请码")
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .fontColor('#fdcf8d')
            .margin({ left: 8, top:25 })
          Text(this.boundCode)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor('#fdcf8d')
            .margin({ left: 8,top:30 })

          Button("返回")
            .width('100')
            .height('70')
            .borderColor('#fff1e4d1')
            .backgroundColor('#fff1e4d1')
            .margin({ left: 8,top:30 })
            .onClick(()=>{
              router.back()
            })
        }.alignItems(HorizontalAlign.Center)
      }
    }
    .backgroundColor('#fff5f4f2')
    .height('100%')
    .width('100%')
  }

}

@ComponentV2
struct HistoryCard {
  @Param points: string = ''; // e.g., "1积分", "2积分"
  @Param name: string = '';
  @Param time: string = '';

  build() {
    Row() {
      Column() {
        Text(this.name)
          .fontColor('#565656')
          .fontSize(18)

        Text("操作时间: "+this.time)
          .fontColor('#565656')
          .fontSize(13)
          .margin({ top: 5 })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .width('70%')
      .padding({left:20})

      Column(){
        Text(this.points + "积分")
          .fontColor('#fff11818')
          .fontSize(18)
      }
      .width('30%')
    }
    .borderRadius(12)
    .margin({top:0})
    .padding({ top: 5,bottom:5,})
    .backgroundColor(Color.Gray)
    .width('100%')
    .height(70)
  }
}