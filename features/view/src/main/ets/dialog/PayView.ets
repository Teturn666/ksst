@Component
export struct PayView {
  build() {
    Column() {
      TabView()
      ListView()
      BtPayView()
      PayTxtView()
    }
  }
}

@Component
struct TabView {
  build() {
    Row() {
      Text($r('app.string.card_pay'))
        .fontSize($r('app.float.font_size_20fp'))
        .fontColor($r('app.color.c_a6a6a6'))
      Text()
        .width(1)
        .height(16)
        .backgroundColor($r('app.color.c_bdbdbd'))
      Text($r('app.string.infinite_pay'))
        .fontSize($r('app.float.font_size_20fp'))
        .fontColor($r('app.color.c_a6a6a6'))
    }
    .width('100%')
    .padding({ top: 15, bottom: 15 })
    .justifyContent(FlexAlign.SpaceAround)
  }
}

@Component
struct ListView {
  @Prop txt: string = ""
  testAry: number[] = [0, 1, 2]

  build() {
    Column() {
      Text($r('app.string.card_pay_rule'))
        .fontSize($r('app.float.font_size_16fp'))
        .fontColor($r('app.color.c_d21a1a'))
        .padding({ bottom: $r('app.float.float_15vp') })
      List({ space: 5 }) {
        ForEach(this.testAry, (item: number) => {
          ListItem() {
            Stack({ alignContent: Alignment.TopStart }) {
              Image($r('app.media.img_bg_member_recomend'))
                .objectFit(ImageFit.Contain)
                .size({ width: $r('app.float.float_40vp'), height: $r('app.float.float_40vp') })
              Column() {
                Text('标题')
                  .fontSize($r('app.float.font_size_42fp'))
                  .fontColor($r('app.color.start_window_background'))
                  .margin({ top: $r('app.float.float_10vp') })
                Text('内容')
                  .fontSize($r('app.float.font_size_26fp'))
                  .margin({ top: $r('app.float.float_10vp') })
                  .fontColor($r('app.color.start_window_background'))
              }
              .backgroundImage($r('app.media.img_bg_member_type_unselect'))
              .height($r('app.float.float_138vp'))
              .width($r('app.float.float_106vp'))
              .borderRadius($r('app.float.float_10vp'))
              .margin({ top: $r('app.float.float_20vp') })
            }
          }
        })
      }
      .listDirection(Axis.Horizontal)
      .height(200)
    }
  }
}

@Component
struct BtPayView {
  build() {
    Text($r('app.string.login_pay'))
      .fontSize($r('app.float.font_size_20fp'))
      .fontColor($r('app.color.start_window_background'))
      .width('85%')
      .height(64)
      .textAlign(TextAlign.Center)
      .backgroundColor($r('app.color.c_1f59a8'))
      .borderRadius($r('app.float.float_10vp'))
  }
}

@Component
struct PayTxtView {
  build() {
    Row() {
      Image($r('app.media.ic_warming'))
        .objectFit(ImageFit.Contain)
        .size({
          width: 16,
          height: 16,
        })
      Text($r('app.string.txt_pay'))
        .fontSize($r('app.float.font_size_12fp'))
        .fontColor($r('app.color.c_177DF9'))
    }
    .padding({ top: 18, bottom: 20 })
  }
}