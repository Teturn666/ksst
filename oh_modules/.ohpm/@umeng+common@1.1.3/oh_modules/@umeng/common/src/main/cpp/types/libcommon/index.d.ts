

// buildEnv：构建信封文件并通过Promise返回已构建信封文件全路径。
// 参数说明
// dataBuf: 字节Array长度需要小于5MB。
// encodeType: none,xor或者aes，none为不进行任何加密处理，仅做gzip原始处理，一期收数端不支持aes算法，仅支持xor算法，所以传入aes实际效果和xor一致。
// encodeType字符串长度不能超过15个字符。
// key: xor算法key，宿主应用初始化SDK时传入的umeng appkey，key字符串长度不能超过63个字符。
// path: 宿主应用私有沙盒files目录绝对路径。
// dirName: 存放信封文件的目录名，接口会在files目录下创建此目录，并将构建成功的信封文件放到此目录下。dirName字符串长度不能超过127个字符。
// fileName: 形如 a_1376834481301.env 的信封文件名。


// ts: 调用本接口构建信封时的系统时间戳。
export const buildEnv: (dataBuf: Uint8Array, encoderType: string, key: string,  path: string, dirName: string, fileName: string) => Promise<string>;

export const parseEnv: (dataBuf: Uint8Array, encoderType: string, key: string) => Promise<string>;

// aes加密接口
// 参数说明
// dataBuf: 字节Array长度需要小于20KB，待加密数据。
// 返回值：已加密数据
export const aesGcmEncrypt: (dataBuf: Uint8Array) => Promise<Uint8Array>;
// aes解密接口
// 参数说明
// dataBuf: 字节Array长度需要小于20KB，待解密数据。
// 返回值：已解密数据
export const aesGcmDecrypt: (dataBuf: Uint8Array) => Promise<Uint8Array>;