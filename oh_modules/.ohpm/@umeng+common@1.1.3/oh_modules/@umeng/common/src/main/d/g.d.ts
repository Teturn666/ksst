import { Biz_Type } from "./h";
/**
 * 日志打印工具类
 */
export declare class LogUtil {
    biz: Biz_Type;
    tag: string;
    static _enable: boolean;
    static instances: LogUtil[];
    constructor(u11: Biz_Type, v11?: string);
    warn(s11: string, ...t11: any[]): void;
    error(q11: string, ...r11: any[]): void;
    log(o11: string, ...p11: any[]): void;
    static getInstance(k11: Biz_Type): LogUtil;
    static enable(): void;
    static disable(): void;
}
