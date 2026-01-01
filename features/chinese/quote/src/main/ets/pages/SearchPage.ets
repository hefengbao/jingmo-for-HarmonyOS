import { AvoidAreaObserver, ParamNumberId, String, ThemeConst } from 'constants';
import { Quote, search } from '../model/Quote';
import { AppStorageV2 } from '@kit.ArkUI';
import { Logger } from 'utils';

let logger: Logger = new Logger('QuoteSearchPage');

@Builder
export function SearchPageBuilder() {
  SearchPage()
}

@ComponentV2
export struct SearchPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local quotes: Quote[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .padding(ThemeConst.P_X16_Y8)
            .onSubmit((query: string) => {
              search(query).then((value: Quote[]) => {
                this.quotes.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.quotes, (item: Quote) => {
          ListItem() {
            Text(item.content)
              .width('100%')
              .padding(ThemeConst.P_X16_Y8)
              .maxLines(3)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .onClick(() => {
                this.pageStack.pushPathByName("QuoteShowPage", new ParamNumberId(item.id))
              })
          }
          .padding(ThemeConst.P_X16_Y8)
        }, (item: Quote) => item.id.toString())
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
