import { ParamNumberId, String, ThemeConst } from 'constants';
import { ModernPoetry } from '../model/ModernPoetry';
import { uiObserver } from '@kit.ArkUI';
import PoetryViewModel from '../viewmodel/PoetryViewModel';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local poetryList: ModernPoetry[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'ModernPoetryBookmarkPage' && info.state == 4) {
        PoetryViewModel.getBookmarks().then((value: ModernPoetry[]) => {
          this.poetryList = value;
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
        ForEach(this.poetryList, (item: ModernPoetry) => {
          ListItem() {
            Column({ space: 8 }) {
              Text(item.title)
                .width('100%')
              Text(item.content)
                .width('100%')
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName("ModernPoetryShowPage", new ParamNumberId(item.id))
            })
          }
        }, (item: ModernPoetry) => item.id.toString())
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