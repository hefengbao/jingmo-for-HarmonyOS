import { ThemeConst } from 'constants';
import { BoldTitle, ContentText } from 'uicomponents';
import { ModernPoetry } from '../model/ModernPoetry';

@Extend(Text)
function basicText() {
  .padding(ThemeConst.P_X16_Y8)
  .lineHeight('150%')
}

@ComponentV2
export struct PoetryView {
  @Param @Require poetry: ModernPoetry;

  build() {
    Column() {
      Column() {
        Text(this.poetry.title)
          .basicText()
        Text(this.poetry.author)
          .basicText()
          .fontSize(12)
        Text(this.poetry.content)
          .basicText()
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .alignItems(HorizontalAlign.Center)

      if (this.poetry.zhu) {
        BoldTitle({ text: '注释' })
        ContentText({ text: this.poetry.zhu })
      }
      if (this.poetry.yi) {
        BoldTitle({ text: '翻译' })
        ContentText({ text: this.poetry.yi })
      }
      if (this.poetry.shang) {
        BoldTitle({ text: '鉴赏' })
        ContentText({ text: this.poetry.shang })
      }
      if (this.poetry.authorInfo) {
        BoldTitle({ text: '作者简介' })
        ContentText({ text: this.poetry.authorInfo })
      }
    }
  }
}

@ComponentV2
export struct SnapshotView {
  @Param @Require poetry: ModernPoetry;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    Column() {
      Text(this.poetry.title)
        .basicText()
        .fontColor(this.fontColor)
        .fontSize(this.fontSize);
      Text(this.poetry.author)
        .basicText()
        .fontSize(12)
        .fontColor(this.fontColor)
      Text(this.poetry.content)
        .basicText()
        .fontColor(this.fontColor)
        .fontSize(this.fontSize);
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
    .alignItems(HorizontalAlign.Center)
  }
}