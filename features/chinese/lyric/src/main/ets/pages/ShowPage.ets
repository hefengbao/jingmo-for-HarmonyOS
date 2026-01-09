import { Bookmark } from 'bookmark';
import { Icon, ParamNumberId, String } from 'constants';
import { Logger } from 'utils';
import { Lyric } from '../model/Lyric';
import { LyricView } from '../view/LyricView';
import LyricViewModel from '../viewmodel/LyricViewModel';

let logger = new Logger('LyricShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local lyric: Lyric | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.lyric){
          LyricView({lyric:this.lyric})
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_lyric)
    .menus([
      {
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.lyric) {
            this.pageStack.pushPathByName("LyricSnapshotPage", new ParamNumberId(this.lyric.id))
          }
        })
      }
    ])
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            LyricViewModel.cancelBookmark(this.lyric?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            LyricViewModel.addBookmark(this.lyric?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.lyric ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;

      if (param) {
        LyricViewModel.getLyric(param.id).then((value: Lyric | undefined) => {
          this.lyric = value;
          if (value) {
            LyricViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
              this.bookmarked = value;
            })
          }
        })
      }
    })
  }
}