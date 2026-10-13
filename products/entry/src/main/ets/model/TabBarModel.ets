export interface TabBarData {
  id: TabBarType;
  title: ResourceStr;
  activeIcon: ResourceStr;
  defaultIcon: ResourceStr;
}

export enum TabBarType {
  HOME = 0,
  BANK,
  MINE
}

export const TabsInfo: TabBarData[] = [
  {
    id: TabBarType.HOME,
    title: $r('app.string.tab_home'),
    activeIcon: $r('app.media.ic_home_select'),
    defaultIcon: $r("app.media.ic_home")
  },
  {
    id: TabBarType.BANK,
    title: $r('app.string.tab_bank'),
    activeIcon: $r('app.media.ic_bank_select'),
    defaultIcon: $r('app.media.ic_bank')
  },
  {
    id: TabBarType.MINE,
    title: $r('app.string.tab_mine'),
    activeIcon: $r('app.media.ic_mine_select'),
    defaultIcon: $r('app.media.ic_mine')
  },
]