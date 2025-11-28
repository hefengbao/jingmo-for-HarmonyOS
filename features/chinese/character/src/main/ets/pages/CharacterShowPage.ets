import { String } from 'constants';
import { Character, readCharacterById } from '../model/Character';
import { ShowParam } from '../model/Param';
import { CharacterView } from '../view/CharacterView';

@Builder
export function CharacterShowPageBuilder() {
  CharacterShowPage();
}

@ComponentV2
export struct CharacterShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local character: Character | null = null;

  build() {
    NavDestination() {
      Scroll() {
        if (this.character) {
          CharacterView({ character: this.character })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_character)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ShowParam
      if (param) {
        readCharacterById(param.id).then((character: Character | null) => {
          this.character = character
        })
      }
    })
  }
}
