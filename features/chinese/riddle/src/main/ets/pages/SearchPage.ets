import { ParamNumberId, String, ThemeConst } from 'constants';
import { Riddle } from '../model/Riddle';
import RiddleViewModel from '../viewmodel/RiddleViewModel';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local riddleList: Riddle[] = [];

  build() {
    NavDestination() {
      Column() {
        List() {
          ListItem() {
            Column() {
              Search()
                .onSubmit((query: string) => {
                  RiddleViewModel.search(query).then((value: Riddle[]) => {
                    this.riddleList.length = 0;
                    this.riddleList.push(...value)
                  })
                })
            }
            .padding(ThemeConst.P_X16_Y8)
          }

          ForEach(this.riddleList, (item: Riddle) => {
            ListItem() {
              Column({ space: 8 }) {
                Text(item.puzzle)
                  .width('100%')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .padding(ThemeConst.P_X16_Y8)
              .onClick(() => {
                this.pageStack.pushPathByName("RiddleShowPage", new ParamNumberId(item.id))
              })
            }
          }, (item: Riddle) => item.id.toString())
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