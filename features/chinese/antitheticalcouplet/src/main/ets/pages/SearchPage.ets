import { AvoidAreaObserver, ParamNumberId, String, ThemeConst } from 'constants';
import { AntitheticalCouplet, search } from '../model/AntitheticalCouplet';
import { AppStorageV2 } from '@kit.ArkUI';
import { Logger } from 'utils';

let logger: Logger = new Logger('AntitheticalCoupletSearchPage');

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local antitheticalCouplets: AntitheticalCouplet[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .onSubmit((query: string) => {
              search(query).then((value: AntitheticalCouplet[]) => {
                this.antitheticalCouplets.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.antitheticalCouplets, (item: AntitheticalCouplet) => {
          ListItem() {
            Text(item.body)
              .width('100%')
              .onClick(() => {
                this.pageStack.pushPathByName("AntitheticalCoupletShowPage", new ParamNumberId(item.id))
              })
          }.padding(ThemeConst.P_X16_Y8)
        }, (item: AntitheticalCouplet) => item.id.toString())
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
        endMargin: ThemeConst.P_16,
      })
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
