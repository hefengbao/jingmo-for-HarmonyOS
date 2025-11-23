import { webview } from '@kit.ArkWeb';
import { NetworkConst } from 'constants';

@Builder
export function TOSBuilder() {
  TOS()
}

@ComponentV2
export struct TOS {
  @Local webviewController: webview.WebviewController = new webview.WebviewController
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Web({ src: NetworkConst.TOS_LINK, controller: this.webviewController })
          .domStorageAccess(true)
      }
      .height('100%')
      .width('100%')
    }
    .title($r('app.string.tos'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}