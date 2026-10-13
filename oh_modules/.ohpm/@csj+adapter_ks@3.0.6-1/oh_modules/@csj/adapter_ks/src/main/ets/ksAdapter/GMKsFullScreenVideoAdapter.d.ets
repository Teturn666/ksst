// @keepTs
// @ts-nocheck
import window from '@ohos.window';
import { AdSlot, CustomLoadAdapter, CustomLoadListener, CustomInteractionListener, CustomPackAd } from "@csj/openadsdk/Index";
export declare class GMKsFullScreenVideoAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(a3: string, b3: CustomLoadListener, c3: AdSlot, d3?: Map<string, object>): void;
}
export declare class PackKSFullAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    constructor(z2: ESObject);
    setCustomInteractionListener(y2: CustomInteractionListener): void;
    showAd(w2: window.WindowStage, x2?: Map<string, object>): void;
    private mInteractionListener;
}
