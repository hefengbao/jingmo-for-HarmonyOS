import { Icon, String } from 'constants';
import { AntitheticalCouplet, readRandomAntitheticalCouplet } from '../model/AntitheticalCouplet';
import { AntitheticalCoupletView } from '../view/AntitheticalCoupletView';

@Builder
export function AntitheticalCoupletIndexPageBuilder() {
  AntitheticalCoupletIndexPage();
}

@ComponentV2
export struct AntitheticalCoupletIndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local antitheticalCouplet: AntitheticalCouplet | null = null;

  aboutToAppear(): void {
    this.refresh()
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.antitheticalCouplet) {
          AntitheticalCoupletView({ antitheticalCouplet: this.antitheticalCouplet })
        }
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_antitheticalcouplet)
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
      this.pageStack = ctx.pathStack;
    })
  }

  refresh() {
    readRandomAntitheticalCouplet().then((value: AntitheticalCouplet | null) => {
      this.antitheticalCouplet = value
    })
  }
}
