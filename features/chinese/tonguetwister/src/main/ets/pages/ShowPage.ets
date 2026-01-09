import { ParamNumberId, String, ThemeConst } from 'constants';
import { getTongueTwister, TongueTwister } from '../model/TongueTwister';

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@Extend(Text)
function basicText() {
  .padding(ThemeConst.P_X16_Y8)
  .lineHeight('150%')
}

@ComponentV2
export struct ShowPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local tongueTwister: TongueTwister | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.tongueTwister) {
          Column({ space: 8 }) {
            Text(this.tongueTwister.title)
              .basicText()
            Text(this.tongueTwister.content)
              .basicText()
          }
        }
      }
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_tonguetwister)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        getTongueTwister(param.id).then((value: TongueTwister | undefined) => {
          this.tongueTwister = value
        })
      }
    })
  }
}