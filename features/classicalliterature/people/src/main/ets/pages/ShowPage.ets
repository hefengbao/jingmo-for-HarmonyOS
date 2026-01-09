import { ParamNumberId, String } from 'constants';
import { People } from '../model/People';
import { PeopleView } from '../view/PeopleView';
import PeopleViewModel from '../viewmodel/PeopleViewModel';

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local people: People | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.people) {
          PeopleView({
            people: this.people
          })
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
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.people) {
            this.pageStack.pushPathByName("PeopleSnapshotPage", new ParamNumberId(this.people.id))
          }
        })
      },*/
    ])
    .toolbarConfiguration([
      /*{
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            PeopleViewModel.cancelBookmark(this.people?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            PeopleViewModel.addBookmark(this.people?.id)
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
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
      let param = ctx.pathInfo.param as ParamNumberId
      if (param) {
        PeopleViewModel.getPeople(param.id)
          .then((value: People | undefined) => {
            this.people = value
          })
      }
    })
  }
}