import { ParamNumberId, String, ThemeConst } from 'constants';
import { readWorldCulturalHeritageList, WorldCulturalHeritage } from '../model/WorldCulturalHeritage';

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local list: WorldCulturalHeritage[] = [];

  aboutToAppear(): void {
    readWorldCulturalHeritageList().then((value: WorldCulturalHeritage[]) => {
      this.list = value
    })
  }

  build() {
    NavDestination() {
      List() {
        ForEach(this.list, (item: WorldCulturalHeritage) => {
          ListItem() {
            Row() {
              Image(item.image)
                .width(100)
                .height(100)
              Column() {
                Text(item.name)
                  .margin({ top: 8 })
                Text(item.year)
                  .fontSize(ThemeConst.FontSize_14)
                  .margin({ top: 8 })
                Text(`#${item.type}`)
                  .margin({ top: 8 })
                  .fontSize(ThemeConst.FontSize_14)
                  .fontColor(Color.Gray)
              }
              .margin({ left: 16, right: 16 })
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName('WorldCulturalHeritageShowPage', new ParamNumberId(item.id))
            })
          }
        }, (item: WorldCulturalHeritage) => item.id.toString())
      }
      .divider(ThemeConst.ListDivider)
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
    }
    .title(String.china_worldcultureheritage)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
