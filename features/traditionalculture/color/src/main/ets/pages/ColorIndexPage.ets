import { ParamStringId, String, ThemeConst } from 'constants';
import { ChineseColor, getChineseColorList } from '../model/ChineseColor';

@Builder
export function ColorIndexPageBuilder() {
  ColorIndexPage()
}

@ComponentV2
export struct ColorIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local list: ChineseColor[] = getChineseColorList();

  build() {
    NavDestination() {
      List() {
        ForEach(this.list, (item: ChineseColor) => {
          ListItem() {
            Item({ color: item })
              .onClick(() => {
                this.pageStack.pushPathByName('ColorShowPage', new ParamStringId(item.id))
              })
          }
        }, (item: ChineseColor) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
    }
    .title(String.traditionalculture_color)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}

@ReusableV2
@ComponentV2
struct Item {
  @Param @Require color: ChineseColor

  build() {
    Row() {
      Text('')
        .height(48)
        .width(48)
        .backgroundColor(this.color.hex)
        .borderRadius(48)
      Column() {
        Text(this.color.pinyin)
        Text(this.color.name)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 16 })
      .layoutWeight(1)
    }
    .margin(ThemeConst.P_X16_Y8)
    .borderRadius(16)
    .padding(ThemeConst.P_X16_Y8)
    .backgroundColor(ThemeConst.CardBackGroundColor_Normal)
    .alignItems(VerticalAlign.Center)
  }
}