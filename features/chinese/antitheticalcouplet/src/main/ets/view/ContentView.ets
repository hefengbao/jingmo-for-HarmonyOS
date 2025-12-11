import { AntitheticalCouplet } from '../model/AntitheticalCouplet';
import { BoldTitle, ContentText } from 'uicomponents';
import { ThemeConst } from 'constants';

@ComponentV2
export struct ContentView {
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
        ContentText({ text: this.antitheticalCouplet.description })
      }
    }
    .width('100%')
  }
}