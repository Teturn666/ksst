//顶部统一的标题栏
@Component
export struct TitleBar {
  @Prop title: string
  backClick: () => void = () => {
  };

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .objectFit(ImageFit.Contain)
        .size({ width: $r('app.float.float_48vp'), height: $r('app.float.float_48vp') })
        .margin({ left: 15, right: 15 })
        .align(Alignment.TopStart)
        .onClick(() => this.backClick())
      Text(this.title)
        .fontSize($r('app.float.font_size_18fp'))
        .fontColor($r('app.color.c_black'))
        .textAlign(TextAlign.Center)
        .width('60%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .margin({ top: 15 })

  }
}