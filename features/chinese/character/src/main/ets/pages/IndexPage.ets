import { AvoidAreaObserver, Icon, String } from 'constants';
import { Character, getRandomCharacter } from '../model/Character';
import { SearchParam } from '../model/Param';
import { CharacterView } from '../view/CharacterView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark } from 'bookmark';
import CharacterViewModel from '../viewmodel/CharacterViewModel';
import { Logger } from 'utils';

let logger: Logger = new Logger('CharacterIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local character: Character | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Row() {
            Search({
              placeholder: '请输入单个汉字查询'
            })
              .searchButton('查询')
              .onSubmit((data: string) => {
                this.pageStack.pushPathByName('CharacterSearchListPage', new SearchParam('char', data))
              })
          }
          .padding(16)

          if (this.character) {
            CharacterView({ character: this.character })
          }
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
    .menus([
      {
        value: "拼音",
        icon: $r('app.media.ic_syllable'),
        action: () => {
          this.pageStack.pushPathByName('CharacterSyllablePage', null)
        },
      },
      {
        value: "部首",
        icon: $r('app.media.ic_radical'),
        action: () => {
          this.pageStack.pushPathByName('CharacterRadicalPage', null)
        }
      },
      {
        value: "笔画",
        icon: $r('app.media.ic_stroke'),
        action: () => {
          this.pageStack.pushPathByName('CharacterStrokePage', null)
        }
      },
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("CharacterBookmarkPage", null)
        })
      }
    ])
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
    getRandomCharacter().then((value: Character | undefined) => {
      this.character = value;
      if (value) {
        CharacterViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}
