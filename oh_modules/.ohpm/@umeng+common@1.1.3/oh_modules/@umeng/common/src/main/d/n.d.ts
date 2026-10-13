import { UMConfig } from "./l";
export declare class Session {
    static sid: string;
    static config: UMConfig;
    static last_event_time: number;
    static session_start: number;
    static session_end: number;
    static MAX_SESSION_TIME: number;
    static interval: number;
    static init_ed: boolean;
    static puid: string;
    static provider: string;
    static isForeground: Boolean;
    static bindSession(d13: UMConfig): void;
    static resume(): void;
    static pause(): void;
    /**
     * 根据条件判断是否启用新的session
     * @param force 是否强制切割session
     */
    static create(): void;
    static getSessionId(): string;
    static getActiveUserInfo(): {
        provider: string;
        puid: string;
    };
    static signOff(): void;
    static signIn(s12: string, t12: string): void;
}
