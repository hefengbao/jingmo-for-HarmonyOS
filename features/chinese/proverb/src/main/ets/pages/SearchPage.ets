import { ParamNumberId, String, ThemeConst } from 'constants';
import { Proverb } from '../model/Proverb';
import ProverbViewModel from '../viewmodel/ProverbViewModel';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local proverbList: Proverb[] = [];

  build() {
    NavDestination() {
      Column() {
        List() {
          ListItem() {
            Column() {
              Search()
                .onSubmit((query: string) => {
                  ProverbViewModel.search(query).then((value: Proverb[]) => {
                    this.proverbList.length = 0;
                    this.proverbList.push(...value)
                  })
                })
            }
            .padding(ThemeConst.P_X16_Y8)
          }

          ForEach(this.proverbList, (item: Proverb) => {
            ListItem() {
              Column({ space: 8 }) {
                Text(item.content)
                  .width('100%')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .padding(ThemeConst.P_X16_Y8)
              .onClick(() => {
                this.pageStack.pushPathByName("ProverbShowPage", new ParamNumberId(item.id))
              })
            }
          }, (item: Proverb) => item.id.toString())
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
    .title(String.chinese_proverb)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}