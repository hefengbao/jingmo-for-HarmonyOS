import { ParamNumberId, String, ThemeConst } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import { getBookmarks, Quote } from '../model/Quote';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local quotes: Quote[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'QuoteBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: Quote[]) => {
          this.quotes = value
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
        Repeat<Quote>(this.quotes)
          .each((repeatItem: RepeatItem<Quote>) => {
            ListItem() {
              Text(repeatItem.item.content)
                .width('100%')
                .padding(ThemeConst.P_16)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .stateStyles({
                  normal: {
                    .backgroundColor(ThemeConst.BackGroundColor_Normal)
                  },
                  pressed: {
                    .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                  }
                })
                .onClick(() => {
                  this.pageStack.pushPathByName('QuoteShowPage', new ParamNumberId(repeatItem.item.id))
                })
            }
            .width('100%')
          })
          .key((item: Quote) => `${item.id}`)
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