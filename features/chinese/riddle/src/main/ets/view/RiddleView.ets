import { ContentText } from 'uicomponents';
import { Riddle } from '../model/Riddle';

@ComponentV2
export struct RiddleView {
  @Param @Require riddle: Riddle;
  @Param showAnswer: boolean = false;

  build() {
    Column({ space: 8 }) {
      ContentText({ text: this.riddle.puzzle })
      if (this.showAnswer) {
        ContentText({text:this.riddle.answer, fontColor: $r('sys.color.ohos_id_color_badge_red')})
      }
    }
  }
}