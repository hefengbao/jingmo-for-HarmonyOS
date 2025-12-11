import { ParamNumberId, String, ThemeConst } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import { Character, getBookmarks } from '../model/Character';
import { Logger } from 'utils';

let logger: Logger = new Logger('CharacterBookmarkPage');

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local characters: Character[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'CharacterBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: Character[]) => {
          this.characters = value
          logger.info(`characters count = ${value.length}`)
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
      Grid() {
        Repeat<Character>(this.characters)
          .each((repeatItem: RepeatItem<Character>) => {
            GridItem() {
              Column() {
                Text(repeatItem.item.pinyin)
                  .width('100%')
                  .padding({ top: 8, bottom: 4 })
                  .textAlign(TextAlign.Center)
                  .fontSize(ThemeConst.FontSize_14)
                Text(repeatItem.item.character)
                  .width('100%')
                  .padding({ top: 4, bottom: 8 })
                  .textAlign(TextAlign.Center)
              }
              .stateStyles({
                normal: {
                  .backgroundColor(ThemeConst.BackGroundColor_Normal)
                },
                pressed: {
                  .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                }
              })
              .onClick(() => {
                this.pageStack.pushPathByName('CharacterShowPage', new ParamNumberId(repeatItem.item.id))
              })
            }
          })
          .key((item: Character) => `${item.id}`)
      }
      .width('100%')
      .height('100%')
      .columnsTemplate('1fr 1fr 1fr')
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}