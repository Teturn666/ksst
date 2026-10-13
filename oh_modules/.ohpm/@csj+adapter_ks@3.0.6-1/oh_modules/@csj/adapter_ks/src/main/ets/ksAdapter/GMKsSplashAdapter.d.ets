// @keepTs
// @ts-nocheck
import { FrameNode, NodeController, window } from '@kit.ArkUI';
import { AdSlot, CustomLoadAdapter, CustomLoadListener, CustomInteractionListener, CustomPackAd } from "@csj/openadsdk/Index";
import { KSBaseAd_copy } from './GMKsAdapterBase';
export interface KSSplashAdInteractListener_copy {
    onAdShowStart?: () => void;
    onAdShowEnd?: () => void;
    onAdShowError?: (code: number, extra: string) => void;
    onAdClick?: () => void;
    onAdSkip?: () => void;
}
export declare class GMKsSplashAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(p14: string, q14: CustomLoadListener, r14: AdSlot, s14?: Map<string, object>): void;
}
export declare class PackKSSplashAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private window;
    constructor(o14: ESObject);
    setCustomInteractionListener(n14: CustomInteractionListener): void;
    showAd(f14: window.WindowStage, g14?: Map<string, object>): void;
    getSplashAdComponent(d14: boolean, window?: window.Window | undefined): NodeController;
    getAdComponent(): NodeController | undefined;
    private mKSInteractionListener;
}
export interface KSSplashAd_copy extends KSBaseAd_copy {
    interactListener?: KSSplashAdInteractListener_copy;
    setInteractListener(listener: KSSplashAdInteractListener_copy): void;
}
@Entry({
    routeName: "KsSplashPage",
    storage: LocalStorage.getShared()
})
@Component
export declare struct KsSplashPage {
    @LocalStorageLink('ksAd')
    _ad: KSSplashAd_copy | undefined;
    @LocalStorageLink('ksWindow')
    _window: window.Window | undefined;
    @LocalStorageLink('splashBottomBuilder')
    _splashBottomBuilder: WrappedBuilder<[
    ]> | undefined;
    @BuilderParam
    sdkBuilder: (ns: ESObject) => void;
    onPageShow(): void;
    onPageHide(): void;
    aboutToAppear(): void;
    build(): void;
}
export declare class AdViewNodeController extends NodeController {
    private adComponentNode;
    private param;
    private mFrameNode?;
    constructor(l12: ESObject);
    makeNode(k12: UIContext): FrameNode | null;
    release(): void;
}
@Component
export declare struct SplashAdComponent {
    ksAd: ESObject | undefined;
    @BuilderParam
    sdkBuilder: (ns: ESObject) => void;
    aboutToAppear(): void;
    build(): void;
}
