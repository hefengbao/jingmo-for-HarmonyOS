import { ParamNumberId, ThemeConst } from 'constants';
import { Festival, getFestivalList } from '../model/Festival';
import { BoldTitle } from 'uicomponents';

@Builder
export function FestivalShowPageBuilder() {
  FestivalShowPage()
}

@ComponentV2
export struct FestivalShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local festival: Festival | undefined = undefined;

  build() {
    NavDestination() {
      if (this.festival != undefined) {
        Scroll() {
          Column() {
            BoldTitle({ text: '名称' })
            Text(this.festival.name)
              .width('100%')
              .padding(ThemeConst.P_X16_Y8)
            BoldTitle({ text: '别名' })
            Text(this.festival.alias)
              .padding(ThemeConst.P_X16_Y8)
              .width('100%')
            BoldTitle({ text: '简介' })
            Text(this.festival.desc)
              .padding(ThemeConst.P_X16_Y8)
              .width('100%')
              .textAlign(TextAlign.Start)
          }
        }
        .width('100%')
        .height('100%')
        .edgeEffect(EdgeEffect.Spring)
        .align(Alignment.TopStart)
      }
    }
    .title(this.festival?.name)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId
      if (param) {
        this.festival = getFestivalList().find((item: Festival) => item.id == param.id)
      }
    })
  }
}
