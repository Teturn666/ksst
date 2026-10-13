///题目列表
import { BankModel } from '../model/BankModel'
import BankRes from '../model/BankRes'
import { Logger } from 'utils';
import { BankListRes } from 'db'
import { ComponentContent } from '@kit.ArkUI';
import { LoadingDialog } from './LoadingDialog';
import { FinishDialog } from './FinishDialog';
import lottie, { AnimationItem } from '@ohos/lottie';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS'
import { onEventObject } from '@umeng/analytics';
import BankMobClickConstants from '../Constants/BankMobClickConstants';
import { SearchQuestionRes } from '../model/SearchQuestionRes';

const TAG = '[BankList]'
let jsonData = null

const context = (getContext(this) as common.UIAbilityContext)

class Params {
  controller: CanvasRenderingContext2D
  animateName: string

  constructor(controller: CanvasRenderingContext2D, animateName: string) {
    this.controller = controller;
    this.animateName = animateName;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Blank()
    Column() {
      Row() {
        Image($r('app.media.loading_default')).width('90%').margin({ top: 15 })
      }

      Text("题库下载中").fontSize(12)
        .fontColor($r("app.color.c_9d9d9d"))
        .textAlign(TextAlign.Center).margin({ top: 18 })

      Canvas(params.controller)
        .width('30%')
        .height('20%')
        .onReady(() => {
          lottie.loadAnimation({
            container: params.controller,
            renderer: 'canvas',
            loop: true,
            autoplay: true,
            context: context,
            name: params.animateName,
            animationData: jsonData,
          })
        })// .width('90%')
        .height(30)
        .margin({ bottom: 16, top: 8 })
    }.width('90%').backgroundColor($r('app.color.start_window_background')).borderRadius(10)

    Blank()
  }.width('100%').height('100%').alignItems(HorizontalAlign.Center)
}

@CustomDialog
struct DownloadOverDialog {
  success: boolean = false
  controller: CustomDialogController;
  bank: BankListRes = {} as BankListRes

  constructor(controller: CustomDialogController, bank: BankListRes) {
    super();
    this.controller = controller;
    this.bank = bank;
  }

  build() {
    Column() {
      Blank()
      Text(this.success ? `导入成功：导入数据${this.bank.num}条` : "导入失败：文件不存在或者内容格式异常").fontSize(18)
        .fontColor($r("app.color.c_9d9d9d"))
        .textAlign(TextAlign.Center).margin({ top: 20 })
      Text("确定")
        .width(80)
        .height(30)
        .borderRadius(5)
        .backgroundColor($r('app.color.c_fce8e8'))
        .onClick(() => {
          this.controller.close()
        })
        .textAlign(TextAlign.Center)
        .margin({ top: 25, bottom: 15 })
      Blank()
    }.width('100%').backgroundColor($r('app.color.start_window_background')).borderRadius(10)
  }
}

@Builder
function buildFinishText() {

}


@Component
export struct QuestionList {
  @State bankRes: BankRes = new BankRes();
  @State bankModel: BankModel = BankModel.getInstance()
  @State searchText: string = ""
  @State pageNum: number = 1
  @State loadMore: boolean = false
  private ctx: UIContext = this.getUIContext();
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private controller: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings)
  private animateName = "loading"
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildText), new Params(this.controller, this.animateName));
  private contentNode1: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildFinishText));
  private resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true })
  @State hasLoadData: boolean = false
  @State mCurBank: BankListRes = {} as BankListRes
  dialogDeleteController?: CustomDialogController
  dialogDownloadController?: CustomDialogController

  aboutToAppear(): void {

    this.loadFeedData()
    this.initLottie()
    this.initDialog()
  }

  showDownloadOverDialog(success: boolean) {
    this.dialogDownloadController = new CustomDialogController({
      builder: DownloadOverDialog({
        bank: this.mCurBank, success: success
      })
    });
    this.dialogDownloadController.open();
  }

  private initDialog() {
    LoadingDialog.setContext(this.ctx);
    LoadingDialog.setContentNode(this.contentNode);
    LoadingDialog.setOptions({
      alignment: DialogAlignment.Center, onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
        if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
          // dismissDialogAction.dismiss()
        }
        if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
          // dismissDialogAction.dismiss()
        }
      }
    });

    FinishDialog.setContext(this.ctx);
    FinishDialog.setContentNode(this.contentNode1);
    FinishDialog.setOptions({
      alignment: DialogAlignment.Center
    });
  }

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

  build() {
    List() {
      ForEach(this.bankRes.QuestionData, (item: SearchQuestionRes, index) => {
        ListItem() {
          Column() {
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.SpaceAround,
              alignItems: ItemAlign.Center
            }) {
              Column() {
                Text() {
                  Span(item.ans.length > 1 ? '【多选题】' : '【单选题】')
                    .fontSize(14)
                    .fontColor('#3E3E3E')
                    .fontWeight(FontWeight.Bold)

                  Span(item.q)
                    .fontSize(14)
                    .fontColor('#3E3E3E')
                }
                .textAlign(TextAlign.Start)
                .margin({ top: 8, left: 8, right: 8 })

                Row() {
                  Text() {
                    Span("所在题库:" + item.Name)
                      .fontSize(12)
                      .fontColor(Color.Red)
                    Span(item.downloadedState === 1 ? "    (已下载)" : "    (未下载)")
                      .fontColor(Color.Grey)
                      .fontSize($r('app.float.font_size_12fp'))
                      .margin({ left: 18 })

                  }
                  .width('85%')
                  .textAlign(TextAlign.Start)
                  .margin({ right: 18 })

                  Text("点我下载")
                    .visibility(item.downloadedState === 1 ? Visibility.Hidden : Visibility.Visible)
                    .fontSize(12)
                    .fontColor(Color.Blue)
                    .fontSize($r('app.float.font_size_12fp'))
                    .textAlign(TextAlign.Center)
                    .decoration({ type: TextDecorationType.Underline, color: Color.Blue })
                    .onClick(
                      async () => {
                        let bankRes = await this.bankModel.getBankDetail(item.qid)
                        LoadingDialog.openDialog()
                        if (bankRes != null) {
                          try {
                            const success = await this.bankModel.downLoadBank(bankRes)
                            if (success) {
                              //更新状态为已下载
                              item.downloadedState = 1
                              //触发UI重新渲染
                              this.bankRes.newsData = [...this.bankRes.newsData]
                              LoadingDialog.closeDialog()
                              this.showDownloadOverDialog(true)
                              onEventObject(BankMobClickConstants.QUESTION_BANK_CLICK_DOWNLOAD_SUCCESS, {
                                "question_bank_id": item.qid
                              })
                            }
                          } catch (error) {
                            Logger.info(TAG, '下载过程中发生错误' + item)
                            LoadingDialog.closeDialog()
                            this.showDownloadOverDialog(false)
                          }
                        } else {
                          Logger.info(TAG, '下载过程中发生错误' + item)
                          LoadingDialog.closeDialog()
                          this.showDownloadOverDialog(false)
                        }

                      }
                    )
                }
                .width('90%')
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({ top: 25, left: 8, right: 8 })

              }
              .width('85%')
              .alignItems(HorizontalAlign.Start)
              .margin({
                left: $r('app.float.float_20vp'),
                top: $r('app.float.float_20vp'),
                right: $r('app.float.float_20vp'),
              })
            }

            Divider()
              .strokeWidth(0.5)
              .color($r('app.color.c_ebebeb'))
              .margin({
                left: $r('app.float.float_20vp'),
                top: $r('app.float.float_10vp'),
                right: $r('app.float.float_20vp'),
              })
            if (index === this.bankRes.newsData.length - 1) {
              Text("没有更多数据了")
                .fontSize(14)
                .fontColor($r('app.color.c_9d9d9d'))
                .margin({ top: 15, bottom: 15 })
            }
          }
        }
      })
    }.onReachEnd(() => {
      if (this.loadMore) {
        this.loadFeedData()
      }
    })
  }

  async loadFeedData(): Promise<void> {
    let list = await this.bankModel.getSearchQuestionList(this.searchText, this.pageNum)
    if (list === null || list.length < 10) {
      this.loadMore = false
    } else {
      this.pageNum++
      this.loadMore = true
    }
    this.bankRes.QuestionData = this.bankRes.QuestionData.concat(list)
  }
}