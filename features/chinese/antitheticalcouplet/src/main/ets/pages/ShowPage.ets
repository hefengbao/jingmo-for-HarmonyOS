import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { AntitheticalCouplet, getAntitheticalCouplet } from '../model/AntitheticalCouplet';
import { ContentView } from '../view/ContentView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark } from 'bookmark';
import AntitheticalCoupletViewModel from '../viewmodel/AntitheticalCoupletViewModel';
import { Logger } from 'utils';

let logger: Logger = new Logger('AntitheticalCoupletIndexPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local antitheticalCouplet: AntitheticalCouplet | undefined;
  @Local bookmarked: Bookmark | undefined;

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
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.antitheticalCouplet) {
            this.pageStack.pushPathByName("AntitheticalCoupletSnapshotPage",
              new ParamNumberId(this.antitheticalCouplet.id))
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
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        getAntitheticalCouplet(param.id).then((value: AntitheticalCouplet | undefined) => {
          this.antitheticalCouplet = value;
        })
        AntitheticalCoupletViewModel.getBookmark(param.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}
