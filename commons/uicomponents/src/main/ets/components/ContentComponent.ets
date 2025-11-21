import { ThemeConst } from 'constants';

@ComponentV2
export struct BoldTitle {
  @Param @Require @Once text: string
  build() {
    Text(this.text)
      .fontWeight(FontWeight.Bold)
      .padding(ThemeConst.P_X16_Y8)
      .width('100%')
      .textAlign(TextAlign.Start)
  }
}

@ComponentV2
export struct Content {
  @Param @Require text: string
  build() {
    Text(this.text)
      .padding(ThemeConst.P_X16_Y8)
      .width('100%')
      .lineHeight(24)
  }
}