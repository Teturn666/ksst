import { rcp } from '@kit.RemoteCommunicationKit';
import { TokenBucket } from "./j";
export interface IERR_LOG {
    "channel": string;
    "brand": string;
    "osVersion": string;
    "umid": string;
    "deviceModel": string;
    "platform": string;
    "appkey": string;
    "appVersion": string;
    "sdkVersion": string;
    "sessionid": string;
    "ts": string;
    "ekverr": IEkvErr;
}
interface IEkvErr {
    "eID": string;
    "code": Array<EVENT_ERROR_CODE>;
    "epps": Array<IEPPS>;
    "pps": Record<string, string | number> | null;
}
interface IEPPS {
    "pid": string;
    "msg": string;
    "code": Array<ATTR_ERR_CODE>;
}
interface EKV {
    id: string;
    params: Record<string, string | number>;
    ts: number;
    sid?: string;
}
declare enum EVENT_ERROR_CODE {
    NOT_NULL = "100001",
    NOT_EMPTY = "100002",
    NOT_KEEP = "100003",
    NOT_128 = "100004",
    NOT_SPECIAL = "100005"
}
declare enum ATTR_ERR_CODE {
    KEY_COUNT_100 = "100006",
    KEY_KEEP = "100007",
    KEY_128 = "100009",
    KEY_EMPTY = "100016",
    KEY_SPECIAL = "100025",
    VALUE_256 = "100012"
}
export declare class ErrLog {
    ss: rcp.Session;
    baseDir: string;
    static q: EKV[];
    static p: EKV[];
    private isProcessing;
    bucket: TokenBucket;
    taskId: number;
    static disable: boolean;
    constructor(l1: string, m1: string);
    uploadErr(d1: IERR_LOG): Promise<void>;
    startSendTask(): void;
    private processQueue;
    stopSendTask(): void;
    transEkv2EPPS(q: EKV): IERR_LOG | undefined;
    static addEkvSendTask(m: string, n: Record<string, string | number>, o: number, p?: string): void;
}
export {};
