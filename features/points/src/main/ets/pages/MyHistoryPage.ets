import { TitleBar } from 'widget/Index'
import router from '@ohos.router';
import { PointEventRes, PointsDetail as PointsDetail } from '../model/CheckDataRes';
import { PointsModel } from '../model/PointsModel';
import PointsConstants from '../../../Constants/PointsConstants';

@Entry({ routeName: 'myHistoryPage' })
@Component
export struct MyHistoryPage {
  @State title:string = "积分明细";
  @State nPoints : string = '0';
  @State selectedCategoryId: string = "全部"
  @State PointsModel: PointsModel = PointsModel.getInstance()
  @State historyIncrease: PointsDetail[] = []
  @State historyDetail: PointsDetail[] = []
  @State historyConsume: PointsDetail[] = []
  @State focusIndex: number = 0;
  @State dataContent: PointsDetail[][] = []
  categoryPoints: string[] = []
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private controller: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings)
  private listScroller: Scroller = new Scroller();
  private subController: TabsController = new TabsController();

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params) {
      this.nPoints = params.myPoints as string
    }
      this.loadResource()
  }


  async loadResource(): Promise<void>{
    // 获取数据
    this.categoryPoints = PointsConstants.POINTS_CATEGORY_HISTORY
    let pointsHistory= await this.PointsModel.getHistoryPoint()
    this.historyDetail = this.DataToObjectP(pointsHistory,'')
    let pointsIncrease = await this.PointsModel.getHistoryPsIncrease()
    this.historyIncrease = this.DataToObjectP(pointsIncrease,'+')
    let pointsConsume =  await this.PointsModel.getHistoryPsConsumer()
    this.historyConsume = this.DataToObjectP(pointsConsume,'-')

    // 处理数据
    this.dataContent = [this.historyDetail,this.historyIncrease,this.historyConsume]
 }

  public DataToObjectP(data:PointEventRes[], type:string) {
    // 清洗数据
    if(data == null || data.length == 0)
      return []

    let res: PointsDetail[] = []
    for(const node of data){
      let points = type + String(node.pointUpdate)
      if(type == '' && node.pointUpdate > 0){
        points = '+'+ String(node.pointUpdate)
      }
      res.push(new PointsDetail(node.behavior,points, node.time))
    }

    return res
  }

  @Builder
  subTabBuilder(tab: string, tabIndex: number) {
    Row() {
      Text(tab)
        .fontSize(tabIndex === 0 ? 20 : 16)
        .fontColor(this.selectedCategoryId ===this.categoryPoints[tabIndex] ? '#F75A23' : '#9D9D9D')
        .decoration({
          type: TextDecorationType.None
        })
        .border({
          width: this.selectedCategoryId === this.categoryPoints[tabIndex] ? { bottom: 3 } : 0, // 下划线粗细为 3 像素
          color: this.selectedCategoryId === this.categoryPoints[tabIndex] ? '#F75A23' : Color.Transparent, // 下划线颜色
          style: BorderStyle.Solid
        })
        .padding({ bottom: 4 })
        .id(tabIndex.toString())
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: 12, right: 12 })
    .height('auto')
    .onClick(() => {
      this.selectedCategoryId = this.categoryPoints[tabIndex]
      this.subController.changeIndex(tabIndex);
      this.focusIndex = tabIndex;
    })
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

        Text(this.nPoints)
          .fontSize(38)
          .fontColor('#F75A23')

        Text("可用积分")
          .fontSize(12)
          .fontColor('#F75A23')
          .margin({ top: 40 })
        // Column() {
        //   Stack() {
        //     Image($r('app.media.ic_rectangle'))
        //       .width(80)
        //       .height(28)
        //     Text("我的邀请码")
        //       .fontColor('#3E3E3E')
        //       .fontSize(12)
        //   }
        //
        //   Stack() {
        //     Image($r('app.media.ic_rectangls'))
        //       .width(80)
        //       .height(28)
        //     Text("积分兑换")
        //       .fontColor('#3E3E3E')
        //       .fontSize(12)
        //   }
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
            List({ initialIndex: 0, scroller: this.listScroller, space: 20 }) {
              ForEach(this.categoryPoints, (item: string, index: number) => {
                this.subTabBuilder(item, index)
              }, (item: string, index: number) => JSON.stringify(item) + index)
            }
            .listDirection(Axis.Horizontal)
            .height(30)
            .scrollBar(BarState.Off)
            .width('100%')
            .friction(0.6)
          }
          .margin({ left: 15, top: 10 })
          Tabs({ barPosition: BarPosition.Start, controller: this.subController }) {
            ForEach(this.categoryPoints, (item: string,index:number) => {
              TabContent() {
                  List() {
                    ForEach(
                      this.dataContent[index],
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
                      Text('没有更多数据')
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
            }, (item: string, index: number) => JSON.stringify(item) + index)
          }
          .barHeight(0)
          .animationDuration(300)
          .onAnimationStart((index: number, targetIndex: number) => {
            this.selectedCategoryId = this.categoryPoints[targetIndex]
            this.focusIndex = targetIndex;
            this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
          })
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
    }
    .backgroundColor('#fffaf6f2')
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