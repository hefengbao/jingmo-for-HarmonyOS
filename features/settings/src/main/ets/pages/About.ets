@Builder
export function AboutBuilder() {
  About()
}

@ComponentV2
export struct About {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Scroll() {
        Column() {

        }
      }
    }
    .title($r('app.string.about'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}