import { Icon, String } from 'constants';
import { Knowledge, readRandomKnowledge } from '../model/Knowledge';
import { KnowledgeView } from '../view/KnowledgeView';

@Builder
export function KnowledgeIndexPageBuilder() {
  KnowledgeIndexPage();
}

@ComponentV2
export struct KnowledgeIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local knowledge: Knowledge | null = null;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.knowledge) {
          KnowledgeView({ knowledge: this.knowledge })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_knowledge)
    .toolbarConfiguration([
      {
        "value": String.refresh,
        "icon": Icon.ic_public_refresh,
        "action": () => {
          this.refresh()
        }
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }

  refresh() {
    readRandomKnowledge().then((value: Knowledge | null) => {
      this.knowledge = value;
    })
  }
}
