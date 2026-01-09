import { Bookmark } from 'bookmark';
import { Icon, ParamNumberId, String } from 'constants';
import { Logger } from 'utils';
import { ModernPoetry } from '../model/ModernPoetry';
import { PoetryView } from '../view/PoetryView';
import PoetryViewModel from '../viewmodel/PoetryViewModel';

let logger: Logger = new Logger('ModernPoetryShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local poetry: ModernPoetry | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.poetry) {
          PoetryView({ poetry: this.poetry })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_modernpoetry)
    .menus([
      {
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.poetry) {
            this.pageStack.pushPathByName("ModernPoetrySnapshotPage", new ParamNumberId(this.poetry.id))
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
            PoetryViewModel.cancelBookmark(this.poetry?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            PoetryViewModel.addBookmark(this.poetry?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.poetry ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;

      if (param) {
        PoetryViewModel.getPoetry(param.id).then((value: ModernPoetry | undefined) => {
          this.poetry = value;
          if (value) {
            PoetryViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
              this.bookmarked = value;
            })
          }
        })
      }
    })
  }
}