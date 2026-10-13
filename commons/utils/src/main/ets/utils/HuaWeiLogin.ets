import { authentication } from "@kit.AccountKit"
import { util } from "@kit.ArkTS";

export class HuaweiAuthManager {

  async launchAuth() {
    try {
      // 1.创建授权请求
      const request = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest()
      // 2.传递参数
      request.scopes = ['phone'];
      // 获取code需传如下permission
      request.permissions = ['serviceauthcode'];
      //
      request.forceAuthorization = true;

      request.state = util.generateRandomUUID();

      // controller的目的是发起请求
      const controller = new authentication.AuthenticationController(getContext())

      const result = await controller.executeRequest(request) as authentication.AuthorizationWithHuaweiIDResponse
      if (request.state === result.state) {

        return result.data?.authorizationCode
      } else {
        AlertDialog.show({ message: '华为登录请求被篡改！！！' })
        return Promise.reject(new Error("华为登录请求被篡改"))
      }

    } catch (error) {
      AlertDialog.show({ message: error.message })
      return Promise.reject(error)
    }

  }


  async exitAuth() {
    const cancelRequest = new authentication.HuaweiIDProvider().createCancelAuthorizationRequest()
    const controller = new authentication.AuthenticationController()
    await controller.executeRequest(cancelRequest)

  }
}

export const huaweiAuthManager = new HuaweiAuthManager()