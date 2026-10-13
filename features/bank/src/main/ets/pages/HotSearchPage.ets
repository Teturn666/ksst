import { BankModel } from '../model/BankModel';
import { Logger, LoadingStatus } from 'utils';
import lottie, { AnimationItem } from '@ohos/lottie';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { BankList } from './BankList';
import { QuestionList } from './QuestionList';
import { router } from '@kit.ArkUI';

const TAG = '[HotSearchPage]';
const context = (getContext(this) as common.UIAbilityContext);
let jsonData = null;


@Entry({ routeName: 'hotSearchPage' })
@Component
export struct HotSearchPage {
  @State searchText: string = '';
  private controller: TextInputController = new TextInputController();
  @State bankModel: BankModel = BankModel.getInstance();
  @State hotSearchItems: string[] = [];
  @State loadingStatus: LoadingStatus = LoadingStatus.OFF;
  @State hasLoadData: boolean = false;
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private controllerCanvas: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings);
  private animateItem: AnimationItem | null = null;
  private animateName = "loading";
  private resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
  private listScroller: Scroller = new Scroller();
  @State isHotSearchVisible: boolean = true;
  @State selectedTabIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  aboutToAppear(): void {
    this.initLottie();
    this.loadResources();
  }

  aboutToDisappear(): void {
    lottie.destroy();
  }

  private initLottie() {
    context.resourceManager.getRawFileContent('loading.json', async (err: Error, data: Uint8Array) => {
      if (data === null || data === undefined || data.buffer === undefined) {
        Logger.error(TAG, 'Failed to load loading.json');
        return;
      }
      let lottieStr = await this.resStr.decodeWithStream(new Uint8Array(data.buffer));
      jsonData = JSON.parse(lottieStr);
      this.hasLoadData = true;
    });
  }

  async getSearchBankList(): Promise<void> {
    if (!this.searchText.trim()) {
      Logger.info(TAG, 'Search text is empty');
      this.isHotSearchVisible = true;
      return;
    }
    this.isHotSearchVisible = false;
  }

  async loadResources(): Promise<void> {
    this.loadingStatus = LoadingStatus.LOADING;
    try {
      let list = await this.bankModel.getHotSearchList();
      if (list.length > 0) {
        this.hotSearchItems = list;
        this.loadingStatus = LoadingStatus.SUCCESS;
      } else {
        this.loadingStatus = LoadingStatus.FAILED;
      }
    } catch (e) {
      Logger.error(TAG, `Error loading hot search list: ${e}`);
      this.loadingStatus = LoadingStatus.FAILED;
    }
  }

  @Builder
  tabBuilder(tabName: string, index: number) {
    Row() {
      Text(tabName)
        .fontSize(16)
        .fontColor(this.selectedTabIndex === index ? '#F75A23' : '#9D9D9D')
        .decoration({ type: TextDecorationType.None })
        .border({
          width: this.selectedTabIndex === index ? { bottom: 3 } : 0,
          color: this.selectedTabIndex === index ? '#F75A23' : Color.Transparent,
          style: BorderStyle.Solid,
        })
        .padding({ bottom: 4 })
        .id(index.toString())
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: 12, right: 12 })
    .height('auto')
    .onClick(() => {
      this.selectedTabIndex = index;
      this.tabsController.changeIndex(index);
    });
  }

  build() {
    Column() {
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24)
          .height(24)
          .fillColor('#666666')
          .margin({ right: 8 })
          .onClick(() => {
            router.back();
          })
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.search'))
            .objectFit(ImageFit.Contain)
            .width(310)
            .height(36)

          Row() {
            Image($r('app.media.ic_search'))
              .objectFit(ImageFit.Cover)
              .width(24)
              .height(24)
              .margin({ left: 10 })
            TextInput({ placeholder: '请输入题库名称或关键词', controller: this.controller })
              .width('65%')
              .height(36)
              .fontSize(14)
              .fontColor(0xFF9D9D9D)
              .backgroundColor('transparent')
              .onChange((value: string) => {
                this.searchText = value;
                if (value.trim()) {
                  this.getSearchBankList();
                } else {
                  this.isHotSearchVisible = true;
                }
              })
            Image($r('app.media.ic_del'))
              .width(24)
              .height(24)
              .visibility(this.searchText.length > 0 ? Visibility.Visible : Visibility.Hidden)
              .onClick(() => {
                this.controller.deleteText();
                this.searchText = '';
                this.isHotSearchVisible = true;
                this.selectedTabIndex = 0;
              })
          }
        }
      }
      .height(76)

      if (this.hasLoadData && this.loadingStatus === LoadingStatus.LOADING) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Canvas(this.controllerCanvas)
            .width('30%')
            .height('20%')
            .onReady(() => {
              this.animateItem = lottie.loadAnimation({
                container: this.controllerCanvas,
                renderer: 'canvas',
                loop: true,
                autoplay: true,
                context: context,
                name: this.animateName,
                animationData: jsonData,
              });
            });
        }
        .height('100%')
      } else if (this.loadingStatus === LoadingStatus.SUCCESS) {
        if (this.isHotSearchVisible) {
          Row() {
            Image($r('app.media.ic_fire'))
              .width(20)
              .height(20)
              .margin({ right: 8 })

            Image($r('app.media.ic_hotsearch'))
              .width(80)
          }
          .width('90%')
          .height('auto')
          .padding({ left: 16, top: 16, bottom: 10 })

          List({ scroller: this.listScroller }) {
            ForEach(this.hotSearchItems, (item: string, index: number) => {
              ListItem() {
                Row() {
                  Text(`${index + 1}`)
                    .fontSize(16)
                    .fontColor(index < 3 ? '#F75A23' : '#9D9D9D')
                    .fontStyle(FontStyle.Italic)
                    .width(30)
                    .textAlign(TextAlign.Start)

                  Text(item)
                    .fontSize(16)
                    .fontColor(index < 3 ? '#3E3E3E' : '#9D9D9D')
                    .textAlign(TextAlign.Start)
                }
                .width('100%')
                .padding({ left: 38, right: 16, top: 15 })
                .onClick(() => {
                  Logger.info(TAG, `Clicked on: ${item}`);
                  this.searchText = item;
                  this.controller.addText(item);
                });
              }
            }, (item: string, index: number) => index.toString())
          }
          .width('100%')
          .height('auto')
        } else {
          Column() {
            Row() {
              List({ initialIndex: 0, scroller: this.listScroller, space: 8 }) {
                this.tabBuilder('题库', 0);
                this.tabBuilder('题目', 1);
              }
              .listDirection(Axis.Horizontal)
              .height(30)
              .scrollBar(BarState.Off)
              .width('100%')
              .friction(0.6)
            }

            Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
              TabContent() {
                BankList({ fromType: 1, searchText: this.searchText });
              }
              .backgroundColor(Color.White)
              .margin({ bottom: 30 })

              TabContent() {
                QuestionList({ searchText: this.searchText })
              }
            }
            .barHeight(0)
            .animationDuration(300)
            .onChange((index: number) => {
              this.selectedTabIndex = index;
              this.listScroller.scrollToIndex(index, true, ScrollAlign.START);
            })
          }
        }
      } else if (this.loadingStatus === LoadingStatus.FAILED) {
        Text('数据请求失败')
          .fontSize(18)
          .fontColor('#9D9D9D')
          .margin({ top: 20 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
  }
}