import { ParamNumberId, String, ThemeConst } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import WisecrackViewModel from '../viewmodel/WisecrackViewModel';
import { Wisecrack } from '../model/Wisecrack';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local wisecrackList: Wisecrack[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'WisecrackBookmarkPage' && info.state == 4) {
        WisecrackViewModel.getBookmarks().then((value: Wisecrack[]) => {
          this.wisecrackList = value;
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
        ForEach(this.wisecrackList, (item: Wisecrack) => {
          ListItem() {
            Column({ space: 8 }) {
              Text(item.riddle)
                .width('100%')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName("WisecrackShowPage", new ParamNumberId(item.id))
            })
          }
        }, (item: Wisecrack) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider(ThemeConst.ListDivider)
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}