import { BoldTitle } from 'uicomponents';
import { ThemeConst } from 'constants';

@Builder
export function ImportDataHelpPageBuilder() {
  ImportDataHelpPage()
}

@ComponentV2
export struct ImportDataHelpPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        BoldTitle({ text: '下载数据' })
        Text("关注公众号『NowInLife』,回复“京墨”获取最新网盘下载地址。")
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
          .copyOption(CopyOptions.InApp)
        BoldTitle({ text: '导入数据' })
        Text("每个模块请选择【同名目录】里的数据，进入目录后，可以一次性选择所有文件导入。")
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
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