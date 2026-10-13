// @keepTs
// @ts-nocheck
export declare class GMGDTAdapterBase {
    static AdapterAdnName: string;
}
export interface GDTAdSDKConfig_copy {
    appId: string;
}
export interface GDTAdSDKStartResult_copy {
    code: number;
    msg: string;
}
export interface GDTAdLoadConfig_copy {
    posId: string;
}
export interface GDTInteractionListener_copy {
    onAdExposure: () => void;
    onAdClick: () => void;
    onAdClose: () => void;
    onError: (error: ESObject) => void;
    onReward?: (map: Map<string, string>) => void;
}
export interface GDTVideoStateListener_copy {
    onVideoReady?: () => void;
    onVideoStart?: () => void;
    onVideoPause?: () => void;
    onVideoResume?: () => void;
    onVideoComplete?: () => void;
    onVideoError?: (err: ESObject) => void;
}
