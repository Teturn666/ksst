///题库列表
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
  controller: CustomDialogController
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

@CustomDialog
struct DeleteDialog {
  confirm?: (item: BankListRes) => void
  controller: CustomDialogController;
  bank: BankListRes = {} as BankListRes;

  constructor(controller: CustomDialogController, bank: BankListRes) {
    super();
    this.controller = controller;
    this.bank = bank;
  }

  build() {
    Column() {
      Blank()
      Text("提示").fontSize(18)
        .fontColor($r("app.color.c_9d9d9d"))
        .textAlign(TextAlign.Center).margin({ top: 20 })
      Text('确定删除 “' + this.bank?.name + '” 这个题库吗？').fontSize(18)
        .fontColor($r("app.color.c_9d9d9d"))
        .textAlign(TextAlign.Start).margin({ top: 20, left: 20, right: 20 })
      Row() {
        Text("确定")
          .width(80)
          .height(30)
          .borderRadius(5)
          .fontColor($r('app.color.c_2a5089'))
          .backgroundColor($r('app.color.c_f4f3fb'))
          .onClick(() => {
            //删除确定
            if (this.confirm) {
              this.confirm(this.bank)
            }
            this.controller.close()
          })
          .textAlign(TextAlign.Center)
          .margin({ top: 25, bottom: 15 })
        Text("取消")
          .width(80)
          .height(30)
          .borderRadius(5)
          .fontColor($r('app.color.c_f75a23'))
          .backgroundColor($r('app.color.c_fce8e8'))
          .onClick(() => {
            //删除取消
            this.controller.close()
          })
          .textAlign(TextAlign.Center)
          .margin({ top: 25, bottom: 15 })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')

      Blank()
    }.width('100%').backgroundColor($r('app.color.start_window_background')).borderRadius(10)
  }
}


@Component
export struct BankList {
  @State bankRes: BankRes = new BankRes();
  @State bankModel: BankModel = BankModel.getInstance()
  aid: string = "" //目前题库广场需要传这个参数
  @State searchText: string = ""
  @State fromType: number = 0 //0=题库广场，1=热门搜索，2=我的下载
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
    this.bankRes.newsData = []
    this.loadFeedData()
    this.initLottie()
    this.initDialog()
  }

  //删除弹窗
  showDeleteDialog() {
    this.dialogDeleteController = new CustomDialogController({
      builder: DeleteDialog({
        bank: this.mCurBank, confirm: (item) => {
          //删除确定
          //更新状态为未下载
          item.downloadedState = 2
          //触发UI重新渲染
          this.bankRes.newsData = [...this.bankRes.newsData]
          this.dialogDeleteController?.close()
          this.bankModel.deleteTable(item.qid)
        }
      })
    });
    this.dialogDeleteController.open();
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
    if (this.bankRes.newsData.length > 0) {
      List() {
        ForEach(this.bankRes.newsData, (item: BankListRes, index) => {
          ListItem() {
            Column() {
              Flex({
                direction: FlexDirection.Row,
                justifyContent: FlexAlign.SpaceAround,
                alignItems: ItemAlign.Center
              }) {
                Column() {
                  Row() {
                    // Image($r('app.media.ic_feed'))
                    //   .objectFit(ImageFit.Contain)
                    //   .size({ width: $r('app.float.float_16vp'), height: $r('app.float.float_16vp') })
                    Text(item.name)
                      .fontColor($r('app.color.c_3e3e3e'))
                      .fontSize($r('app.float.font_size_16fp'))
                      .fontWeight(FontWeight.Bold)
                    // .margin({
                    //   left: $r('app.float.float_5vp'),
                    // })
                  }

                  Text(item.desc)
                    .fontColor($r('app.color.c_3e3e3e'))
                    .fontSize($r('app.float.font_size_12fp'))
                    .margin({ top: $r('app.float.float_10vp'), bottom: $r('app.float.float_10vp') })

                  Row() {
                    Text("题库状态：")
                      .fontColor($r('app.color.c_9d9d9d'))
                      .fontSize($r('app.float.font_size_10fp'))
                    if (item.downloadedState === 1) {
                      Text("已下载")
                        .fontColor(Color.Blue)
                        .fontSize($r('app.float.font_size_10fp'))
                        .margin({ right: $r('app.float.float_30vp') })
                    } else {
                      Text("未下载")
                        .fontColor(Color.Blue)
                        .fontSize($r('app.float.font_size_10fp'))
                        .margin({ right: $r('app.float.float_30vp') })
                    }
                    Text("题库更新时间：" + item.time)
                      .fontColor($r('app.color.c_9d9d9d'))
                      .fontSize($r('app.float.font_size_10fp'))
                  }
                }
                .width('85%')
                .alignItems(HorizontalAlign.Start)
                .margin({
                  left: $r('app.float.float_20vp'),
                  top: $r('app.float.float_20vp'),
                  right: $r('app.float.float_20vp'),
                })

                Column() {
                  if (item.downloadedState === 1) {
                    Image($r('app.media.ic_remove'))
                      .objectFit(ImageFit.Contain)
                      .size({ width: $r('app.float.float_50vp'), height: $r('app.float.float_50vp') })
                    Text("删除")
                      .fontColor(Color.Black)
                      .fontSize($r('app.float.font_size_10fp'))
                  } else {
                    Image($r('app.media.ic_download'))
                      .objectFit(ImageFit.Contain)
                      .size({ width: $r('app.float.float_50vp'), height: $r('app.float.float_50vp') })
                    Text("下载")
                      .fontColor(Color.Black)
                      .fontSize($r('app.float.font_size_10fp'))
                  }
                }
                .margin({
                  right: $r('app.float.float_20vp'),
                })
                .onClick(
                  async () => {
                    this.mCurBank = item
                    if (item.downloadedState === 1) {
                      this.showDeleteDialog()
                    } else {
                      Logger.info(TAG, '题库内容--------' + item)
                      LoadingDialog.openDialog()
                      try {
                        const success = await this.bankModel.downLoadBank(item);
                        if (success) {
                          Logger.info(TAG, '下载成功' + item)
                          //更新状态为已下载
                          item.downloadedState = 1
                          //触发UI重新渲染
                          this.bankRes.newsData = [...this.bankRes.newsData]
                          LoadingDialog.closeDialog()
                          this.showDownloadOverDialog(true)
                          onEventObject(BankMobClickConstants.QUESTION_BANK_CLICK_DOWNLOAD_SUCCESS, {
                            "question_bank_id": item.qid
                          })
                        } else {
                          Logger.info(TAG, '下载失败' + item)
                          LoadingDialog.closeDialog()
                          this.showDownloadOverDialog(false)
                          onEventObject(BankMobClickConstants.QUESTION_BANK_CLICK_DOWNLOAD_FAIL, {
                            "question_bank_id": item.qid
                          })
                        }
                      } catch (error) {
                        Logger.info(TAG, '下载过程中发生错误' + item)
                        LoadingDialog.closeDialog()
                        this.showDownloadOverDialog(false)
                        onEventObject(BankMobClickConstants.QUESTION_BANK_CLICK_DOWNLOAD_FAIL, {
                          "question_bank_id": item.qid
                        })
                      }
                    }
                  }
                )
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
    } else {
      Column() {
        Image($r('app.media.hotsearch'))
          .objectFit(ImageFit.Contain)
          .size({ width: 117, height: 100 })

        Text(this.fromType === 1 ? '暂无搜索结果\n换个关键词试试吧' : '暂无下载题库，您可以去题库广场下载')
          .fontColor('#9D9D9D')
          .fontSize(14)
          .margin({ top: 28 })
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('auto')
    }
  }

  async loadFeedData(): Promise<void> {
    switch (this.fromType) {
      case 1:
        let hotList = await this.bankModel.getSearchBankList(this.searchText, this.pageNum)
        if (hotList === null || hotList.length < 10) {
          this.loadMore = false
        } else {
          this.pageNum++
          this.loadMore = true
        }
        this.bankRes.newsData = this.bankRes.newsData.concat(hotList)
        break
      case 2:
        let downloadList = await this.bankModel.getDownloadBankList()
        this.bankRes.newsData = downloadList
        break
      default:
        let list = await this.bankModel.getBankList(this.aid.toString(), this.pageNum)
        if (list === null || list.length < 10) {
          this.loadMore = false
        } else {
          this.pageNum++
          this.loadMore = true
        }
        this.bankRes.newsData = this.bankRes.newsData.concat(list)
        break
    }


    // if (this.fromType === 1) {
    //   let list = await this.bankModel.getSearchBankList(this.searchText, this.pageNum)
    //   if (list === null || list.length < 10) {
    //     this.loadMore = false
    //   } else {
    //     this.pageNum++
    //     this.loadMore = true
    //   }
    //   this.bankRes.newsData = this.bankRes.newsData.concat(list)
    // } else {
    //   let list = await this.bankModel.getBankList(this.aid.toString(), this.pageNum)
    //   if (list === null || list.length < 10) {
    //     this.loadMore = false
    //   } else {
    //     this.pageNum++
    //     this.loadMore = true
    //   }
    //   this.bankRes.newsData = this.bankRes.newsData.concat(list)
    // }
  }
}