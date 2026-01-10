import { ParamNumberId, String, ThemeConst } from 'constants';
import { Wisecrack } from '../model/Wisecrack';
import WisecrackViewModel from '../viewmodel/WisecrackViewModel';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local wisecrackList: Wisecrack[] = [];

  build() {
    NavDestination() {
      Column() {
        List() {
          ListItem() {
            Column() {
              Search()
                .onSubmit((query: string) => {
                  WisecrackViewModel.search(query).then((value: Wisecrack[]) => {
                    this.wisecrackList.length = 0;
                    this.wisecrackList.push(...value)
                  })
                })
            }
            .padding(ThemeConst.P_X16_Y8)
          }

          ForEach(this.wisecrackList, (item: Wisecrack) => {
            ListItem() {
              Column({ space: 8 }) {
                Text(item.riddle)
                  .width('100%')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .padding(ThemeConst.P_X16_Y8)
              .onClick(() => {
                this.pageStack.pushPathByName("WisecrackShowPage", new ParamNumberId(item.id))
              })
            }
          }, (item: Wisecrack) => item.id.toString())
        }
        .width('100%')
        .height('100%')
        .align(Alignment.TopStart)
        .divider(ThemeConst.ListDivider)
      }
      .padding({
        bottom: 16
      })
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}