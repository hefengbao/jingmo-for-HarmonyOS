import { ClassicPoem, getRandomClassicPoem } from '../model/ClassicPoem';
import { AvoidAreaObserver, Icon, PrefConst, String } from 'constants';
import { ClassicPoemView } from '../view/ContentView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark, cancelBookmark, getBookmark } from 'bookmark';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'utils';
import ClassicPoemViewModel from '../viewmodel/ClassicPoemViewModel';

let logger: Logger = new Logger('ClassicPoemIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local classicPoem: ClassicPoem | undefined;
  @Local bookmarked: Bookmark | undefined

  aboutToAppear(): void {
    this.refresh()
  }

  refresh() {
    getRandomClassicPoem().then(async (value: ClassicPoem | undefined) => {
      this.classicPoem = value;

      if (value) {
        getBookmark(value.id, PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
          .then((value: Bookmark | undefined) => {
            this.bookmarked = value;
          })
      }
    })
  }

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
    .title(String.classicalliterature_classicpoem)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("ClassicPoemBookmarkPage", null)
        })
      }
    ])
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
}
