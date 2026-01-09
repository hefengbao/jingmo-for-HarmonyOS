import { ParamNumberId, String, ThemeConst } from 'constants';
import { Riddle } from '../model/Riddle';
import { uiObserver } from '@kit.ArkUI';
import RiddleViewModel from '../viewmodel/RiddleViewModel';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local riddleList: Riddle[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'RiddleBookmarkPage' && info.state == 4) {
        RiddleViewModel.getBookmarks().then((value: Riddle[]) => {
          this.riddleList = value;
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
        ForEach(this.riddleList, (item: Riddle) => {
          ListItem() {
            Column({ space: 8 }) {
              Text(item.puzzle)
                .width('100%')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName("RiddleShowPage", new ParamNumberId(item.id))
            })
          }
        }, (item: Riddle) => item.id.toString())
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