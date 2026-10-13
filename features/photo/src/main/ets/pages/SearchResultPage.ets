import { CommonConstants, Logger } from 'utils/Index'
import { TitleBar } from 'widget/Index'
import { SearchModel } from '../model/SearchModel'
import { SearchResultRes } from '../model/SearchResultRes'
import { router } from '@kit.ArkUI'


@Entry({ routeName: 'searchResultPage' })
@Component
export struct SearchResultPage {
  build() {
    Flex({ direction: FlexDirection.Column }) {
      TitleBar({
        title: '搜索结果', backClick: () => {
          router.back()
        }
      })
      ListView()
      BottomBar({
        searchClick: () => {
          router.back()
        }
      })
    }
  }
}

@Component
struct ListView {
  @State resultData: SearchResultRes[] = []
  ocrTxt = '驾驶人'

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params) {
      let ocrTxtParam = params.ocrTxt as string
      this.ocrTxt = ocrTxtParam.replaceAll("\n", "")
    }

    SearchModel.getInstance().searchResultList(this.ocrTxt).then(async (value: SearchResultRes[]) => {

      for (let i = 0; i < value.length; i++) {
        let res = value[i]

        let searchResultRes = new SearchResultRes()
        searchResultRes.q = res.q
        searchResultRes.ans = res.ans
        searchResultRes.Name = res.Name
        for (let index = 0; index < res.ASlice.length; index++) {
          let prefix = String.fromCharCode('A'.charCodeAt(0) + index)
          searchResultRes.ASlice.push(prefix + "、" + res.ASlice[index])
          if (res.ans.includes(prefix)) {
            if (index != -1) {
              searchResultRes.answerAry.push(index)
            }
          }
        }
        this.resultData.push(searchResultRes)
      }
    })
  }

  build() {
    if (this.resultData.length > 0) {
      List() {
        // ListItem() {
        //   //TODO 显示ocr识别后的文本，上线后需删除
        //   Text(this.ocrTxt)
        //     .fontSize(14)
        //     .align(Alignment.Start)
        //     .fontColor($r('app.color.c_ff0000'))
        // }

        ForEach(this.resultData,
          (item: SearchResultRes) => {
            ListItem() {
              Column() {
                Text("答案：" + item.ans)
                  .fontSize(16)
                  .fontColor($r('app.color.c_f75a23'))
                  .margin({ bottom: 15 })
                  .align(Alignment.Start)
                Text(item.q)
                  .fontSize(16)
                  .align(Alignment.Start)

                ForEach(item.ASlice, (optionTxt: string, index: number) => {
                  if (item.answerAry.includes(index)) {
                    Text(optionTxt).fontSize(16).fontColor($r('app.color.c_f75a23')).margin({ top: 10 })
                  } else {
                    Text(optionTxt).fontSize(16).fontColor($r('app.color.c_3f3f3f')).margin({ top: 10 })
                  }
                })
                Flex({
                  direction: FlexDirection.Row,
                  justifyContent: FlexAlign.SpaceBetween,
                  alignItems: ItemAlign.Center,
                  wrap: FlexWrap.Wrap
                }) {
                  // Row() {
                  Text(item.Name)
                    .fontSize(14)
                    .fontColor($r('app.color.c_3e3e3e'))
                    .margin({ top: 30 })
                    .align(Alignment.Start)
                    .width('100%')
                  // Text("（下载状态）")
                  //   .fontSize(14)
                  //   .fontColor($r('app.color.c_9d9d9d'))
                  //   .margin({ top: 30 })
                  //   .align(Alignment.Start)
                  // }

                  // Text("去下载")
                  //   .fontSize(14)
                  //   .fontColor($r('app.color.c_1f59a8'))
                  //   .margin({ top: 30 })
                  //   .align(Alignment.End)
                }
              }
              .padding(15)
              .alignItems(HorizontalAlign.Start)
            }
            .width('92%')
            .shadow({
              radius: 15,
              color: $r('app.color.c_d3d3d3'),
            })
            .borderRadius(10)
            .margin({ left: 15, top: 15 })
            .align(Alignment.Start)
          }
        )
      }
      .cachedCount(5)
    } else {
      Text($r('app.string.search_nodata'))
        .fontSize(16)
        .align(Alignment.Start)
        .fontColor($r('app.color.c_f75a23'))
    }
  }
}

@Component
struct BottomBar {
  searchClick: () => void = () => {
  }

  build() {
    Stack() {
      Text($r('app.string.search_again'))
        .fontSize($r('app.float.font_size_18fp'))
        .fontColor($r('app.color.start_window_background'))
        .borderRadius(50)
        .textAlign(TextAlign.Center)
        .align(Alignment.Center)
        .width(CommonConstants.EIGHTY_PERCENT)
        .height($r('app.float.float_48vp'))
        .margin({ left: '10%', right: '10%' })
        .backgroundColor($r('app.color.c_f75a23'))
        .onClick(() => this.searchClick())
    }
    .padding({ top: $r('app.float.float_20vp') })
    .align(Alignment.BottomStart)
    .alignContent(Alignment.Center)
  }
}