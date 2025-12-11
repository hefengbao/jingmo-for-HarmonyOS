import { AvoidAreaObserver, Icon, String } from 'constants';
import { getRandomSentence, Sentence } from '../model/Sentence';
import { SentenceView } from '../view/SentenceView';
import { AppStorageV2 } from '@kit.ArkUI';
import SentenceViewModel from '../viewmodel/SentenceViewModel';
import { Bookmark } from 'bookmark';
import { Logger } from 'utils';

let logger: Logger = new Logger('SentenceIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local sentence: Sentence | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh()
  }

  refresh() {
    getRandomSentence().then((value: Sentence | undefined) => {
      this.sentence = value;
      if (value) {
        SentenceViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
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
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.classicalliterature_sentence)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("SentenceBookmarkPage", null)
        })
      }
    ])
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            SentenceViewModel.cancelBookmark(this.sentence?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            SentenceViewModel.addBookmark(this.sentence?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.sentence ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      },
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
