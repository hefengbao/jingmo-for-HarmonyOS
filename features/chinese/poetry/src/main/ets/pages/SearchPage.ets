import { ParamNumberId, String, ThemeConst } from 'constants';
import { ModernPoetry } from '../model/ModernPoetry';
import PoetryViewModel from '../viewmodel/PoetryViewModel';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local poetryList: ModernPoetry[] = [];

  build() {
    NavDestination() {
      Column() {
        List() {
          ListItem() {
            Column() {
              Search()
                .onSubmit((query: string) => {
                  PoetryViewModel.search(query).then((value: ModernPoetry[]) => {
                    this.poetryList.length = 0;
                    this.poetryList.push(...value)
                  })
                })
            }
            .padding(ThemeConst.P_X16_Y8)
          }

          ForEach(this.poetryList, (item: ModernPoetry) => {
            ListItem() {
              Column({ space: 8 }) {
                Text(item.title)
                  .width('100%')
                Text(item.content)
                  .width('100%')
                  .maxLines(3)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .padding(ThemeConst.P_X16_Y8)
              .onClick(() => {
                this.pageStack.pushPathByName("ModernPoetryShowPage", new ParamNumberId(item.id))
              })
            }
          }, (item: ModernPoetry) => item.id.toString())
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