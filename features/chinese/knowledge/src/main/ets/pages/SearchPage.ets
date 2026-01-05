import { AvoidAreaObserver, ParamNumberId, String, ThemeConst } from 'constants';
import { Knowledge, search } from '../model/Knowledge';
import { AppStorageV2 } from '@kit.ArkUI';
import { Logger } from 'utils';

let logger: Logger = new Logger('KnowledgeSearchPage');

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local knowledges: Knowledge[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .onSubmit((query: string) => {
              search(query).then((value: Knowledge[]) => {
                this.knowledges.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.knowledges, (item: Knowledge) => {
          ListItem() {
            Text(item.content)
              .padding(ThemeConst.P_X16_Y8)
              .onClick(() => {
                this.pageStack.pushPathByName("KnowledgeShowPage", new ParamNumberId(item.id))
              })
          }
          .padding(ThemeConst.P_X16_Y8)
        }, (item: Knowledge) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider(ThemeConst.ListDivider)
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
