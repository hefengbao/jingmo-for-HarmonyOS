import { ParamNumberId, String, ThemeConst } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import { Expression, getBookmarks } from '../model/Expression';
n';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local expressions: Expression[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'ExpressionBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: Expression[]) => {
          this.expressions = value
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
        Repeat<Expression>(this.expressions)
          .each((repeatItem: RepeatItem<Expression>) => {
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
                  this.pageStack.pushPathByName('ExpressionShowPage', new ParamNumberId(repeatItem.item.id))
                })
            }
          })
          .key((item: Expression) => `${item.id}`)
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