// 初始化applog sdk
export const init: (appId: string, channel: string) => undefined;

// 启动sdk
export const start: () => undefined;

// 设置是否自动开始
export const set_auto_start: (enable: boolean) => undefined;

// 设置一级公参
export const set_header: (key: string, value: string) => undefined;

// 设置一级公参，值为json格式的字符串
export const set_json_header: (key: string, value: string) => undefined;

// 设置文件更新时间的公参
export const  set_file_modify_time_header: (key: string, filename: string) => undefined;

// 获取全部参数
export const get_headers: () => string | undefined;

// 添加自定义参数
export const add_custom_header: (key: string, value: string) => undefined;

// 删除自定义参数
export const remove_custom_header: (key: string) => undefined;

// 采集埋点
export const on_event: (name: string, params: string) => undefined;

// 采集埋点
export const on_impression: (params: string) => undefined;

// 设置日志打印，如果未设置，也不会打印
export const set_logger: (logger: (message: string) => void) => undefined;

// 设置日志开关，默认开启，关闭后不打印日志
export const set_log_enable: (enabled: boolean) => undefined;

// 设置数据库地址
export const set_db_path: (path: string) => undefined;

// 设置http post请求客户端
export const set_http_post: (c: (id: string, url: string, body: ArrayBuffer, headers: string) => void) => undefined;

// 设置http post请求客户端
export const on_http_response: (c: string) => undefined;

// 设置et开关
export const enable_et: (e: boolean) => undefined;

// 应用启动
export const launch: () => undefined;

// 应用退出
export const terminate: () => undefined;

// 设置域名，如 set_domain("log-klink.zijieapi.com", "log-klink.zijieapi.com", "log.zijiapi.com", "rtlog.zijiapi.com", "log.zijiapi.com", "log.bytedance.net")
export const set_domain: (register: string, active: string, log: string, realtime_log: string, settings: string, event_verify: string) => undefined;

// 设置用户ID
export const set_user_id: (id: number) => undefined;

// 获取用户did
export const get_device_id_str: () => string | undefined;

// 获取安装id
export const get_install_id_str: () => string | undefined;

// 获取session id
export const get_session_id: () => string | undefined;

// 获取time sync(0-server_time;1-local_time)
export const get_time_sync: () => number[] | undefined;

// 清空数据：新用户模式等
export const clear: () => string | undefined;

// 立刻上报埋点
export const flush: () => undefined;

/// 设置压缩开关
export const set_compress_enable: (enable: boolean) => undefined;

/// 设置加密开关
export const set_encrypt_enable: (enable: boolean) => undefined;

/// 设置是否采集埋点
export const set_track_event_enable: (enable: boolean) => undefined;

/// 设置是否上报埋点
export const set_report_event_enable: (enable: boolean) => undefined;

/// 添加did监听器
export const add_did_listener: (listener: (did: bigint) => void) => undefined;

/// 添加iid监听器
export const add_iid_listener: (listener: (id: bigint) => void) => undefined;

/// 添加异常打点
export const set_error_reporter: (reporter: (msg: string) => void) => undefined
