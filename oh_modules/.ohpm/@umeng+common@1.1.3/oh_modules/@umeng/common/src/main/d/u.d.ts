import request from '@ohos.request';
import common from '@ohos.app.ability.common';
import Queue from '@ohos.util.Queue';
import { ENCODE_TYPE, DEC_TYPE } from "./e";
import { Biz_Type } from "./h";
import connection from '@ohos.net.connection';
export declare enum FlusherType {
    flusher_http = 0
}
export interface FlusherHttpConfig {
    bizType: Biz_Type;
    enable: boolean;
    remoteURL: Array<string>;
    headers?: Record<string, string>;
    data?: Array<request.RequestData>;
    timeout?: number;
    retry?: {
        enable?: boolean;
        maxRetryTimes?: number;
        initialDelay?: number;
        maxDelay?: number;
    };
}
export interface ResponseHeader {
    headers?: {
        'msg-type': ENCODE_TYPE;
        'x-um-finish': "1";
        'x-um-dec': DEC_TYPE;
        'x-um-sk': string;
    };
    body?: string;
}
export interface ILogFileMeta {
    file: string;
    di: string;
    ts?: string;
    encrypt?: string;
    compress?: string;
    encode?: string;
    sk?: string;
    ak?: string;
}
export declare class FlusterHttp {
    flushQueue: Queue<ILogFileMeta>;
    sending: boolean;
    context: common.ApplicationContext;
    interval: number;
    netCon: connection.NetConnection;
    netEnable: boolean;
    config: FlusherHttpConfig;
    constructor(h13: common.ApplicationContext, i13: FlusherHttpConfig);
    flush(e7: string, f7?: Record<string, string>): void;
    delete(c7: string): void;
    start(): void;
    stop(): void;
    upload(v6: any): void;
    retry(s6: number): void;
    private uploadFile;
    private uploadFile2;
}
