import { Icon, String } from 'constants';
import { readRandomSentence, Sentence } from '../model/Sentence';
import { SentenceView } from '../view/SentenceView';

@Builder
export function SentenceIndexPageBuilder() {
  SentenceIndexPage();
}

@ComponentV2
export struct SentenceIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local sentence: Sentence | null = null;

  aboutToAppear(): void {
    this.refresh()
  }

  refresh() {
    readRandomSentence().then((value: Sentence | null) => {
      this.sentence = value
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.sentence) {
          SentenceView({
            sentence: this.sentence
          })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.classicalliterature_sentence)
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
}
