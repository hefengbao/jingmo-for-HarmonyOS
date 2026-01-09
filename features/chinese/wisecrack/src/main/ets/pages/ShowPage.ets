import { Bookmark } from 'bookmark';
import { Icon, ParamNumberId, String } from 'constants';
import { Logger } from 'utils';
import { Wisecrack } from '../model/Wisecrack';
import { WisecrackView } from '../view/WisecrackView';
import WisecrackViewModel from '../viewmodel/WisecrackViewModel';

let logger: Logger = new Logger('WisecrackShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local wisecrack: Wisecrack | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.wisecrack) {
          WisecrackView({ wisecrack: this.wisecrack })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_wisecrack)
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            WisecrackViewModel.cancelBookmark(this.wisecrack?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            WisecrackViewModel.addBookmark(this.wisecrack?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.wisecrack ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;

      if (param) {
        WisecrackViewModel.getWisecrack(param.id).then((value: Wisecrack | undefined) => {
          this.wisecrack = value;
          if (value) {
            WisecrackViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
              this.bookmarked = value;
            })
          }
        })
      }
    })
  }
}