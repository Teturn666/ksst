// @keepTs
// @ts-nocheck
import { CustomConfigAdapter, CustomAdnInfo } from "@csj/openadsdk/Index";
export interface KSAdSDKInitConfig_copy {
    appId: string;
    appName?: string;
    appTag?: string;
    enableProgrammaticRecommend?: boolean;
    enablePersonalRecommend?: boolean;
}
export declare class GMKsConfigAdapter extends CustomConfigAdapter {
    private TAG;
    private ksNs;
    initializeAdapter(b: CustomAdnInfo, c: Context): void;
    adapterVersion(): string;
    networkSdkVersion(): string;
}
