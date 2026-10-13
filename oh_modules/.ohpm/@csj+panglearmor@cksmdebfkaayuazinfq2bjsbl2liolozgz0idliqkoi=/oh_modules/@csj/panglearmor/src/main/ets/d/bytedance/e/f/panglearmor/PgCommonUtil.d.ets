// @keepTs
// @ts-nocheck
export declare class PgCommonUtil {
    private static o;
    private constructor();
    static getInstance(): PgCommonUtil;
    getInode(): number[];
    getDiskTotalSpace(): number;
    getMemoryTotalSpace(): number;
    getSystemStartupTime(): number;
    getFileModifyTimes(context: Context): number;
    getDeviceName(): string;
}
