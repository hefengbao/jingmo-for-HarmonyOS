import { PageName } from 'constants'

@ComponentV2
export struct Settings {
  @Local message: string = 'Settings';
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination(){
      Scroll(){

      }
      .height('100%')
    }
    .title($r('app.string.settings'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}
