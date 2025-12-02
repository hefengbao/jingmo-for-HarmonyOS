import { webview } from '@kit.ArkWeb';
import { NetworkConst } from 'constants';

@Builder
export function ImportDataHelpPageBuilder() {
  ImportDataHelpPage()
}

@ComponentV2
export struct ImportDataHelpPage {
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
        Web({ src: NetworkConst.HELP, controller: this.webviewController })
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
    .title($r('app.string.import_data_help'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}