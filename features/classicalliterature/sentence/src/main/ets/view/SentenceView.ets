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

@ComponentV2
export struct SnapshotView {
  @Param @Require sentence: Sentence;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    Column() {
      Column() {
        ContentText({ text: this.sentence.content, fontSize: this.fontSize, fontColor: this.fontColor })
        ContentAuthor({ text: this.sentence.from, fontColor: this.fontColor })
      }
    }
    .width('100%')
  }
}