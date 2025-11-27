import { Expression } from '../model/Expression';
import { IdiomQuote, IdiomSource } from 'chinese_idiom';
import { BoldTitle } from 'uicomponents';
import { ThemeConst } from 'constants';

@ComponentV2
export struct ExpressionView {
  @Param @Require expression: Expression

  build() {
    Column() {
      Text(this.expression.pinyin)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
        .fontSize(12)
      Text(this.expression.word)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
      if (this.expression.explanation) {
        BoldTitle({ text: '释义' })
        Text(this.expression.explanation)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.expression.source) {
        BoldTitle({ text: '出处' })
        Text(this.parseSource(this.expression.source))
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.expression.quote) {
        BoldTitle({ text: '名著引用' })
        Text(this.parseQuote(this.expression.quote))
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.expression.story) {
        BoldTitle({ text: '成语故事' })
        ForEach(this.expression.story, ((item: string) => {
          Text(item)
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
        }))
      }
    }
    .width('100%')
  }

  parseSource(source: IdiomSource): string {
    let txt = '';
    if (source.text) {
      txt += source.text;
    }
    if (source.book) {
      txt += ' ——' + source.book
    }

    return txt;
  }

  parseQuote(quote: IdiomQuote): string {
    let txt = '';
    if (quote.text) {
      txt += quote.text;
    }
    if (quote.book) {
      txt += ' ——' + quote.book
    }

    return txt;
  }
}