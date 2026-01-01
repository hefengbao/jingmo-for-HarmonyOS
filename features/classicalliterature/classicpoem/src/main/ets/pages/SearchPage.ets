import { AvoidAreaObserver, ParamNumberId, String, ThemeConst } from 'constants';
import { AppStorageV2 } from '@ohos.arkui.StateManagement';
import { ClassicPoem, search } from '../model/ClassicPoem';

@Builder
export function SearchPageBuilder() {
  SearchPage()
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local classicPoems: ClassicPoem[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .onSubmit(async (query: string) => {
              await search(query).then((value: ClassicPoem[]) => {
                this.classicPoems.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.classicPoems, (item: ClassicPoem) => {
          ListItem() {
            Column({ space: 16 }) {
              Text(item.title)
                .width('100%')
              Text(item.content)
                .maxLines(2)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .width('100%')
            }
            .onClick(() => {
              this.pageStack.pushPathByName("ClassicPoemShowPage", new ParamNumberId(item.id))
            })
          }
          .padding(ThemeConst.P_X16_Y8)

        }, (item: ClassicPoem) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .align(Alignment.TopStart)
      .edgeEffect(EdgeEffect.Spring)
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .divider({
        strokeWidth: 1,
        color: $r('sys.color.ohos_id_color_text_primary'),
        startMargin: 16,
        endMargin: 16
      })
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}