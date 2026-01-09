import { Bookmark } from 'bookmark';
import { Icon, ParamNumberId, String } from 'constants';
import { getRandomNumber, Logger } from 'utils';
import { getWriting, Writing } from '../model/Writing';
import WritingViewModel from '../viewmodel/WritingViewModel';
import { WritingView } from '../view/WritingView';

let logger: Logger = new Logger("WritingIndexPage");

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local writing: Writing | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh()
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.writing) {
          WritingView({ writing: this.writing })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.classicalliterature_writing)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("WritingBookmarkPage", null)
        })
      },
      {
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.writing) {
            this.pageStack.pushPathByName("WritingSnapshotPage", new ParamNumberId(this.writing.Id))
          }
        })
      },
      {
        value: String.search,
        icon: Icon.ic_public_search,
        action: (() => {
          this.pageStack.pushPathByName("WritingSearchPage", null)
        })
      }
    ])
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            WritingViewModel.cancelBookmark(this.writing?.Id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            WritingViewModel.addBookmark(this.writing?.Id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.writing ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
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
    let randomId = getRandomNumber(1, 1000000);
    logger.info(`randomId = ${randomId}`)
    getWriting(randomId).then((value: Writing | undefined) => {
      this.writing = value;
      logger.info(`getWriting = ${JSON.stringify(value)}`)
      if (value) {
        WritingViewModel.getBookmark(value.Id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}