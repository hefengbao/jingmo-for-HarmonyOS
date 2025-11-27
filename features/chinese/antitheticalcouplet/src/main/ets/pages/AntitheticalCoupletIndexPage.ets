import { String } from 'constants';

@Builder
export function AntitheticalCoupletIndexPageBuilder(){
  AntitheticalCoupletIndexPage();
}

@ComponentV2
export struct AntitheticalCoupletIndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination(){

    }
    .title(String.chinese_antitheticalcouplet)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
