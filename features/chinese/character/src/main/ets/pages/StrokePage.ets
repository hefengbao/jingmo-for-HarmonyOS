import { SearchParam } from '../model/Param';
import { getStokeList, Stroke } from '../model/Stroke';
import { ThemeConst } from 'constants';

@Builder
export function StrokePageBuilder() {
  StrokePage()
}

@ComponentV2
export struct StrokePage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local strokeList: Stroke[] = getStokeList()

  build() {
    NavDestination() {
      Scroll() {
        Grid() {
          ForEach(this.strokeList, (item: Stroke) => {
            GridItem() {
              Text(item.label)
                .width('100%')
                .padding(16)
                .textAlign(TextAlign.Center)
                .stateStyles({
                  normal: {
                    .backgroundColor(ThemeConst.BackGroundColor_Normal)
                  },
                  clicked: {
                    .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                  }
                })
                .onClick(() => {
                  this.pageStack.pushPathByName('CharacterSearchListPage', new SearchParam('stroke', item.stroke.toString()))
                })
            }
          }, (item: Stroke) => item.label)
        }
        .width('100%')
        .padding(16)
        .columnsGap(12)
        .rowsGap(12)
        .columnsTemplate('1fr 1fr 1fr')
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title('笔画查询')
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}