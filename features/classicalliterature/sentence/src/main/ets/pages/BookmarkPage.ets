import { ParamNumberId, String, ThemeConst } from 'constants';
import { getBookmarks, Sentence } from '../model/Sentence';
import { uiObserver } from '@kit.ArkUI';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local sentences: Sentence[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'SentenceBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: Sentence[]) => {
          this.sentences = value
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
        Repeat<Sentence>(this.sentences)
          .each((repeatItem: RepeatItem<Sentence>) => {
            ListItem() {
              Text(repeatItem.item.content)
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
                  this.pageStack.pushPathByName('SentenceShowPage', new ParamNumberId(repeatItem.item.id))
                })
            }
          })
          .key((item: Sentence) => `${item.id}`)
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider({ strokeWidth: 2 })
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}