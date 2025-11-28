import { Icon, String } from 'constants';
import { Character, readRandomCharacter } from '../model/Character';
import { SearchParam } from '../model/Param';
import { CharacterView } from '../view/CharacterView';

@Builder
export function CharacterIndexPageBuilder() {
  CharacterIndexPage();
}

@ComponentV2
export struct CharacterIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local character: Character | null = null;

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
                this.pageStack.pushPathByName('SearchListPage', new SearchParam('char', data))
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
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_character)
    .menus([
      {
        value: "拼音",
        icon: $r('app.media.ic_syllable'),
        action: () => {
          this.pageStack.pushPathByName('SyllablePage', null)
        },
      },
      {
        value: "部首",
        icon: $r('app.media.ic_radical'),
        action: () => {
          this.pageStack.pushPathByName('RadicalPage', null)
        }
      },
      {
        value: "笔画",
        icon: $r('app.media.ic_stroke'),
        action: () => {
          this.pageStack.pushPathByName('StrokePage', null)
        }
      }
    ])
    .toolbarConfiguration([
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
    readRandomCharacter().then((value: Character | null) => {
      this.character = value;
    })
  }
}
