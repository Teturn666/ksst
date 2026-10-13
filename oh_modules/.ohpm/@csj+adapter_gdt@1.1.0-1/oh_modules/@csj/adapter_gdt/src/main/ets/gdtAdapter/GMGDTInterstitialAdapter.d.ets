// @keepTs
// @ts-nocheck
import { AdSlot, CustomInteractionListener, CustomPackAd, CustomLoadAdapter, CustomLoadListener, CustomVideoListener } from "@csj/openadsdk/Index";
import { window } from "@kit.ArkUI";
export declare class GMGDTInterstitialAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(s: string, t: CustomLoadListener, u: AdSlot, v?: Map<string, object>): void;
}
export declare class PackGDTInterstitialAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private mCustomVideoListener?;
    private gdtVideoStateListener;
    private gdtInteractionListener;
    constructor(d123: ESObject);
    setCustomInteractionListener(o: CustomInteractionListener): void;
    setCustomVideoListener(n: CustomVideoListener): void;
    showAd(l: window.WindowStage, m?: Map<string, object>): void;
}
