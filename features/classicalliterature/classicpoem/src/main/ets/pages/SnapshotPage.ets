import { ParamNumberId, String } from 'constants';
import { image } from '@kit.ImageKit';
import { CopyrightView, SnapshotToolbar } from 'uicomponents';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { ClassicPoem, getClassicPoem } from '../model/ClassicPoem';
import { SnapshotView } from '../view/ContentView';

@Builder
export function SnapshotPageBuilder() {
  SnapshotPage()
}

@ComponentV2
struct SnapshotPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack()
  @Local poem: ClassicPoem | undefined;
  @Local pixmap: image.PixelMap | undefined = undefined;
  @Local paddingX: number = PrefUtil.getSnapshotPaddingX();
  @Local paddingY: number = PrefUtil.getSnapshotPaddingY();
  @Local fontSize: number = PrefUtil.getSnapshotFontSize();
  @Local fontColor: string = PrefUtil.getSnapshotFontColor();
  @Local bgColor: string = PrefUtil.getSnapshotBackgroundColor();

  build() {
    NavDestination() {
      Scroll() {
        if (this.poem) {
          Column() {
            Column({
              space: 32
            }) {
              SnapshotView({ classicPoem: this.poem, fontSize: this.fontSize, fontColor: this.fontColor })
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
      .padding({})
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.classicalliterature_classicpoem)
    .menus([])
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        getClassicPoem(param.id).then((value: ClassicPoem | undefined) => {
          this.poem = value;
        })
      }
    })
  }
}