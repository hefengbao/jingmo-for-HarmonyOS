import { Bookmark } from 'bookmark';
import { Icon, ParamNumberId, String } from 'constants';
import { Logger } from 'utils';
import { ModernPoetry } from '../model/ModernPoetry';
import PoetryViewModel from '../viewmodel/PoetryViewModel';
import { image } from '@kit.ImageKit';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { SnapshotView } from '../view/PoetryView';
import { CopyrightView, SnapshotToolbar } from 'uicomponents';

@Builder
export function SnapshotPageBuilder() {
  SnapshotPage();
}

@ComponentV2
export struct SnapshotPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local poetry: ModernPoetry | undefined;
  @Local pixmap: image.PixelMap | undefined = undefined;
  @Local paddingX: number = PrefUtil.getSnapshotPaddingX();
  @Local paddingY: number = PrefUtil.getSnapshotPaddingY();
  @Local fontSize: number = PrefUtil.getSnapshotFontSize();
  @Local fontColor: string = PrefUtil.getSnapshotFontColor();
  @Local bgColor: string = PrefUtil.getSnapshotBackgroundColor();

  build() {
    NavDestination() {
      Scroll() {
        if (this.poetry) {
          Column() {
            Column({
              space: 32
            }) {
              SnapshotView({ poetry: this.poetry, fontSize: this.fontSize, fontColor: this.fontColor })
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
    .title(String.chinese_modernpoetry)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;

      if (param) {
        PoetryViewModel.getPoetry(param.id).then((value: ModernPoetry | undefined) => {
          this.poetry = value;
        })
      }
    })
  }
}