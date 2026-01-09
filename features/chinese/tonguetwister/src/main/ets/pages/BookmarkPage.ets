import { String } from 'constants';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
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
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}