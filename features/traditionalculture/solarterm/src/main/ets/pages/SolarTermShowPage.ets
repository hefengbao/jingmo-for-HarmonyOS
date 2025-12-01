import { ParamNumberId, ThemeConst } from 'constants';
import { getSolarTermList, SolarTerm } from '../model/SolarTerm';
import { BoldTitle } from 'uicomponents';

@Builder
export function SolarTermShowPageBuilder() {
  SolarTermShowPage()
}

@ComponentV2
export struct SolarTermShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local solarterm: SolarTerm | undefined;

  build() {
    NavDestination() {
      if (this.solarterm) {
        Scroll() {
          Column() {
            if (this.solarterm.alias) {
              BoldTitle({ text: '别名' })
              Text(this.solarterm.alias)
                .width('100%')
                .padding(ThemeConst.P_X16_Y8)
                .textAlign(TextAlign.Start)
            }
            BoldTitle({ text: '介绍' })
            Text(this.solarterm.desc)
              .width('100%')
              .padding(ThemeConst.P_X16_Y8)
              .textAlign(TextAlign.Start)
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .height('100%')
        .edgeEffect(EdgeEffect.Spring)
        .align(Alignment.TopStart)
      }
    }
    .title(this.solarterm?.name)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId
      if (param) {
        this.solarterm = getSolarTermList().find((item: SolarTerm) => param.id == item.id)
      }
    })
  }
}
