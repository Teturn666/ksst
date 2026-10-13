// @keepTs
// @ts-nocheck
import { CustomAdnInfo, CustomConfigAdapter } from "@csj/openadsdk/Index";
export declare class GMGDTConfigAdapter extends CustomConfigAdapter {
    private TAG;
    private gdtNs;
    initializeAdapter(b: CustomAdnInfo, c: Context): void;
    adapterVersion(): string;
    networkSdkVersion(): string;
}
