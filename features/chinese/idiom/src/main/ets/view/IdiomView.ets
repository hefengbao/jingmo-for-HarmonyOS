import { Idiom, IdiomQuote, IdiomSource } from '../model/Idiom';
import { BoldTitle, ContentText } from 'uicomponents';
import { ThemeConst } from 'constants';

@ComponentV2
export struct IdiomView {
  @Param @Require idiom: Idiom

  build() {
    Column() {
      Text(this.idiom.pinyin)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
        .fontSize(12)
      ContentText({ text: this.idiom.word })

      if (this.idiom.explanation) {
        BoldTitle({ text: '释义' })
        ContentText({ text: this.idiom.explanation })
      }

      if (this.idiom.source) {
        BoldTitle({ text: '出处' })
        ContentText({ text: this.parseSource(this.idiom.source) })
      }

      if (this.idiom.quote) {
        BoldTitle({ text: '名著引用' })
        ContentText({ text: this.parseQuote(this.idiom.quote) })
      }

      if (this.idiom.story) {
        BoldTitle({ text: '成语故事' })
        ForEach(this.idiom.story, ((item: string) => {
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