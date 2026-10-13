import { BankModel } from '../model/BankModel'
import { BankCategory } from '../model/BankCategory';
import { BankList } from './BankList';
import { LoadingStatus, Logger } from 'utils';
import lottie, { AnimationItem } from '@ohos/lottie';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS'
import BankConstants from '../Constants/BankConstants';
import { router } from '@kit.ArkUI';

const context = (getContext(this) as common.UIAbilityContext)
let jsonData = null


@Entry
@Component
export struct BankPage {
  @State categoryList: Array<BankCategory> = [];
  @State bankModel: BankModel = BankModel.getInstance()
  @State selectedCategoryId: string = "hot"
  private listScroller: Scroller = new Scroller();
  @State focusIndex: number = 0;
  @State loadingStatus: LoadingStatus = LoadingStatus.OFF
  private subController: TabsController = new TabsController();
  @State hasLoadData: boolean = false
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private controller: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings)
  private animateItem: AnimationItem | null = null
  private animateName = "loading"
  private resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })

  aboutToAppear(): void {
    this.initLottie()
    this.loadResources()
  }

  aboutToDisappear(): void {
    lottie.destroy()
  }

  private jumpTohotBankpage() {
    router.pushNamedRoute({ name: BankConstants.ROUTER_HOT_Search })
  }


  @Builder
  subTabBuilder(tab: BankCategory, tabIndex: number) {
    Row() {
      Text(tab.name)
        .fontSize(16)
        .fontColor(this.selectedCategoryId === tab.aid ? '#F75A23' : '#9D9D9D')
        .decoration({
          type: TextDecorationType.None
        })
        .border({
          width: this.selectedCategoryId === tab.aid ? { bottom: 3 } : 0, // 下划线粗细为 3 像素
          color: this.selectedCategoryId === tab.aid ? '#F75A23' : Color.Transparent, // 下划线颜色
          style: BorderStyle.Solid
        })
        .padding({ bottom: 4 })
        .id(tabIndex.toString())
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: 12, right: 12 })
    .height('auto')
    .onClick(() => {
      this.selectedCategoryId = tab.aid
      this.subController.changeIndex(tabIndex);
      this.focusIndex = tabIndex;
    })
  }

  build() {
    Column() {
      Stack(){
        Image($r('app.media.search_bg'))
          .objectFit(ImageFit.Cover)
          .width('auto')
        Stack({alignContent:Alignment.Start}){
          Image($r('app.media.search'))
            .objectFit(ImageFit.Cover)
            .width(340)
            .height(36)
          Row(){
            Image($r('app.media.ic_search'))
              .objectFit(ImageFit.Cover)
              .width(24)
              .height(24)
              .margin({left:10,right:10})

            Text("请输入题库名称或关键词")
              .fontSize(14)
              .fontColor(0XFF9D9D9D)
          }
        }
      }
      .width(380)
      .height(130)
      .onClick(() => {
        this.jumpTohotBankpage()
      })

      // 数据栏
      if (this.hasLoadData && this.loadingStatus === LoadingStatus.LOADING) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Canvas(this.controller)
            .width('30%')
            .height('20%')
            .onReady(() => {
              this.animateItem = lottie.loadAnimation({
                container: this.controller,
                renderer: 'canvas',
                loop: true,
                autoplay: true,
                context: context,
                name: this.animateName,
                animationData: jsonData,
              })
            })
        }

      } else if (this.loadingStatus === LoadingStatus.SUCCESS) {
        Row() {
          List({ initialIndex: 0, scroller: this.listScroller, space: 20 }) {
            ForEach(this.categoryList, (item: BankCategory, index: number) => {
              this.subTabBuilder(item, index)
            }, (item: BankCategory, index: number) => JSON.stringify(item) + index)
          }
          .listDirection(Axis.Horizontal)
          .height(30)
          .scrollBar(BarState.Off)
          .width('100%')
          .friction(0.6)
        }

        Tabs({ barPosition: BarPosition.Start, controller: this.subController }) {
          ForEach(this.categoryList, (item: BankCategory) => {
            TabContent() {
              BankList({
                aid: item.aid
              })
            }
            .backgroundColor(Color.White)
            .margin({ bottom: 30 })

          }, (item: BankCategory, index: number) => JSON.stringify(item) + index)
        }
        .barHeight(0)
        .animationDuration(300)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.selectedCategoryId = this.categoryList[targetIndex].aid
          this.focusIndex = targetIndex;
          this.listScroller.scrollToIndex(targetIndex, true, ScrollAlign.CENTER);
        })
      } else if (this.loadingStatus === LoadingStatus.FAILED) {
        Text('数据请求失败').fontSize(18)
      }
    }
    .height('100%')
    .width('100%')
  }

  async loadResources(): Promise<void> {
    this.loadingStatus = LoadingStatus.LOADING
    let list = await this.bankModel.getBankTypeList()

    if (list.length > 0) {
      this.loadingStatus = LoadingStatus.SUCCESS
      this.categoryList = list
    } else {
      this.loadingStatus = LoadingStatus.FAILED
    }
  }

  //加载 lottie 动画
  private initLottie() {
    // loading.json需要放到lottie包下的rawfile中
    context.resourceManager.getRawFileContent('loading.json', async (err: Error, data: Uint8Array) => {
      if (data === null || data === undefined || data.buffer === undefined) {
        return;
      }
      let lottieStr = await this.resStr.decodeWithStream(new Uint8Array(data.buffer))
      jsonData = JSON.parse(lottieStr);
      this.hasLoadData = true
    })
  }
}

@Component
struct CategoryTabContent {
  private category: BankCategory = { name: '', aid: '', url: '' };
  @State private isSelected: boolean = false

  build() {
    TabContent() {
      Text(this.category.name)// 显示 Category 的名称
        .fontSize(30).fontColor(this.isSelected ? '#F75A23' : '#6665DD');
    }
    .tabBar(this.tabBuilder(this.category.name)); // 设置 TabBar 的标题为 Category 的名称
  }

  @Builder
  tabBuilder(title: string) {
    Column() {
      Text(title)
        .fontColor(this.isSelected ? '#B86E00' : '#7B7B7B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }
}

