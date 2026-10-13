import buffer from '@ohos.buffer';
import { buildEnv } from 'libcommon.so';
import { Biz_Type } from "./h";
export declare enum COMPRESS_TYPE {
    NONE = "none",
    GZIP = "gzip",
    ZSTD = "zstd",
    LZ4 = "lz4",
    ZLIB = "zlib"
}
export declare enum ENC_TYPE {
    XOR = 1,
    AES = 2,
    NONE = 0
}
export declare enum DEC_TYPE {
    XOR64 = 1,
    XOR = 2,
    AES = 3,
    AES64 = 4,
    NONE = 0
}
export declare enum ENCODE_TYPE {
    HM_JSON = "json",
    HM_PROTO = "proto"
}
export type BeforeEncode = (b: buffer.Buffer) => Promise<buffer.Buffer>;
export declare abstract class Encoder {
    x_um_sk: string;
    x_um_ak: string;
    biz: Biz_Type;
    x_um_enc: ENC_TYPE;
    x_um_compress: COMPRESS_TYPE;
    file_path: string;
    dir_name: string;
    file_name: string;
    encode_type: ENCODE_TYPE;
    log_path: string;
    beforeEncode: BeforeEncode;
    constructor(i5: string, j5: Biz_Type, k5: ENCODE_TYPE, l5: COMPRESS_TYPE, m5: ENC_TYPE, n5: string, o5: string, p5?: BeforeEncode);
    encode(h5: buffer.Buffer): Promise<string>;
    decode(d5: buffer.Buffer, e5: ENCODE_TYPE, f5: DEC_TYPE, g5: string): Promise<string>;
}
/**
 * CPP编解码器
 */
export declare class NativeEncoder extends Encoder {
    encode(a5: buffer.Buffer): Promise<string>;
    static decode(v4: buffer.Buffer | string | ArrayBuffer, w4: ENCODE_TYPE, x4: DEC_TYPE, y4: string): Promise<string>;
}
export declare function decode(p4: buffer.Buffer | string | ArrayBuffer, q4: ENCODE_TYPE, r4: DEC_TYPE, s4: string): Promise<string>;
export declare class AesGcmEncoder {
    static encrypt(g4: buffer.Buffer): Promise<Uint8Array>;
    static decrypt(d4: Uint8Array): Promise<buffer.Buffer>;
}
export declare function GzipOnly(z3: Uint8Array, a4: string, b4: string, c4: string): Promise<string>;
export { buildEnv };
