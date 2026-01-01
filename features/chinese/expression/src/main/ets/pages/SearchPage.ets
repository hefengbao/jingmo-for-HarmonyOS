import { AvoidAreaObserver, ParamNumberId, String, ThemeConst } from 'constants';
import { Expression, search } from '../model/Expression';
import { AppStorageV2 } from '@kit.ArkUI';
import { Logger } from 'utils';

let logger: Logger = new Logger('ExpressionSearchPage');

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local expressions: Expression[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .padding(ThemeConst.P_X16_Y8)
            .onSubmit((query: string) => {
              search(query).then((value: Expression[]) => {
                this.expressions.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.expressions, (item: Expression) => {
          ListItem() {
            Text(item.word)
              .padding(ThemeConst.P_16)
              .onClick(() => {
                this.pageStack.pushPathByName("ExpressionShowPage", new ParamNumberId(item.id))
              })
          }
          .padding(ThemeConst.P_X16_Y8)
        }, (item: Expression) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider({
        strokeWidth: 1,
        color: $r('sys.color.ohos_id_color_text_primary'),
        startMargin: ThemeConst.P_16,
        endMargin: ThemeConst.P_16
      })
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
