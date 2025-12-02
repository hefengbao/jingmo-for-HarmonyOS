import { AvoidAreaObserver, Icon, String } from 'constants';
import { Quote, readRandomQuote } from '../model/Quote';
import { QuoteView } from '../view/QuoteView';
import { AppStorageV2 } from '@kit.ArkUI';

;

@Builder
export function QuoteIndexPageBuilder() {
  QuoteIndexPage()
}

@ComponentV2
export struct QuoteIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local quote: Quote | null = null;

  aboutToAppear(): void {
    this.refresh()
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.quote) {
          QuoteView({ quote: this.quote })
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_quote)
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
    readRandomQuote().then((value: Quote | null) => {
      this.quote = value
    })
  }
}
