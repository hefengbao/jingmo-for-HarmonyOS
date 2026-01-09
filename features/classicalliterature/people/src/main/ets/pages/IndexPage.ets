import { Bookmark } from 'bookmark';
import { Icon, String } from 'constants';
import { Logger } from 'utils';
import { People } from '../model/People';
import { PeopleView } from '../view/PeopleView';
import PeopleViewModel from '../viewmodel/PeopleViewModel';

let logger: Logger = new Logger('PeopleIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local people: People | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.people) {
          PeopleView({ people: this.people })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.classicalliterature_people)
    .menus([
      /*{
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("PeopleBookmarkPage", null)
        })
      },*/
      {
        value: String.search,
        icon: Icon.ic_public_search,
        action: (() => {
          this.pageStack.pushPathByName("PeopleSearchPage", null)
        })
      }
    ])
    .toolbarConfiguration([
      /*{
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            PeopleViewModel.cancelBookmark(this.people?.Id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            PeopleViewModel.addBookmark(this.people?.Id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.people ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      },*/
      {
        "value": String.refresh,
        "icon": Icon.ic_public_refresh,
        "action": () => {
          this.refresh()
        }
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }

  refresh() {
    PeopleViewModel.getRandomPeople().then((value: People | undefined) => {
      this.people = value;
      if (value) {
        PeopleViewModel.getBookmark(value.Id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}