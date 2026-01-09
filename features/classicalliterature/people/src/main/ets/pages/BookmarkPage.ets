import { ParamNumberId, String } from 'constants';
import { uiObserver } from '@kit.ArkUI';
import PeopleViewModel from '../viewmodel/PeopleViewModel';
import { People } from '../model/People';
import { Logger } from 'utils';

let logger: Logger = new Logger('')

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage();
}

@ComponentV2
export struct BookmarkPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local Peoples: People[] = []

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'PeopleBookmarkPage' && info.state == 4) {
        /*PeopleViewModel.getBookmarks().then((value: People[]) => {
          this.Peoples = value
          logger.info(`getBookmarks successful, count = ${value.length}`)
        }).catch((error: BusinessError) => {
          logger.error(`getBookmarks failed, code = ${error.code}, message = ${error.message}`)
        })*/
      }
    });
  }

  aboutToDisappear() {
    uiObserver.off('navDestinationUpdate');
  }

  build() {
    NavDestination() {
      List() {
        Repeat<People>(this.Peoples)
          .each((repeatItem: RepeatItem<People>) => {
            ListItem() {
              Column() {

              }.onClick(() => {
                this.pageStack.pushPathByName('PeopleShowPage', new ParamNumberId(repeatItem.item.Id))
              })
            }
          })
          .key((item: People) => `${item.Id}`)
      }
      .width('100%')
      .height('100%')
      .divider({ strokeWidth: 2 })
      .edgeEffect(EdgeEffect.Spring)
      .alignListItem(ListItemAlign.Start)
      .align(Alignment.TopStart)
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}