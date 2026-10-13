// @keepTs
// @ts-nocheck
import { window } from '@kit.ArkUI';
import { AdSlot, CustomLoadAdapter, CustomLoadListener, CustomInteractionListener, CustomPackAd } from "@csj/openadsdk/Index";
export declare class GMGDTSplashAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(h2: string, i2: CustomLoadListener, j2: AdSlot, k2?: Map<string, object>): void;
}
export declare class PackGTDSplashAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private window;
    constructor(g2: ESObject);
    setCustomInteractionListener(f2: CustomInteractionListener): void;
    private gdtInteractionListener;
    showAd(a2: window.WindowStage, b2?: Map<string, object>): void;
}
