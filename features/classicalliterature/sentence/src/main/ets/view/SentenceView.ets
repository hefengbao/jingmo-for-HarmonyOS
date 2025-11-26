import { Sentence } from '../model/Sentence';
import { ThemeConst } from 'constants';

@ComponentV2
export struct SentenceView {
  @Param @Require sentence: Sentence

  build() {
    Column() {
      Column() {
        Text(this.sentence.content)
        Text(`—— ${this.sentence.from}`)
          .margin({ top: 16 })
          .fontSize(ThemeConst.FontSize_14)
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .alignItems(HorizontalAlign.Center)
  }
}