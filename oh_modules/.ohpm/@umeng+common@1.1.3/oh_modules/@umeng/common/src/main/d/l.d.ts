import common from '@ohos.app.ability.common';
import { BasePlugin } from "./j/k";
export declare class UMConfig {
    appKey?: string;
    channel?: string;
    enableLog?: boolean;
    context: common.ApplicationContext;
    plugins?: BasePlugin | BasePlugin[];
    MAX_SESSION_TIME?: number;
}
