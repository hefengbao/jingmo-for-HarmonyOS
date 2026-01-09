import { ParamNumberId, String } from 'constants';
import { Lyric } from '../model/Lyric';
import LyricViewModel from '../viewmodel/LyricViewModel';
import { image } from '@kit.ImageKit';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { CopyrightView, SnapshotToolbar } from 'uicomponents';
import { SnapshotView } from '../view/LyricView';

@Builder
export function SnapshotPageBuilder() {
  SnapshotPage();
}

@ComponentV2
export struct SnapshotPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local lyric: Lyric | undefined;
  @Local pixmap: image.PixelMap | undefined = undefined;
  @Local paddingX: number = PrefUtil.getSnapshotPaddingX();
  @Local paddingY: number = PrefUtil.getSnapshotPaddingY();
  @Local fontSize: number = PrefUtil.getSnapshotFontSize();
  @Local fontColor: string = PrefUtil.getSnapshotFontColor();
  @Local bgColor: string = PrefUtil.getSnapshotBackgroundColor();

  build() {
    NavDestination() {
      Scroll() {
        if (this.lyric) {
          Column() {
            Column({
              space: 32
            }) {
              SnapshotView({ lyric: this.lyric, fontSize: this.fontSize, fontColor: this.fontColor })
              CopyrightView({
                fontColor: this.fontColor
              })
            }
            .backgroundColor(this.bgColor)
            .width('100%')
            .padding({
              left: this.paddingX,
              right: this.paddingX,
              top: this.paddingY,
              bottom: this.paddingY
            })
            .id('image')

            SnapshotToolbar({
              change: (paddingX: number, paddingY: number, fontSize: number, fontColor: string, bgColor: string) => {
                this.paddingX = paddingX;
                this.paddingY = paddingY;
                this.fontSize = fontSize;
                this.fontColor = fontColor;
                this.bgColor = bgColor
              }
            })
          }
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_lyric)

    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;

      if (param) {
        LyricViewModel.getLyric(param.id).then((value: Lyric | undefined) => {
          this.lyric = value;
        })
      }
    })
  }
}