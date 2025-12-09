import { ParamNumberId, String, ThemeConst } from 'constants';
import { getSolarTermList, SolarTerm } from '../model/SolarTerm';

@Builder
export function SolarTermIndexPageBuilder() {
  SolarTermIndexPage()
}

@ComponentV2
export struct SolarTermIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local list: SolarTerm[] = getSolarTermList();

  build() {
    NavDestination() {
      Grid() {
        ForEach(this.list, (item: SolarTerm) => {
          GridItem() {
            Text(item.name)
              .width('100%')
              .padding(16)
              .textAlign(TextAlign.Center)
              .stateStyles({
                normal: {
                  .backgroundColor(ThemeConst.BackGroundColor_Normal)
                },
                clicked: {
                  .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                }
              })
              .onClick(() => {
                this.pageStack.pushPathByName("SolarTermShowPage", new ParamNumberId(item.id))
              })
          }
        }, (item: SolarTerm) => item.name)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .rowsGap(16)
      .columnsGap(16)
      .columnsTemplate("1fr 1fr 1fr 1fr")
    }
    .title(String.traditionalculture_solarterm)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
