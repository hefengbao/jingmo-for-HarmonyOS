import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { getRandomIdiom, Idiom } from '../model/Idiom';
import { IdiomView } from '../view/IdiomView';
import { AppStorageV2 } from '@kit.ArkUI';
import IdiomViewModel from '../viewmodel/IdiomViewModel';
import { Bookmark } from 'bookmark';
import { Logger } from 'utils';

let logger: Logger = new Logger('IdiomIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local idiom: Idiom | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.idiom) {
          IdiomView({ idiom: this.idiom })
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
    .title(String.chinese_idiom)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("IdiomBookmarkPage", null)
        })
      },
      {
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.idiom) {
            this.pageStack.pushPathByName("IdiomSnapshotPage", new ParamNumberId(this.idiom.id))
          }
        })
      },
      {
        value: String.search,
        icon: Icon.ic_public_search,
        action: (() => {
          this.pageStack.pushPathByName("IdiomSearchPage", null)
        })
      }

    ])
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            IdiomViewModel.cancelBookmark(this.idiom?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            IdiomViewModel.addBookmark(this.idiom?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.idiom ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
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
    getRandomIdiom().then((value: Idiom | undefined) => {
      this.idiom = value;
      if (value) {
        IdiomViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}
