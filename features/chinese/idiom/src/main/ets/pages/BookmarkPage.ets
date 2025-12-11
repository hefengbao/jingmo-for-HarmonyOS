import { ParamNumberId, String, ThemeConst } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import { getBookmarks, Idiom } from '../model/Idiom';
import { Logger } from 'utils';

let logger: Logger = new Logger('IdiomBookmarkPage');

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local idioms: Idiom[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'IdiomBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: Idiom[]) => {
          this.idioms = value;
          logger.info(`idioms count = ${value.length}`)
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
        Repeat<Idiom>(this.idioms)
          .each((repeatItem: RepeatItem<Idiom>) => {
            ListItem() {
              Text(repeatItem.item.word)
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
                  this.pageStack.pushPathByName('IdiomShowPage', new ParamNumberId(repeatItem.item.id))
                })
            }
          })
          .key((item: Idiom) => `${item.id}`)
      }
      .width('100$')
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