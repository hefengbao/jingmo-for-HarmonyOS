import { Idiom, IdiomQuote, IdiomSource } from '../model/Idiom';
import { BoldTitle } from 'uicomponents';
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
      Text(this.idiom.word)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
      if (this.idiom.explanation) {
        BoldTitle({ text: '释义' })
        Text(this.idiom.explanation)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.idiom.source) {
        BoldTitle({ text: '出处' })
        Text(this.parseSource(this.idiom.source))
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.idiom.quote) {
        BoldTitle({ text: '名著引用' })
        Text(this.parseQuote(this.idiom.quote))
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.idiom.story) {
        BoldTitle({ text: '成语故事' })
        ForEach(this.idiom.story, ((item: string) => {
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