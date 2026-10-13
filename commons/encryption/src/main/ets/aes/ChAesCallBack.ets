export interface ChAesCallBack {

  //返回解密后的文本
  aesSuccess(result: string): void

  //解密失败
  aesFail(err: Resource): void
}