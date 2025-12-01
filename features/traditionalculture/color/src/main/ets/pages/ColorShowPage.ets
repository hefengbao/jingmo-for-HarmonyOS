import { ParamStringId, ThemeConst } from 'constants';
import { ChineseColor, getChineseColorList } from '../model/ChineseColor';

@Builder
export function ColorShowPageBuilder() {
  ColorShowPage()
}

@ComponentV2
export struct ColorShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local chineseColor: ChineseColor | undefined

  build() {
    NavDestination() {
      if (this.chineseColor) {
        Column() {
          Column() {
            Text(this.chineseColor.pinyin)
              .fontSize(ThemeConst.FontSize_14)
              .fontColor(this.chineseColor.is_bright ? Color.Black : Color.White)
            Text(this.chineseColor.name)
              .fontColor(this.chineseColor.is_bright ? Color.Black : Color.White)
              .margin({ top: 16 })
            Column() {
              Item({ title: 'C', value: this.chineseColor.cmyk[0].toString(), is_bright: this.chineseColor.is_bright })
              Item({ title: 'M', value: this.chineseColor.cmyk[1].toString(), is_bright: this.chineseColor.is_bright })
              Item({ title: 'Y', value: this.chineseColor.cmyk[2].toString(), is_bright: this.chineseColor.is_bright })
              Item({ title: 'K', value: this.chineseColor.cmyk[3].toString(), is_bright: this.chineseColor.is_bright })
            }
            .alignItems(HorizontalAlign.Start)
            .padding(ThemeConst.PY_16)
            .width('100%')

            Column() {
              Item({ title: 'R', value: this.chineseColor.rgb[0].toString(), is_bright: this.chineseColor.is_bright })
              Item({ title: 'G', value: this.chineseColor.rgb[1].toString(), is_bright: this.chineseColor.is_bright })
              Item({ title: 'B', value: this.chineseColor.rgb[2].toString(), is_bright: this.chineseColor.is_bright })
            }
            .alignItems(HorizontalAlign.Start)
            .padding(ThemeConst.PY_16)
            .width('100%')

            Item({ title: 'HEX', value: this.chineseColor.hex, is_bright: this.chineseColor.is_bright })
          }
          .width('100%')
          .height('100%')
          .backgroundColor(this.chineseColor.hex)
          .borderRadius(16)
          .padding(32)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .height('100%')
        .padding(ThemeConst.P_16)
      }
    }
    .title(this.chineseColor?.name)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamStringId
      if (param) {
        this.chineseColor = getChineseColorList().find((item: ChineseColor) => param.id == item.id)
      }
    })
  }
}

@ComponentV2
struct Item {
  @Param @Require title: string;
  @Param @Require value: string;
  @Param @Require is_bright: boolean;

  build() {
    Row() {
      Text(this.title)
        .width('40')
        .textAlign(TextAlign.Start)
        .fontColor(this.is_bright ? Color.Black : Color.White)
      Text(this.value)
        .width('100')
        .textAlign(TextAlign.End)
        .fontColor(this.is_bright ? Color.Black : Color.White)
    }
    .padding(ThemeConst.P_X16_Y8)
    .alignItems(VerticalAlign.Center)
  }
}