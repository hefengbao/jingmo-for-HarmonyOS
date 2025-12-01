import { AntitheticalCouplet } from '../model/AntitheticalCouplet';
import { BoldTitle } from 'uicomponents';
import { ThemeConst } from 'constants';

@ComponentV2
export struct AntitheticalCoupletView {
  @Param @Require antitheticalCouplet: AntitheticalCouplet

  build() {
    Column() {
      Text(this.antitheticalCouplet.body)
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding(ThemeConst.P_X16_Y8)
      if (this.antitheticalCouplet.description) {
        BoldTitle({ text: '介绍' })
          .width('100%')
        Text(this.antitheticalCouplet.description)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
          .textAlign(TextAlign.Start)
          .lineHeight(24)
      }
    }
    .width('100%')
  }
}