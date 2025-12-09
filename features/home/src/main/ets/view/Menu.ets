import { ThemeConst } from 'constants'

@ComponentV2
export struct Item {
  @Param @Require title: string | Resource

  build() {
    Text(this.title)
      .width('100%')
      .fontFamily('HarmonyHeiTi')
      .textAlign(TextAlign.Center)
      .padding(16)
      .borderRadius(12)
      .stateStyles({
        normal: {
          .backgroundColor(ThemeConst.CardBackGroundColor_Normal)
        },
        clicked: {
          .backgroundColor(ThemeConst.CardBackGroundColor_Pressed)
        }
      })
  }
}

@ComponentV2
export struct Title {
  @Param @Require title: string | Resource

  build() {
    Text(this.title)
      .textAlign(TextAlign.Start)
      .fontColor(ThemeConst.FontColor_BlockTitle)
      .fontSize(ThemeConst.FontSize_BlockTitle)
      .width('100%')
      .padding(8)
  }
}