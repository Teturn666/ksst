// @keepTs
// @ts-nocheck
import { window } from '@kit.ArkUI';
import { AdSlot, CustomInteractionListener, CustomPackAd, CustomLoadAdapter, CustomLoadListener } from "@csj/openadsdk/Index";
import { KSBaseAd_copy } from './GMKsAdapterBase';
export declare class GMKsInterstitialAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(x4: string, y4: CustomLoadListener, z4: AdSlot, a5?: Map<string, object>): void;
}
export declare class PackKSInterstitialAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private window;
    private hasClicked;
    private mInteractionListener;
    constructor(m135: ESObject);
    setCustomInteractionListener(s4: CustomInteractionListener): void;
    showAd(n4: window.WindowStage, o4?: Map<string, object>): void;
}
export interface KSInterstitialAdInteractListener_copy {
    onAdShow?: () => void;
    onAdClick?: () => void;
    onAdClose?: () => void;
    onAdSkip?: (playedDuration: number) => void;
    onVideoPlayStart: () => void;
    onVideoPlayEnd: () => void;
    onVideoPlayError?: (code: number, extra: string) => void;
}
export interface KSInterstitialAd_copy extends KSBaseAd_copy {
    interactListener?: KSInterstitialAdInteractListener_copy;
    setInteractListener(listener: KSInterstitialAdInteractListener_copy): void;
}
@Entry({
    routeName: "KsInterstitialPage",
    storage: LocalStorage.getShared()
})
@Component
export declare struct KsInterstitialPage {
    @LocalStorageLink('ksAd')
    _ad: KSInterstitialAd_copy | undefined;
    @LocalStorageLink('ksInterWindow')
    _window: window.Window | undefined;
    private hasClicked;
    @BuilderParam
    sdkBuilder: (ns: ESObject) => void;
    aboutToAppear(): void;
    onPageShow(): void;
    onPageHide(): void;
    build(): void;
}
