import { ClassicPoem } from '../model/ClassicPoem';
import { ThemeConst } from 'constants';
import { BoldTitle, ContentText } from 'uicomponents';

@ComponentV2
export struct ClassicPoemView {
  @Param @Require classicPoem: ClassicPoem;

  build() {
    Column() {
      Text(this.classicPoem.title)
        .padding(ThemeConst.P_X16_Y8)
      Text(`【${this.classicPoem.dynasty}】${this.classicPoem.writer}`)
        .padding(ThemeConst.P_X16_Y8)
        .fontSize(ThemeConst.FontSize_14)
      if (this.classicPoem.preface) {
        Text(this.classicPoem.preface)
          .fontSize(ThemeConst.FontSize_14)
          .fontStyle(FontStyle.Italic)
          .padding(ThemeConst.P_X16_Y8)
      }

      Text(this.classicPoem.content)
        .padding(ThemeConst.P_X16_Y8)
        .lineHeight(24)

      if (this.classicPoem.annotation) {
        BoldTitle({ text: '注释' })
        ContentText({ text: this.classicPoem.annotation })
      }

      if (this.classicPoem.translation) {
        BoldTitle({ text: '译文' })
        ContentText({ text: this.classicPoem.translation })
      }

      if (this.classicPoem.creative_background) {
        BoldTitle({ text: '创作背景' })
        ContentText({ text: this.classicPoem.creative_background })
      }

      if (this.classicPoem.explain) {
        BoldTitle({ text: '赏析' })
        ContentText({ text: this.classicPoem.explain })
      }

      if (this.classicPoem.comment) {
        BoldTitle({ text: '点评' })
        ContentText({ text: this.classicPoem.comment })
      }
    }
  }
}

@ComponentV2
export struct SnapshotView {
  @Param @Require classicPoem: ClassicPoem;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    Column() {
      Text(this.classicPoem.title)
        .padding(ThemeConst.P_X16_Y8)
        .fontColor(this.fontColor)
        .fontSize(this.fontSize)
      Text(`【${this.classicPoem.dynasty}】${this.classicPoem.writer}`)
        .padding(ThemeConst.P_X16_Y8)
        .fontSize(ThemeConst.FontSize_14)
        .fontColor(this.fontColor)
      if (this.classicPoem.preface) {
        Text(this.classicPoem.preface)
          .fontSize(ThemeConst.FontSize_14)
          .fontStyle(FontStyle.Italic)
          .fontColor(this.fontColor)
          .padding(ThemeConst.P_X16_Y8)
      }

      Text(this.classicPoem.content)
        .padding(ThemeConst.P_X16_Y8)
        .lineHeight(24)
        .fontColor(this.fontColor)
        .fontSize(this.fontSize)
    }
  }
}