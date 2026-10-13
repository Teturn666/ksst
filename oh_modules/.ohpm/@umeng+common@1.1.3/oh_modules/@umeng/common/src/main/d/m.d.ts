import { UMConfig } from "./l";
import { DefaultPluginContainer } from "./j/s";
import { Biz_Type } from "./h";
export declare class Uma {
    static oaid: any;
    static headerInfo: any;
    static plugins: DefaultPluginContainer;
    static isReady: boolean;
    static config: UMConfig;
    static PreCollectEvent: Array<[
        Biz_Type,
        string,
        Record<string, string | number>,
        number,
        string?
    ]>;
    static agree(): Promise<void>;
    private static use;
    static setLogEnabled(n3: boolean): void;
    static bindContext(f3: UMConfig): void;
    static destroy(): Promise<void>;
    static trackEvent(y2: Biz_Type, z2: string, a3?: Record<string, number | string>): void;
}
