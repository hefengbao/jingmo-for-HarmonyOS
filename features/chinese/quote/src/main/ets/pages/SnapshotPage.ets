import { getQuote, Quote } from '../model/Quote';
import { QuoteView } from '../view/QuoteView';
import { ParamNumberId, String } from 'constants';
import { image } from '@kit.ImageKit';
import { CopyrightView, SnapshotToolbar } from 'uicomponents';

@Builder
export function SnapshotPageBuilder() {
  SnapshotPage()
}

@ComponentV2
struct SnapshotPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack()
  @Local quote: Quote | undefined;
  @Local pixmap: image.PixelMap | undefined = undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.quote) {
          Column() {
            Column({
              space: 32
            }) {
              QuoteView({ quote: this.quote })
              CopyrightView()
            }
            .backgroundColor('#426666')
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 64,
              bottom: 64
            })
            .id('image')
            SnapshotToolbar()
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({})
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_quote)
    .menus([])
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        getQuote(param.id).then((value: Quote | undefined) => {
          this.quote = value;
        })
      }
    })
  }
}