import { Sentence } from '../model/Sentence';
import { ContentAuthor, ContentText } from 'uicomponents';

@ComponentV2
export struct SentenceView {
  @Param @Require sentence: Sentence

  build() {
    Column() {
      Column() {
        ContentText({ text: this.sentence.content })
        ContentAuthor({ text: this.sentence.from })
      }
    }
    .width('100%')
  }
}