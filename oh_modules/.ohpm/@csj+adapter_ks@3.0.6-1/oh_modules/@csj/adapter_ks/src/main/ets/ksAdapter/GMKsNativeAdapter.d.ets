// @keepTs
// @ts-nocheck
import { ArrayList } from '@kit.ArkTS';
import { FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { AdSlot, CSJArrayList, CSJComplianceInfo, CSJImage, CustomLoadAdapter, CustomLoadListener, CustomPackAd, CustomInteractionListener, CustomVideoListener, CSJDislikeInteractionCallback } from "@csj/openadsdk/Index";
/**
 * 信息流模版 & 自渲染广告
 */
export declare class GMKsNativeAdapter extends CustomLoadAdapter {
    private loadBridge?;
    private ksNS?;
    loadAd(r9: string, s9: CustomLoadListener, t9: AdSlot, u9?: Map<string, Object>): void;
}
export interface KSFeedAdInteractListener_copy {
    onAdShow?: () => void;
    onAdClick?: () => void;
    onDislikeClicked?: () => void;
}
export interface KSNativeAdInteractListener_copy {
    onAdShow?: () => void;
    onAdClick?: () => void;
}
export declare const enum KSAdInteractionType_copy {
    unknown = 0,
    download = 1,
    h5 = 2
}
export declare const enum KSAdMaterialType_copy {
    unknown = 0,
    video = 1,
    single_img = 2,
    group_image = 3,
    small_group_image = 5,
    origin_live = 8
}
export declare class PackKSFeedExpressAd extends CustomPackAd {
    private mAd;
    private mCustomInteractionListener?;
    private disLikeCallback?;
    private ksNS?;
    constructor(p9: ESObject, q9?: ESObject);
    getAdComponent(): NodeController | undefined;
    setDislikeCallback(o9: CSJDislikeInteractionCallback): void;
    setCustomVideoListener(j9: CustomVideoListener): void;
    setCustomInteractionListener(h9: CustomInteractionListener): void;
    render(g9: UIContext): void;
}
export declare class PackKSNativeAd extends CustomPackAd {
    private mAd;
    private mCustomInteractionListener?;
    private ksNS?;
    constructor(e9: ESObject, f9?: ESObject);
    getTitle(): string;
    getDescription(): string;
    getAdLogo(): string | Resource;
    getSource(): string;
    getComplianceInfo(): CSJComplianceInfo | undefined;
    getImageList(): ArrayList<CSJImage> | undefined;
    getAdComponent(): NodeController | undefined;
    getInteractionType(): number;
    getAppSize(): number;
    getImageMode(): number;
    getButtonText(): string;
    getAppScore(): number;
    getIcon(): CSJImage | undefined;
    getVideoCoverImage(): CSJImage | undefined;
    convertToCSJInteractionType(a9: KSAdInteractionType_copy): number;
    convertToCSJImage(z8: ESObject): CSJImage;
    convertToCSJImageMode(y8: KSAdMaterialType_copy): number;
    render(x8: UIContext): void;
    registerViewForInteraction(h8: string, i8: UIContext, j8: CSJArrayList<string>, k8: CSJArrayList<string>): void;
    setCustomInteractionListener(f8: CustomInteractionListener): void;
    setCustomVideoListener(b8: CustomVideoListener): void;
}
export declare class ComplianceModel implements CSJComplianceInfo {
    private ad;
    constructor(a8: ESObject);
    getAppName(): string;
    getAppVersion(): string;
    getDeveloperName(): string;
    getPrivacyUrl(): string;
    getPermissionsMap(): Map<string, string>;
    getPermissionUrl(): string;
    getFunctionDescUrl(): string;
}
export declare class AdViewNodeController extends NodeController {
    private adComponentNode;
    private param;
    private mFrameNode?;
    constructor(n7: ESObject);
    makeNode(m7: UIContext): FrameNode | null;
    release(): void;
}
@Component
export declare struct KsNativeAdComponent {
    ksAd: ESObject | undefined;
    ksNS?: ESObject;
    @BuilderParam
    feedAdViewBuilder: (ns: ESObject) => void;
    @BuilderParam
    nativeAdVideoViewBuilder: (ns: ESObject) => void;
    aboutToAppear(): void;
    build(): void;
}
