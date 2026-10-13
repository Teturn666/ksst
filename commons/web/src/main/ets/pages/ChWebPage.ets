import web_webview from '@ohos.web.webview'
import { TitleBar } from 'widget/Index'
import { router } from '@kit.ArkUI'


@Entry({ routeName: 'webPage' })
@Component
export struct ChWebPage {
  controller: web_webview.WebviewController = new web_webview.WebviewController()
  webUrl = ''
  title = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    if (params) {
      this.webUrl = params.url as string
      this.title = params.title as string
    }
  }

  build() {
    Column() {
      TitleBar({
        title: this.title, backClick: () => {
          router.back()
        }
      })
      Web({ src: this.webUrl, controller: this.controller })
    }
  }
}