// @keepTs
// @ts-nocheck
import { AdSlot, CustomLoadAdapter, CustomLoadListener, CustomInteractionListener, CustomPackAd, CustomVideoListener } from "@csj/openadsdk/Index";
import { NodeController, FrameNode, UIContext } from '@kit.ArkUI';
export declare class GMKsDrawAdapter extends CustomLoadAdapter {
    private TAG;
    loadAd(a2: string, b2: CustomLoadListener, c2: AdSlot, d2?: Map<string, object>): void;
}
export declare class PackKSDrawAd extends CustomPackAd {
    private TAG;
    private mAd;
    private mCustomInteractionListener?;
    private mCustomVideoListener?;
    private adComponent?;
    constructor(z1: ESObject);
    setCustomInteractionListener(y1: CustomInteractionListener): void;
    setCustomVideoListener(u1: CustomVideoListener): void;
    getAdComponent(): NodeController | undefined;
    render(t1: UIContext): void;
    destroy(): void;
    private mInteractionListener;
    private mVideoListener;
}
@Component
export declare struct KsDrawAdComponent {
    ksAd: ESObject | undefined;
    ksNS?: ESObject;
    @BuilderParam
    feedAdViewBuilder: (ns: ESObject) => void;
    @BuilderParam
    drawAdBuilder: (ns: ESObject) => void;
    aboutToAppear(): void;
    build(): void;
}
export declare class KSDrawViewNodeController extends NodeController {
    private adComponentNode;
    private param;
    private mFrameNode?;
    constructor(m: ESObject);
    makeNode(l: UIContext): FrameNode | null;
    release(): void;
}
