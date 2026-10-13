import { UMConfig } from "../l";
import { BasePlugin } from "./k";
/**
 * 对于每一个app，都可以注册多个自定义的Plugin插件
 * 该接口定义管理插件的相关接口
 *
 *
 */
export interface PluginContainer {
    /**
     * 注册扩展的BasePlugin到对应的ability中
     *
     * @param {BasePlugin} plugin
     * @return {BasePlugin}
     */
    registryPlugin(plugin: BasePlugin, cfg: UMConfig): BasePlugin;
    /**
     * 通过Plugin Id来获取当前module中存在的plugin
     *
     * @param {string} pluginId
     * @return {BasePlugin|undefined}
     */
    getPluginById(pluginId: string): BasePlugin | undefined;
}
