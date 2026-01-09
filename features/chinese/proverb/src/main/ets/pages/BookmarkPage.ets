import { ParamNumberId, String, ThemeConst } from 'constants';
import { Proverb } from '../model/Proverb';
import { uiObserver } from '@kit.ArkUI';
import ProverbViewModel from '../viewmodel/ProverbViewModel';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local proverbList: Proverb[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'ProverbBookmarkPage' && info.state == 4) {
        ProverbViewModel.getBookmarks().then((value: Proverb[]) => {
          this.proverbList = value;
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
        ForEach(this.proverbList, (item: Proverb) => {
          ListItem() {
            Column({ space: 8 }) {
              Text(item.content)
                .width('100%')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName("ProverbShowPage", new ParamNumberId(item.id))
            })
          }
        }, (item: Proverb) => item.id.toString())
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