import { Knowledge } from '../model/Knowledge';
import { ContentText } from 'uicomponents';

@ComponentV2
export struct KnowledgeView {
  @Param @Require knowledge: Knowledge

  build() {
    ContentText({ text: this.knowledge.content })
  }
}

@ComponentV2
export struct SnapshotView {
  @Param @Require knowledge: Knowledge;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    ContentText({ text: this.knowledge.content, fontSize: this.fontSize, fontColor: this.fontColor })
  }
}