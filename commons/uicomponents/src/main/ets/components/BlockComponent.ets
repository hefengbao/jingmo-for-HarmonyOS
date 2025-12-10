import { ThemeConst } from 'constants';

@ComponentV2
export struct BlockTitle {
  @Param @Require @Once title: string | Resource = '其他'

  build() {
    Text(this.title)
      .width('100%')
      .padding(ThemeConst.P_X16_Y8)
      .fontColor(ThemeConst.FontColor_BlockTitle)
      .fontSize(ThemeConst.FontSize_BlockTitle)
  }
}