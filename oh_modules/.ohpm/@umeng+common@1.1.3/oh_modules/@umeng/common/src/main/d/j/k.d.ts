import { UMConfig } from "../l";
import buffer from '@ohos.buffer';
import { PluginContainer } from "./v";
import { Biz_Type } from "../h";
/**
 * plugin的基类
 *
 *
 */
export declare abstract class BasePlugin {
    pluginVersion: string;
    pluginId: Biz_Type;
    alias: string;
    alias_h: string;
    cfg: UMConfig;
    plugins: PluginContainer;
    constructor(d12: Biz_Type);
    getPluginId(): Biz_Type;
    install(b12: UMConfig, c12: PluginContainer): void;
    uninstall(): void;
    agree(): Promise<void>;
    write(x11: string, y11: Record<string, string | number>, z11: number, a12?: string): void;
    beforeEncode(w11: buffer.Buffer): Promise<buffer.Buffer>;
}
