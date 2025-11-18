import { webview } from '@kit.ArkWeb'
import { NetworkConst } from 'constants'

@ComponentV2
export struct Privacy {
  @Local webviewController: webview.WebviewController = new webview.WebviewController
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Web({ src: NetworkConst.PRIVACY_LINK, controller: this.webviewController })
          .domStorageAccess(true)
      }
      .height('100%')
      .width('100%')
    }
    .title($r('app.string.privacy_policy'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}