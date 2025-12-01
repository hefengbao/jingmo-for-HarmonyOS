import { ThemeConst } from 'constants';
import { Knowledge } from '../model/Knowledge';

@ComponentV2
export struct KnowledgeView {
  @Param @Require knowledge: Knowledge

  build() {
    Text(this.knowledge.content)
      .width('100%')
      .padding(ThemeConst.P_X16_Y8)
      .lineHeight(24)
  }
}