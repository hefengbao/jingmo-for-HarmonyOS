import { String } from 'constants';

@Builder
export function BookmarkIndexPageBuilder() {
  BookmarkIndexPage();
}

@ComponentV2
export struct BookmarkIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {

    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
