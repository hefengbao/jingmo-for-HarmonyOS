import {String, Icon } from 'constants';
import { Quote,readRandomQuote } from '../model/Quote';

@Builder
export function QuoteIndexPageBuilder(){
  QuoteIndexPage()
}

@ComponentV2
export struct QuoteIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local quote: Quote | null = null;

  aboutToAppear(): void {
    this.refresh()
  }

  build() {
    NavDestination(){
      Scroll(){
        if (this.quote){

        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_quote)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }

  refresh(){
    readRandomQuote().then((value: Quote | null) => {
      this.quote = value
    })
  }
}
