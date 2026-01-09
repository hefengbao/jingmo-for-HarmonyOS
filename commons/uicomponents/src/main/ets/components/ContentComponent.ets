import { ThemeConst } from 'constants';

@ComponentV2
export struct BoldTitle {
  @Param @Require @Once text: string | Resource;
  @Param fontColor: string | Resource = $r('sys.color.ohos_id_color_text_primary');
  @Param textAlign: TextAlign = TextAlign.Start;

  build() {
    Text(this.text)
      .fontWeight(FontWeight.Bold)
      .padding(ThemeConst.P_X16_Y8)
      .width('100%')
      .textAlign(this.textAlign)
      .fontColor(this.fontColor)
  }
}

@ComponentV2
export struct SubTitle {
  @Param @Require text: string | Resource;
  @Param fontSize: number | Resource = $r('sys.float.ohos_id_text_size_sub_title1');
  @Param fontColor: string | Resource = $r('sys.color.ohos_id_color_text_primary');
  @Param textAlign: TextAlign = TextAlign.Start;

  build() {
    Text(this.text)
      .padding(ThemeConst.P_X16_Y8)
      .fontSize(this.fontSize)
      .fontColor(this.fontColor)
      .fontStyle(FontStyle.Italic)
      .textAlign(this.textAlign)
      .copyOption(CopyOptions.InApp)
  }
}

@ComponentV2
export struct ContentText {
  @Param @Require text: string | Resource;
  @Param textAlign: TextAlign = TextAlign.Start;
  @Param fontSize: number | Resource = $r('sys.float.ohos_id_text_font_size');
  @Param fontColor: string | Resource = $r('sys.color.ohos_id_color_text_primary');

  build() {
    Text(this.text)
      .padding(ThemeConst.P_X16_Y8)
      .width('100%')
      .fontSize(this.fontSize)
      .fontColor(this.fontColor)
      .textAlign(this.textAlign)
      .lineHeight('150%')
      .copyOption(CopyOptions.InApp)
  }
}

@ComponentV2
export struct ContentAuthor {
  @Param @Require text: string | Resource;
  @Param fontSize: number | Resource = $r('sys.float.ohos_id_text_font_size');
  @Param fontColor: string | Resource = $r('sys.color.ohos_id_color_text_primary');
  @Param textAlign: TextAlign = TextAlign.Start;

  build() {
    Text(`—— ${this.text}`)
      .width('100%')
      .padding(ThemeConst.P_X16_Y8)
      .fontSize(this.fontSize)
      .fontColor(this.fontColor)
      .fontStyle(FontStyle.Italic)
      .copyOption(CopyOptions.InApp)
      .textAlign(this.textAlign)
  }
}