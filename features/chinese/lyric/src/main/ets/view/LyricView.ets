import { ThemeConst } from "constants";
import { Lyric } from "../model/Lyric";

@Extend(Text)
function basicText(){
  .padding(ThemeConst.P_X16_Y8)
  .lineHeight('150%')
}

@ComponentV2
export struct LyricView {
  @Param @Require lyric: Lyric;

  build() {
    Column(){
      Text(this.lyric.title)
        .basicText();
      Text(parseWriterSinger(this.lyric))
        .basicText()
        .fontSize(12)
      Text(this.lyric.content)
        .basicText()
    }
    .width('100%')
    .padding({top:16, bottom:16})
    .alignItems(HorizontalAlign.Center)
  }
}

@ComponentV2
export struct SnapshotView {
  @Param @Require lyric: Lyric;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    Column(){
      Text(this.lyric.title)
        .basicText()
        .fontColor(this.fontColor)
        .fontSize(this.fontSize);
      Text(parseWriterSinger(this.lyric))
        .basicText()
        .fontSize(12)
        .fontColor(this.fontColor)
      Text(this.lyric.content)
        .basicText()
        .fontColor(this.fontColor)
        .fontSize(this.fontSize);
    }
    .width('100%')
    .padding({top:16, bottom:16})
    .alignItems(HorizontalAlign.Center)
  }
}

function parseWriterSinger(lyric: Lyric): string{
  let str = '';

  if (lyric.writer) {
    str += `填词：${lyric.writer}`
  }

  if (lyric.singer) {
    if (str.length) {
      str += ' / '
    }

    str += `演唱：${lyric.singer}`
  }

  return str;
}