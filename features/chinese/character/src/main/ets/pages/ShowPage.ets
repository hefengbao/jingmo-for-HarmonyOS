import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { Character, getCharacter } from '../model/Character';
import { CharacterView } from '../view/CharacterView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark } from 'bookmark';
import CharacterViewModel from '../viewmodel/CharacterViewModel';
import { Logger } from 'utils';
';

let logger: Logger = new Logger('CharacterShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local character: Character | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.character) {
          CharacterView({ character: this.character })
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_character)
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            CharacterViewModel.cancelBookmark(this.character?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            CharacterViewModel.addBookmark(this.character?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.character ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      },
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId
      if (param) {
        getCharacter(param.id).then((character: Character | undefined) => {
          this.character = character;
          if (character) {
            CharacterViewModel.getBookmark(character.id).then((value: Bookmark | undefined) => {
              this.bookmarked = value;
            })
          }
        })
      }
    })
  }
}
