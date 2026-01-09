import { String } from 'constants';

@Builder
export function SnapshotPageBuilder() {
  SnapshotPage();
}

@ComponentV2
export struct SnapshotPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Grid() {

      }
      .width('100%')
      .height('100%')
      .padding(16)
      .columnsTemplate('1fr 1fr')
      .rowsGap(16)
      .columnsGap(16)
    }
    .title(String.chinese_wisecrack)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}