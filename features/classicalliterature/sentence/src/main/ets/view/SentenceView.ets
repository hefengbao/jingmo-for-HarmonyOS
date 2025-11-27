import { Sentence } from '../model/Sentence';
import { ThemeConst } from 'constants';

@ComponentV2
export struct SentenceView {
  @Param @Require sentence: Sentence

  build() {
    Column() {
      Column() {
        Text(this.sentence.content)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
        Text(`—— ${this.sentence.from}`)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
          .fontSize(ThemeConst.FontSize_14)
          .fontStyle(FontStyle.Italic)
      }
    }
    .width('100%')
  }
}