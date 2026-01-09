import { ParamNumberId, String, ThemeConst } from 'constants';
import { Writing } from '../model/Writing';
import { uiObserver } from '@kit.ArkUI';
import WritingViewModel from '../viewmodel/WritingViewModel';

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local writings: Writing[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'WritingBookmarkPage' && info.state == 4) {
        WritingViewModel.getBookmarks().then((value: Writing[]) => {
          this.writings = value
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
        Repeat<Writing>(this.writings)
          .each((repeatItem: RepeatItem<Writing>) => {
            ListItem() {
              Column() {
                Text(repeatItem.item.Title.Content)
                  .width('100%')
                  .padding(ThemeConst.P_X16_Y8)
                Text(repeatItem.item.Author)
                  .width('100%')
                  .fontSize(14)
                  .padding(ThemeConst.P_X16_Y8)
              }
              .onClick(() => {
                this.pageStack.pushPathByName('WritingShowPage', new ParamNumberId(repeatItem.item.Id))
              })
            }
          })
          .key((item: Writing) => `${item.Id}`)
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