// @keepTs
// @ts-nocheck
import { window } from '@kit.ArkUI';
import { AdSlot, CustomInteractionListener, CustomPackAd, CustomLoadAdapter, CustomLoadListener } from "@csj/openadsdk/Index";
import { KSFullScreenAdInteractListener_copy } from './GMKsAdapterBase';
export interface KSRewardAdInteractListener_copy extends KSFullScreenAdInteractListener_copy {
    onRewardVerify?: () => void;
}
export declare class GMKsRewardedVideoAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(z10: string, a11: CustomLoadListener, b11: AdSlot, c11?: Map<string, object>): void;
}
export declare class PackKSRewardAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private ksInteractionListener;
    constructor(n135: ESObject);
    setCustomInteractionListener(u10: CustomInteractionListener): void;
    showAd(s10: window.WindowStage, t10?: Map<string, object>): void;
}
