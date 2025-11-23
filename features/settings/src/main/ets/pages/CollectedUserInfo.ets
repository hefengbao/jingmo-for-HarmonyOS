@Builder
export function CollectedUserInfoBuilder() {
  CollectedUserInfo()
}

@ComponentV2
export struct CollectedUserInfo {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text('不收集、保存任何用户信息。')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(16)
    }
    .title($r('app.string.collected_user_info'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}