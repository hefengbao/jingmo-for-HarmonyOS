import { getRadicalList, Radical } from '../model/Radical';
import { ThemeConst } from 'constants';
import { SearchParam } from '../model/Param';

@Builder
export function RadicalPageBuilder() {
  RadicalPage()
}

@ComponentV2
export struct RadicalPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local radicalList: Radical[] = getRadicalList();
  @Local currentStrokeIndex: number = 0;
  private strokeScroller: Scroller = new Scroller();
  private scroller: Scroller = new Scroller();

  strokeChangeAction(index: number, isStroke: boolean): void {
    if (this.currentStrokeIndex !== index) {
      //左侧点击
      this.currentStrokeIndex = index;
      if (isStroke) {
        // 右侧联动
        this.scroller.scrollToIndex(index, true);
      } else {
        this.strokeScroller.scrollToIndex(index, true);
      }
    }
  }

  build() {
    NavDestination() {
      Row() {
        List({ scroller: this.strokeScroller }) {
          ForEach(this.radicalList, (item: Radical, index: number) => {
            ListItem() {
              Text(item.stroke)
                .width('100%')
                .padding(ThemeConst.P_16)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .backgroundColor(this.currentStrokeIndex == index ? Color.White : '')
                .onClick(() => {
                  this.strokeChangeAction(index, true)
                })
            }
          }, (item: Radical) => item.stroke + this.currentStrokeIndex)
        }
        .width(80)
        .height('100%')
        .backgroundColor(ThemeConst.CardBackGroundColor_Normal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.None)

        List({ scroller: this.scroller }) {
          ForEach(this.radicalList, (item: Radical) => {
            ListItemGroup() {
              ListItem() {
                Column() {
                  Text(item.stroke)
                    .width('100%')
                    .fontWeight(FontWeight.Bold)
                    .padding(ThemeConst.P_X16_Y8)
                    .textAlign(TextAlign.Start)
                  Grid() {
                    ForEach(item.radicals, (radical: string) => {
                      GridItem() {
                        Text(radical)
                          .width('100%')
                          .padding(16)
                          .textAlign(TextAlign.Center)
                          .stateStyles({
                            normal: {
                              .backgroundColor(ThemeConst.BackGroundColor_Normal)
                            },
                            clicked: {
                              .backgroundColor(ThemeConst.BackGroundColor_Clicked)
                            }
                          })
                          .onClick(() => {
                            this.pageStack.pushPathByName('SearchListPage', new SearchParam('radical', radical))
                          })
                      }
                    }, (radical: string) => radical)
                  }
                  .width('100%')
                  .padding(16)
                  .columnsGap(12)
                  .rowsGap(12)
                  .columnsTemplate('1fr 1fr 1fr')
                }
              }
            }
          }, (item: Radical) => item.stroke)
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.Spring)
        .onScrollIndex((start: number) => this.strokeChangeAction(start, false))
      }
    }
    .title('部首查询')
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}