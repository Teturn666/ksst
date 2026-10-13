// @keepTs
// @ts-nocheck
import { AdSlot, CustomInteractionListener, CustomPackAd, CustomLoadAdapter, CustomLoadListener, CustomVideoListener } from "@csj/openadsdk/Index";
import { window } from "@kit.ArkUI";
export declare class GMGDTRewardedVideoAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(n1: string, o1: CustomLoadListener, p1: AdSlot, q1?: Map<string, object>): void;
}
export declare class PackGDTRewardAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private mCustomVideoListener?;
    private gdtVideoStateListener;
    private gdtInteractionListener;
    constructor(c123: ESObject);
    setCustomInteractionListener(i1: CustomInteractionListener): void;
    setCustomVideoListener(h1: CustomVideoListener): void;
    showAd(f1: window.WindowStage, g1?: Map<string, object>): void;
}
