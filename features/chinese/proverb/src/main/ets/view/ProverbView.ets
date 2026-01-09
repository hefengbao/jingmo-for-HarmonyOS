import { ContentText } from 'uicomponents';
import { Proverb } from '../model/Proverb';

@ComponentV2
export struct ProverbView {
  @Param @Require proverb: Proverb;

  build() {
    ContentText({ text: this.proverb.content })
  }
}