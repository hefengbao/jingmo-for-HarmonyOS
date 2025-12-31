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

@ComponentV2
export struct SnapshotView {
  @Param @Require quote: Quote;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    Column() {
      ContentText({ text: this.quote.content, fontSize: this.fontSize, fontColor: this.fontColor })
      ContentAuthor({
        text: `${this.quote.author}·${this.quote.from}`,
        fontSize: this.fontSize,
        fontColor: this.fontColor
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}