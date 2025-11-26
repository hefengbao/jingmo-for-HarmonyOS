import { ThemeConst } from 'constants';

@ComponentV2
export struct BlockTitle {
  @Param @Require @Once title: string | Resource = '其他'

  build() {
    Text(this.title)
      .width('100%')
      .padding({
        left: 16,
        top: 8,
        right: 16,
        bottom: 8
      })
      .fontColor(ThemeConst.FontColor_BlockTitle)
      .fontSize(ThemeConst.FontSize_BlockTitle)
  }
}