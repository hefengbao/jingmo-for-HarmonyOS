import { Icon, String } from 'constants';
import { Idiom, readRandomIdiom } from '../model/Idiom';
import { IdiomView } from '../view/IdiomView';

@Builder
export function IdiomIndexPageBuilder() {
  IdiomIndexPage();
}

@ComponentV2
export struct IdiomIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local idiom: Idiom | null = null;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.idiom) {
          IdiomView({ idiom: this.idiom })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_idiom)
    .toolbarConfiguration([
      {
        "value": String.refresh,
        "icon": Icon.ic_public_refresh,
        "action": () => {
          this.refresh()
        }
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }

  refresh() {
    readRandomIdiom().then((value: Idiom | null) => {
      this.idiom = value;
    })
  }
}
