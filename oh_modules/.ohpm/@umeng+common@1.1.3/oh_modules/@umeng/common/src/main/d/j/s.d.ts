import { BasePlugin } from "./k";
import { PluginContainer } from "./v";
import { UMConfig } from "../l";
import { Biz_Type } from "../h";
/**
 * 用于插件管理模块
 *
 */
export declare class DefaultPluginContainer implements PluginContainer {
    readonly _pluginMap: BasePlugin[];
    constructor();
    registryPlugin(g12: BasePlugin, h12: UMConfig): BasePlugin;
    getPluginById(e12: Biz_Type): BasePlugin | undefined;
}
