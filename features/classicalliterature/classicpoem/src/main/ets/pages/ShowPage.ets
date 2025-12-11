import { ClassicPoem, getClassicPoem } from '../model/ClassicPoem';
import { AvoidAreaObserver, Icon, ParamNumberId, PrefConst, String } from 'constants';
import { ClassicPoemView } from '../view/ContentView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark, getBookmark } from 'bookmark';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'utils';
import ClassicPoemViewModel from '../viewmodel/ClassicPoemViewModel';

let logger: Logger = new Logger('ClassicPoemShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local classicPoem: ClassicPoem | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.classicPoem) {
          ClassicPoemView({
            classicPoem: this.classicPoem
          })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
    }
    .title(String.bookmark)
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            ClassicPoemViewModel.cancelBookmark(this.classicPoem?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            ClassicPoemViewModel.addBookmark(this.classicPoem?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.classicPoem ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      },
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
      let param = ctx.pathInfo.param as ParamNumberId
      if (param) {
        getClassicPoem(param.id)
          .then((value: ClassicPoem | undefined) => {
            this.classicPoem = value
          })
        getBookmark(param.id, PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
          .then((value: Bookmark | undefined) => {
            this.bookmarked = value;
          })
      }
    })
  }
}
