import { ContentText } from 'uicomponents';
import { Wisecrack } from '../model/Wisecrack';

@ComponentV2
export struct WisecrackView {
  @Param @Require wisecrack: Wisecrack;

  build() {
    Column({ space: 8 }) {
      ContentText({ text: this.wisecrack.riddle })
      ContentText({ text: `——${this.wisecrack.answer}` })
    }
  }
}