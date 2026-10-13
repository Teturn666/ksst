// @keepTs
// @ts-nocheck
export declare class PglCryptUtils {
    static readonly t: string;
    private static o;
    private constructor();
    static getInstance(): PglCryptUtils;
    encryptData(plainText: Uint8Array): Uint8Array | undefined;
    decryptData(cipherText: Uint8Array): Uint8Array | undefined;
    aesEncryptData(plainText: Uint8Array): Uint8Array | undefined;
    aesDecryptData(cipherText: Uint8Array): Uint8Array | undefined;
    encryptCompressData(plainText: Uint8Array): Uint8Array | undefined;
    decryptCompressData(plainText: Uint8Array): Uint8Array | undefined;
    encryptDataServer(plainText: Uint8Array): Uint8Array | undefined;
    decryptDataServer(cipherText: Uint8Array): Uint8Array | undefined;
    encryptCompressDataServer(cipherText: Uint8Array): Uint8Array | undefined;
    decryptCompressDataServer(cipherText: Uint8Array): Uint8Array | undefined;
}
