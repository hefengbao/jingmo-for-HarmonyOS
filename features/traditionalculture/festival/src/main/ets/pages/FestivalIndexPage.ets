import { ParamNumberId, String, ThemeConst } from 'constants';
import { Festival, getFestivalList } from '../model/Festival';

@Builder
export function FestivalIndexPageBuilder() {
  FestivalIndexPage()
}

@ComponentV2
export struct FestivalIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local festivals: Festival[] = getFestivalList();

  build() {
    NavDestination() {
      List() {
        ForEach(this.festivals, (item: Festival) => {
          ListItem() {
            Text(item.name)
              .width('100%')
              .padding(ThemeConst.P_16)
              .textAlign(TextAlign.Start)
              .stateStyles({
                normal: {
                  .backgroundColor(ThemeConst.BackGroundColor_Normal)
                },
                clicked: {
                  .backgroundColor(ThemeConst.BackGroundColor_Clicked)
                }
              })
              .onClick(() => {
                this.pageStack.pushPathByName('FestivalShowPage', new ParamNumberId(item.id))
              })
          }
        }, (item: Festival) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
    }
    .title(String.traditionalculture_festival)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
