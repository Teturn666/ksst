import { AppConstants } from '../constants/AppConstants';
import { TabBarData, TabBarType, TabsInfo } from '../model/TabBarModel'

@Component
export struct CustomTabBar {
  @Link currentIndex: TabBarType;
  @StorageProp('naviIndicatorHeight') naviIndicatorHeight: number = 0;

  onChange(index: TabBarType): void {
    this.currentIndex = index;
    // if (this.currentIndex === TabBarType.MINE) {
    //   WindowUtil.updateStatusBarColor(getContext(this), true);
    // } else {
    //   WindowUtil.updateStatusBarColor(getContext(this), false);
    // }
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceAround
    }) {
      ForEach(TabsInfo, (item: TabBarData) => {
        TabItem({
          index: item.id,
          selectedIndex: this.currentIndex,
          onChange: (index: number) => this.onChange(index)
        })
      }, (item: TabBarData) => item.id.toString())
    }
    .clip(false)
    .height(AppConstants.TAB_HEIGHT)
    .width(AppConstants.FULL_PERCENT)
  }
}

@Component
struct TabItem {
  @Prop index: number
  @Prop selectedIndex: number;
  onChange: (index: number) => void = () => {
  };

  build() {
    Column() {
      Image(this.selectedIndex === this.index ? TabsInfo[this.index].activeIcon : TabsInfo[this.index].defaultIcon)
        .size({ width: $r("app.float.float_32vp"), height: $r("app.float.float_32vp") })
      Text(TabsInfo[this.index].title)
        .fontSize($r('app.float.float_14fp'))
        .margin({ top: $r('app.float.float_5vp') })
        .fontWeight(AppConstants.TAB_FONT_WEIGHT)
        .fontColor(this.index === this.selectedIndex ?
        $r('app.color.color_theme') : $r('app.color.color_a6a6a6'))
    }
    .clip(false)
    .size({ height: AppConstants.FULL_PERCENT })
    .justifyContent(FlexAlign.Center)
    .onClick(() => this.onChange(this.index))
  }
}