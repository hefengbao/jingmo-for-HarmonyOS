import { Bookmark } from 'bookmark';
import { Icon, ParamNumberId, String } from 'constants';
import { Logger } from 'utils';
import { Writing } from '../model/Writing';
import { WritingView } from '../view/WritingView';
import WritingViewModel from '../viewmodel/WritingViewModel';

let logger: Logger = new Logger("WritingShowPage");

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local writing: Writing | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.writing) {
          WritingView({
            writing: this.writing
          })
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
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.writing) {
            this.pageStack.pushPathByName("WritingSnapshotPage", new ParamNumberId(this.writing.Id))
          }
        })
      },
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
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        WritingViewModel.getWriting(param.id).then((value: Writing | undefined) => {
          this.writing = value;
        })

        WritingViewModel.getBookmark(param.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}