import { String } from 'constants';

@Builder
export function BookmarkIndexBuilder() {
  BookmarkIndex();
}

@ComponentV2
export struct BookmarkIndex {
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
