import { Quote } from '../model/Quote';
import { ThemeConst } from 'constants';

@ComponentV2
export struct QuoteView {
  @Param @Require quote: Quote

  build() {
    Column() {
      Text(this.quote.content)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
        .lineHeight(24)
      Text(`—— ${this.quote.author}·${this.quote.from}`)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
        .fontSize(ThemeConst.FontSize_14)
        .fontStyle(FontStyle.Italic)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}