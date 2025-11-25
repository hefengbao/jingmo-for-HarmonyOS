@Builder
export function SharedUserInfoPageBuilder() {
  SharedUserInfoPage()
}

@ComponentV2
export struct SharedUserInfoPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text('不向第三方共享任何用户数据')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(16)
    }
    .title($r('app.string.shared_user_info'))
    .onReady((ctx: NavDestinationContext) => [
      this.pageStack = ctx.pathStack
    ])
  }
}