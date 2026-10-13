import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { FlusherHttpConfig, FlusterHttp } from "./u";
export declare enum InputType {
    input_file = 0
}
export interface InputConfig {
    Type: InputType;
    FilePaths: Array<string>;
}
export declare class LogAgent {
    static instances: Array<LogAgent>;
    context: common.ApplicationContext;
    watchers: Array<fs.Watcher>;
    enable: boolean;
    maxStorage: number;
    input: InputConfig;
    flusher: FlusterHttp;
    constructor(e13: common.ApplicationContext, f13: FlusherHttpConfig, g13: InputConfig);
    start(): void;
    stop(): void;
    /**
     * 创建logAgent
     * @param context
     * @param config
     * @param appKey
     * @returns
     */
    static build(h8: common.ApplicationContext, i8: FlusherHttpConfig, j8: string): LogAgent;
    static startAll(): void;
    static stopAll(): void;
}
