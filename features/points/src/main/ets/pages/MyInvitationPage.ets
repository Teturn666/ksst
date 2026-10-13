import { TitleBar } from 'widget/Index'
// import {clipboard}  from '@ohos.clipboard';
import pasteboard from '@ohos.pasteboard'
import promptAction from '@ohos.promptAction'
import { router } from '@kit.ArkUI';
import { PointEventRes, PointsDetail } from '../model/CheckDataRes';
import { PointsModel } from '../model/PointsModel';
import PointsConstants from '../../../Constants/PointsConstants';

import ('./BoundPage')
@Entry({ routeName: 'myInvitationPage' })
@Component
struct MyInvitationPage {
  @State title: string = "我的邀请码";
  @State myCode: string = "";
  @State pInvited: number = 0
  @State PointsModel: PointsModel = PointsModel.getInstance()
  @State creditsTotal: number = 0
  @State showToast: boolean = false;
  @State toastMessage: string = '复制成功';
  @State peopleList: PointsDetail[] = []
  aboutToAppear(): void {
    this.loadResource()
  }

  handleCopyText(text:string) {
    // 创建剪贴板内容对象
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    // 获取系统剪贴板
    let systemPasteboard = pasteboard.getSystemPasteboard()
    // 清空系统剪贴板
    systemPasteboard.clearData().then(() => {
      // 将数据写入系统剪贴板
      systemPasteboard.setData(pasteData).then(() => {
        promptAction.showToast({
          message: '复制成功',
        })
      }).catch((err:Error) => {
        promptAction.showToast({
          message: err.message,
        })
      });
    }).catch((err:Error) => {

    });
  }
  handlePasteText() {
    let systemPasteboard = pasteboard.getSystemPasteboard()
   //  return new Promise((resolve, reject) => {
   // // 判断系统剪贴板中是否存在数据
   // systemPasteboard.hasData()
   //   .then((hasData: boolean) => {
   //     Logger.info('has data in PasteData:', JSON.stringify(hasData))
   //     if (!hasData) {
   //       promptAction.showToast({
   //         message: '系统剪贴板中不否存在数据',
   //       })
   //       return
   //     }
   //     // 获取系统剪贴板中的数据
   //     systemPasteboard.getData()
   //       .then((pasteData: pasteboard.PasteData) => {
   //         // 从PasteData对象中获取被复制的文本内容
   //         let text: string = pasteData.getPrimaryText()
   //         Logger.info('pasteboard content:', JSON.stringify(text))
   //         resolve(text)
   //       })
   //       .catch((err) => {
   //         Logger.error('Failed to get PasteData. Cause: ', err.message)
   //         reject(err)
   //       })
   //   })
   //   .catch((err) => {
   //     Logger.error('Failed to check the PasteData. Cause:', err.message)
   //     reject(err)
   //   })
   //  })
  }




  async loadResource(): Promise<void>{
    // 获取数据
    this.myCode = await this.PointsModel.getMyCode()
    let pointsHistory= await this.PointsModel.getMyPeople()
    this.peopleList = this.DataToObjectP(pointsHistory,'')
    // this.peopleList = [new PointsDetail("12","12","12"),
    //   new PointsDetail("12","12","12"),
    //   new PointsDetail("12","12","12"),
    //   new PointsDetail("12","12","12"),
    //   new PointsDetail("12","12","12"),
    //   new PointsDetail("12","12","12"),
    //   new PointsDetail("12","12","12"),]

  }
  public DataToObjectP(data:PointEventRes[], type:string) {
    // 清洗数据
    if(data == null || data.length == 0)
      return []
    let point = 0
    let res: PointsDetail[] = []
    for(const node of data){
      let points = type + String(node.pointUpdate)
      point += node.pointUpdate
      if(type == '' && node.pointUpdate > 0){
        points = '+'+ String(node.pointUpdate)
      }
      res.push(new PointsDetail(node.behavior,points, node.time))
    }
    this.creditsTotal = point
    return res
  }

  // 复制到剪贴板的方法
  copyToClipboard() {
    try {
      // 设置剪贴板内容
      this.handleCopyText(this.myCode)

    } catch (error) {

    }
  }

  private jumpToMyBoundCode() {
    router.pushNamedRoute({ name: PointsConstants.ROUTE_BOUND_CODE})
  }

  build() {
    Column() {
      TitleBar({
        title: this.title, backClick: () => {
          router.back()
        }
      })
        .width('100%')
      Stack() {
        Image($r('app.media.ic_bu'))
          .width(160)
          .height(60)
        Text(this.myCode)
          .fontSize(32)
          .margin({ top: 10 })
          .fontColor('#F75A23')
        Text("复制邀请码")
          .fontSize(12)
          .fontColor('#F75A23')
          .margin({ top: 70 })
          .decoration({ type: TextDecorationType.Underline, color: '#F75A23' })
          .onClick(() => {
            this.copyToClipboard()
          })
        // Column() {
        //   Stack() {
        //     Image($r('app.media.ic_rectangle'))
        //       .width(80)
        //       .height(28)
        //     Text("绑定邀请码")
        //       .fontColor('#3E3E3E')
        //       .fontSize(12)
        //   }
        //   .onClick(()=>{
        //     this.jumpToMyBoundCode()
        //   })
        //
        // }
        // .height('70')
        // .width('100%')
        // .justifyContent(FlexAlign.SpaceBetween)
        // .alignItems(HorizontalAlign.End)

      }
      .width('100%')
      .alignContent(Alignment.Top)

      Column() {
        Column(){
          Row() {
            Column(){
              Text("我邀请的好友")
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ left: 10 })
            }
            .width('50%')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Start)
            Column(){
              Text("累计邀请" +this.peopleList.length+"人 累计获得"+this.creditsTotal+"积分")
                .fontSize(10)
                .fontColor('#333333')
                .margin({ right: 8 })
            }
            .width('50%')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.End)
          }
          if(this.peopleList.length == 0){
            Column(){
              Image($r('app.media.hand'))
                .width(150)
                .height(150)
                .margin({top:50})
              Row(){
                  Text("暂时没有邀请的好友哦～"){
                  }
                  .fontSize(18)
                  .fontColor('#333333')
                  .margin({ right: 8 })
                }
                .height('30%')
                .alignItems(VerticalAlign.Center)
            }
            .backgroundColor(Color.White)
            .margin({ bottom:0})
            .width('100%')
            .height('100%')
          }else{
            Column(){
              List() {
                ForEach(
                  this.peopleList,
                  (item: PointsDetail, index: number) => {
                    ListItem() {
                      HistoryCard({
                        points: item.points,
                        name: item.behavior,
                        time: item.time
                      })
                    }
                    .width('100%')
                    .margin({bottom:10,top:10})
                  },
                  (item: PointsDetail) => JSON.stringify(item)) // 使用唯一ID或索引
                ListItem() {
                  Text('')
                    .fontColor($r('app.color.c_9d9d9d'))
                    .height(50) // 底部留白高度，可根据需要调整
                }
                .width('100%')
              }
              .width('95%')
              .height('100%')
              .margin({ left: 5 ,bottom:0})
              .layoutWeight(1)
            }
            .backgroundColor(Color.White)
            .margin({ bottom:0})
            .width('100%')
            .height('100%')
          }


        }
      }
      .borderRadius(12)
      .padding({ top: 8 })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 15 })
      .width('95%')
      .height('80%')
      .backgroundColor(Color.White)

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
        .width('80%')
        .position({ x: '40%', y: '85%' }) // 屏幕底部
        .alignItems(HorizontalAlign.Center)
        .width('fit-content')
        .height('fit-content')
        .opacity(0.9) // 透明度
        .zIndex(999) // 确保在最上层
        .onAppear(() => {
          // 2秒后自动隐藏提示
          setTimeout(() => {
            this.showToast = false;
          }, 2000);
        })
      }

    }
    .backgroundColor('#fff8e9da')
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
    .backgroundColor('#fff8f8f2')
    .width('100%')
    .height(70)
  }
}