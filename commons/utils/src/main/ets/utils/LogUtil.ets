import { hilog } from "@kit.PerformanceAnalysisKit";

//日志打印上限4096字节，日志分段打印
export class LogUtil {
  private static instance: LogUtil;
  private static DOMAIN: number = 0x0000;

  private constructor() {
    // 私有构造函数，防止外部实例化
  }

  public static getInstance(): LogUtil {
    if (!LogUtil.instance) {
      LogUtil.instance = new LogUtil();
    }
    return LogUtil.instance;
  }

  public static logError(logTag: string, content: string) {
    const maxSize = 1024;
    if (content.length <= maxSize) {
      // 长度小于等于限制直接打印
      hilog.error(LogUtil.DOMAIN, logTag, '%{public}s', content);
    } else {
      while (content.length > maxSize) {
        // 循环分段打印
        let logContent = content.substring(0, maxSize);
        content = content.replace(logContent, '');
        hilog.error(LogUtil.DOMAIN, logTag, '%{public}s', logContent);
      }
      // 打印剩余日志
      hilog.error(LogUtil.DOMAIN, logTag, '%{public}s', content);
    }
  }

  public static logDebug(logTag: string, content: string) {
    const maxSize = 1024;
    if (content.length <= maxSize) {
      hilog.debug(LogUtil.DOMAIN, logTag, '%{public}s', content);
    } else {
      while (content.length > maxSize) {
        let logContent = content.substring(0, maxSize);
        content = content.replace(logContent, '');
        hilog.debug(LogUtil.DOMAIN, logTag, '%{public}s', logContent);
      }
      hilog.debug(LogUtil.DOMAIN, logTag, '%{public}s', content);
    }
  }
}
