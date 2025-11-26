import { ImportDataList } from '../view/ImportDataList';

@Builder
export function ImportDataPageBuilder(){
  ImportDataPage()
}

@ComponentV2
export struct ImportDataPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination(){
      Scroll(){
        ImportDataList()
          .padding(16)
      }
      .align(Alignment.TopStart)
      .width('100%')
      .height('100%')
    }
    .title($r('app.string.import_data'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}