import { ThemeConst } from 'constants';

@ComponentV2
export struct BoldTitle {
  @Param @Require @Once text: string | Resource

  build() {
    Text(this.text)
      .fontWeight(FontWeight.Bold)
      .padding(ThemeConst.P_X16_Y8)
      .width('100%')
      .textAlign(TextAlign.Start)
  }
}

@ComponentV2
export struct ContentText {
  @Param @Require text: string | Resource

  build() {
    Text(this.text)
      .padding(ThemeConst.P_X16_Y8)
      .width('100%')
      .lineHeight(24)
      .copyOption(CopyOptions.InApp)
  }
}

@ComponentV2
export struct ContentAuthor {
  @Param @Require text: string | Resource

  build() {
    Text(`—— ${this.text}`)
      .width('100%')
      .padding(ThemeConst.P_X16_Y8)
      .fontSize(ThemeConst.FontSize_14)
      .fontStyle(FontStyle.Italic)
      .copyOption(CopyOptions.InApp)
  }
}