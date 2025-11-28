import { webview } from '@kit.ArkWeb';
import { NetworkConst } from 'constants';

@Builder
export function PrivacyPageBuilder() {
  PrivacyPage()
}

@ComponentV2
export struct PrivacyPage {
  @Local webviewController: webview.WebviewController = new webview.WebviewController
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local showLoading: boolean = false;

  build() {
    NavDestination() {
      Column() {
        if (this.showLoading) {
          LoadingProgress()
            .width(80)
            .height(80)
        }
        Web({ src: NetworkConst.PRIVACY_LINK, controller: this.webviewController })
          .domStorageAccess(true)
          .onPageBegin(() => {
            this.showLoading = true
          })
          .onPageEnd(() => {
            this.showLoading = false
          })
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