import { Expression } from '../model/Expression';
import { IdiomQuote, IdiomSource } from 'chinese_idiom';
import { BoldTitle, ContentText } from 'uicomponents';
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
      ContentText({ text: this.expression.word })

      if (this.expression.explanation) {
        BoldTitle({ text: '释义' })
        ContentText({ text: this.expression.explanation })
      }

      if (this.expression.source) {
        BoldTitle({ text: '出处' })
        ContentText({ text: this.parseSource(this.expression.source) })
      }

      if (this.expression.quote) {
        BoldTitle({ text: '名著引用' })
        ContentText({ text: this.parseQuote(this.expression.quote) })
      }

      if (this.expression.story) {
        BoldTitle({ text: '成语故事' })
        ForEach(this.expression.story, ((item: string) => {
          ContentText({ text: item })
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