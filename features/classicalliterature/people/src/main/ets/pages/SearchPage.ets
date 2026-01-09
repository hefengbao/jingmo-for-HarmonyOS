import { ParamNumberId, String, ThemeConst } from 'constants';
import { ContentText } from 'uicomponents';
import { People } from '../model/People';
import PeopleViewModel from '../viewmodel/PeopleViewModel';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local peoples: People[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .onSubmit((query: string) => {
              PeopleViewModel.search(query).then((value: People[]) => {
                this.peoples.length = 0;
                this.peoples.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.peoples, (item: People) => {
          ListItem() {
            Column({ space: 16 }) {
              Text(item.Name)
                .width('100%')
                .padding(ThemeConst.P_X16_Y8)
            }
            .onClick(() => {
              this.pageStack.pushPathByName("PeopleShowPage", new ParamNumberId(item.Id))
            })
          }

        }, (item: People) => item.Id.toString())
      }
      .width('100%')
      .height('100%')
      .align(Alignment.TopStart)
      .edgeEffect(EdgeEffect.Spring)
      .divider(ThemeConst.ListDivider)
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}