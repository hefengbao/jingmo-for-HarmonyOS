import { PageName } from 'constants'

@ComponentV2
export struct About {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Text($r('app.string.tos'))
            .onClick(() => {
              this.pageStack.pushPathByName(PageName.TOS, "")
            })
          Text($r('app.string.privacy_policy'))
            .onClick(() => {
              this.pageStack.pushPathByName(PageName.Privacy, "")
            })
        }
      }
    }
    .title($r('app.string.about'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}