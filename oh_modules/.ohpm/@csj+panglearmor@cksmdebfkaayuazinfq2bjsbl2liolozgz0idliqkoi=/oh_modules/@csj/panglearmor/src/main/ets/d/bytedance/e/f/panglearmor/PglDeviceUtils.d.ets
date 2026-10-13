// @keepTs
// @ts-nocheck
export declare class PglDeviceUtils {
    static readonly t: string;
    private static o;
    private constructor();
    static getInstance(): PglDeviceUtils;
    getFileModifyTime(path: string): number | undefined;
    getDeviceInfo(): Uint32Array;
    getCpuInfo(): string[];
}
