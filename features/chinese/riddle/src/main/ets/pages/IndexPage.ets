import { Bookmark } from 'bookmark';
import { Icon, String } from 'constants';
import { Logger } from 'utils';
import { Riddle } from '../model/Riddle';
import { RiddleView } from '../view/RiddleView';
import RiddleViewModel from '../viewmodel/RiddleViewModel';

let logger: Logger = new Logger('RiddleIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local riddle: Riddle | undefined;
  @Local bookmarked: Bookmark | undefined;
  @Local showAnswer: boolean = false;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.riddle) {
          RiddleView({ riddle: this.riddle, showAnswer: this.showAnswer })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_riddle)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("RiddleBookmarkPage", null)
        })
      },
      {
        value: String.search,
        icon: Icon.ic_public_search,
        action: (() => {
          this.pageStack.pushPathByName("RiddleSearchPage", null)
        })
      }
    ])
    .toolbarConfiguration([
      {
        "value": this.showAnswer ? String.hide_answer : String.show_answer,
        "icon": this.showAnswer ? Icon.ic_public_password_invisible : Icon.ic_public_password_visible,
        "action": () => {
          this.showAnswer = !this.showAnswer;
        }
      },
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            RiddleViewModel.cancelBookmark(this.riddle?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            RiddleViewModel.addBookmark(this.riddle?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.riddle ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
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
      this.pageStack = ctx.pathStack
    })
  }

  refresh() {
    RiddleViewModel.getRandomRiddle().then((value: Riddle | undefined) => {
      this.riddle = value;
      this.showAnswer = false;
      if (value) {
        RiddleViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}