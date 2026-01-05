import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { AntitheticalCouplet, getRandomAntitheticalCouplet } from '../model/AntitheticalCouplet';
import { ContentView } from '../view/ContentView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark } from 'bookmark';
import AntitheticalCoupletViewModel from '../viewmodel/AntitheticalCoupletViewModel';
import { Logger } from 'utils';

let logger: Logger = new Logger('AntitheticalCoupletIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local antitheticalCouplet: AntitheticalCouplet | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh()
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.antitheticalCouplet) {
          ContentView({ antitheticalCouplet: this.antitheticalCouplet })
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_antitheticalcouplet)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("AntitheticalCoupletBookmarkPage", null)
        })
      },
      {
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.antitheticalCouplet) {
            this.pageStack.pushPathByName("AntitheticalCoupletSnapshotPage",
              new ParamNumberId(this.antitheticalCouplet.id))
          }
        })
      },
      {
        value: String.search,
        icon: Icon.ic_public_search,
        action: (() => {
          this.pageStack.pushPathByName("AntitheticalCoupletSearchPage", null)
        })
      }
    ])
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            AntitheticalCoupletViewModel.cancelBookmark(this.antitheticalCouplet?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            AntitheticalCoupletViewModel.addBookmark(this.antitheticalCouplet?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.antitheticalCouplet ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
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

  refresh() {
    getRandomAntitheticalCouplet().then((value: AntitheticalCouplet | undefined) => {
      this.antitheticalCouplet = value
      if (value) {
        AntitheticalCoupletViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value
        })
      }
    })
  }
}
