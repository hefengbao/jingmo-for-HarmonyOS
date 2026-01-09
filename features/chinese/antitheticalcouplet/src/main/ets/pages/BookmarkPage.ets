import { ParamNumberId, String, ThemeConst } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import { AntitheticalCouplet, getBookmarks } from '../model/AntitheticalCouplet';

;

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local antitheticalCouplets: AntitheticalCouplet[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'AntitheticalCoupletBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: AntitheticalCouplet[]) => {
          this.antitheticalCouplets = value
        }).catch((error: BusinessError) => {
        })
      }
    });
  }

  aboutToDisappear() {
    uiObserver.off('navDestinationUpdate');
  }

  build() {
    NavDestination() {
      List() {
        Repeat<AntitheticalCouplet>(this.antitheticalCouplets)
          .each((repeatItem: RepeatItem<AntitheticalCouplet>) => {
            ListItem() {
              Text(repeatItem.item.body)
                .width('100%')
                .padding(ThemeConst.P_16)
                .stateStyles({
                  normal: {
                    .backgroundColor(ThemeConst.BackGroundColor_Normal)
                  },
                  pressed: {
                    .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                  }
                })
                .onClick(() => {
                  this.pageStack.pushPathByName('AntitheticalCoupletShowPage', new ParamNumberId(repeatItem.item.id))
                })
            }
          })
          .key((item: AntitheticalCouplet) => `${item.id}`)
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider(ThemeConst.ListDivider)
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}