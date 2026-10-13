// @keepTs
// @ts-nocheck
export declare class GMKsAdapterBase {
    static AdapterAdnName: string;
}
export interface KSFullScreenAdInteractListener_copy {
    onAdShow?: () => void;
    onAdClick?: () => void;
    onAdClose?: () => void;
    onVideoPlayStart?: () => void;
    onVideoPlayEnd?: () => void;
    onVideoPlayError?: (code: number, extra: string) => void;
    onVideoSkipToEnd?: (playDurationMs: number) => void;
}
export interface KSAdExposureFailReason_copy {
    winEcpm?: number;
    adnType?: number;
    adnName?: string;
}
export interface KSAdVideoPlayConfig_copy {
    videoSoundEnable?: boolean;
    dataFlowAutoStart?: boolean;
    videoAutoPlayType?: number;
}
export interface KSVideoPlayListener_copy {
    onVideoReady?: () => void;
    onVideoPlayStart?: () => void;
    onVideoPlayComplete?: () => void;
    onVideoPause?: () => void;
    onVideoResume?: () => void;
    onVideoPlayError?: (code: number, extra: string) => void;
}
export interface KSBaseAd_copy {
    setBidEcpm(g171: number): void;
    setBidEcpmAndHighestLoss(e171: number, f171: number): void;
    getEcpm(): number;
    reportExposureFail(errorCode: number, reason: KSAdExposureFailReason_copy): ESObject;
    videoPlayConfig?: KSAdVideoPlayConfig_copy;
    setVideoPlayConfig(d171: KSAdVideoPlayConfig_copy): void;
}
