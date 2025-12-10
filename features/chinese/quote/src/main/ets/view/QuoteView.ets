import { Quote } from '../model/Quote';
import { ContentAuthor, ContentText } from 'uicomponents';

@ComponentV2
export struct QuoteView {
  @Param @Require quote: Quote

  build() {
    Column() {
      ContentText({ text: this.quote.content })
      ContentAuthor({ text: `${this.quote.author}·${this.quote.from}` })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}