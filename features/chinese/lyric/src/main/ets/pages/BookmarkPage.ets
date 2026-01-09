import { ParamNumberId, String, ThemeConst } from 'constants';
import { getBookmarks, Lyric } from '../model/Lyric';
import { uiObserver } from '@kit.ArkUI';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local lyrics: Lyric[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'LyricBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: Lyric[]) => {
          this.lyrics = value;
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
        ForEach(this.lyrics, (item: Lyric) => {
          ListItem(){
            Column({space: 16}){
              Text(item.title)
                .width('100%')
              Text(item.content)
                .width('100%')
                .maxLines(3)
                .textOverflow({overflow:TextOverflow.Ellipsis})
            }
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName('LyricShowPage', new ParamNumberId(item.id))
            })
          }
        }, (item: Lyric) => item.id.toString())
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