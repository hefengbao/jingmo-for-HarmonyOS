import { Knowledge } from '../model/Knowledge';
import { ContentText } from 'uicomponents';

@ComponentV2
export struct KnowledgeView {
  @Param @Require knowledge: Knowledge

  build() {
    ContentText({ text: this.knowledge.content })
  }
}