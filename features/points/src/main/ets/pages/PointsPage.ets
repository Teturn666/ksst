import { TitleBar } from 'widget/Index'
import { PointsModel } from '../model/PointsModel';
import CheckDataRes, { showSingle } from '../model/CheckDataRes';
import { router } from '@kit.ArkUI';
import PointsConstants from '../../../Constants/PointsConstants';

import('./MyHistoryPage')
import('./MyInvitationPage')

@Entry({ routeName: 'pointsPage' })
@Component
export struct PointsPage {
  @State title: string = "我的积分";
  @State PointsModel: PointsModel = PointsModel.getInstance()
  @State myPoints: string = PointsConstants.POINTS_DAYS_DEFAULT_POINTS
  @State signDays: string = PointsConstants.POINTS_DAYS_DEFAULT_SIGN_DAYS
  @State toShowList: showSingle[] = []
  @State toSignToday: boolean = false
  @State loadingStatus: boolean = false

  aboutToAppear(): void {
    this.loadResources()
  }

  async actionSigning(): Promise<void> {
    let action = false
    action = await this.PointsModel.getTodayPoint()
    if (action == true) {
      await this.gettingPointsInfo()
    }
  }

  async loadResources(): Promise<void> {
    await this.gettingPointsInfo()
  }

  async gettingPointsInfo(): Promise<boolean> {
    this.loadingStatus = false
    try {
      // 获得签到天数
      let sign_days = await this.PointsModel.getSignState()
      sign_days = Math.round(sign_days)
      if (sign_days > 0) {
        this.toSignToday = true
        this.signDays = String(sign_days - 1)
      } else {
        this.signDays = String(Math.abs(sign_days))
      }
      // 获得签到展示
      this.toShowList = []
      let mapLists = await this.PointsModel.getSignMapList()
      let cur_day = Math.abs(sign_days)
      for (let i = 0; i < mapLists.length; i++) {
        let days = mapLists[i].days
        let point = mapLists[i].point
        if (i + 1 <= cur_day) {
          this.toShowList.push(new showSingle(days, point, 1))
        } else {
          this.toShowList.push(new showSingle(days, point, 3))
        }
      }
      if (sign_days > 0) {
        this.toShowList[cur_day - 1].type = 2
      }

      // 获得我的积分
      this.myPoints = await this.PointsModel.getMyNumb()
      this.loadingStatus = true
    } catch (error) {

    }
    return this.loadingStatus
  }

  private jumpToHistoryPoints() {
    router.pushNamedRoute({
      name: PointsConstants.ROUTE_DETAILS_POINTS_HISTORY, params: {
        myPoints: this.myPoints
      }
    })
  }

  private jumpToMyInvitation() {
    router.pushNamedRoute({ name: PointsConstants.ROUTE_DETAILS_INVITATION })
  }

  build() {
    Column() {
      TitleBar({
        title: this.title, backClick: () => {
          router.back()
        }
      }).width('100%')
      Stack() {
        Image($r('app.media.ic_bu'))
          .width(160)
          .height(60)
        Text(this.myPoints)
          .fontSize(32)
          .fontColor('#F75A23')
        Text("积分明细")
          .fontSize(12)
          .fontColor('#F75A23')
          .margin({ top: 100 })
          .decoration({ type: TextDecorationType.Underline, color: '#F75A23' })
          .onClick(() => {
            this.jumpToHistoryPoints();
          })
        Column() {
          Stack() {
            Image($r('app.media.ic_rectangle'))
              .width(80)
              .height(28)
            Text("我的邀请码")
              .fontColor('#3E3E3E')
              .fontSize(12)

          }.onClick(() => {
            this.jumpToMyInvitation()
          })

          // Stack() {
          //   Image($r('app.media.ic_rectangls'))
          //     .width(80)
          //     .height(28)
          //   Text("积分兑换")
          //     .fontColor('#3E3E3E')
          //     .fontSize(12)
          // }
        }
        .height('70')
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.End)

      }
      .width('100%')
      .alignContent(Alignment.Center)

      Column() {
        Row() {
          Image($r('app.media.ic_gold'))
            .width(18)
            .height(18)

          Text("签到赚积分")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .margin({ left: 8 })
        }
        .margin({ left: 15, top: 10 })

        if (this.loadingStatus == false) {

        } else {
          Stack() {
            Image($r('app.media.ic_bg'))
              .width(330)
              .height(108)

            // Points Cards Row
            Row({ space: 5 }) {
              ForEach(this.toShowList, (item: showSingle) => {
                PointsCard({
                  points: item.point + '积分',
                  status: item.type == PointsConstants.POINTS_DAYS_STATUS_GOT ? "已领取" :
                    (item.type == PointsConstants.POINTS_DAYS_STATUS_ACTION ? "点击领取" : "未领取"),
                  isClaimed: item.type == PointsConstants.POINTS_DAYS_STATUS_GOT ? true : false,
                  canClaim: item.type == PointsConstants.POINTS_DAYS_STATUS_ACTION ? true : false,
                  onClaim: item.type == PointsConstants.POINTS_DAYS_STATUS_ACTION ? this.actionSigning : () => {
                  }
                }).onClick(async () => {
                  if (item.type == PointsConstants.POINTS_DAYS_STATUS_ACTION) {
                    await this.actionSigning()
                  }
                })
              })
            }
            .height(78)
            .alignItems(VerticalAlign.Top)

            Row() {
              Text("说明：连续中断后重新开始计算")
                .fontSize(10)
                .fontColor('#BABABA')

              Text("已连续签到" + this.signDays + "天")
                .fontColor(Color.White)
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
            }
            .height(12)
            .width(313)
            .margin({ top: 60 })
            .alignItems(VerticalAlign.Bottom)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ bottom: 10 })
          }
          .margin({ top: 8 })
          .width('100%')
          .height('auto')
        }
      }
      .borderRadius(12)
      .padding({ top: 8 })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 15 })
      .width('95%')
      .height('100%')
      .backgroundColor(Color.White)
    }
    .backgroundColor('#fdcf8d')
    .height('100%')
    .width('100%')
  }
}

@ComponentV2
struct PointsCard {
  @Param points: string = ''; // e.g., "1积分", "2积分"
  @Param status?: string = ''; // e.g., "已领取", "点击领取", "未领取"
  @Param isClaimed?: boolean = false; // Determines if the card is claimed
  @Param canClaim?: boolean = false; // Determines if the card can be claimed today
  @Event onClaim: () => void; // Callback for claiming points

  build() {
    Stack() {
      Image(this.isClaimed ? $r('app.media.ic_pointsbgs') : $r('app.media.ic_pointsbg'))
        .width(41)
        .height(50)
      Column() {
        Text(this.points)
          .fontColor('#565656')
          .fontSize(10)

        Text(this.status)
          .fontColor(this.canClaim ? '#F75A23' : '#565656')
          .fontSize(8)
          .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width(41)
    .height(50)

  }
}

