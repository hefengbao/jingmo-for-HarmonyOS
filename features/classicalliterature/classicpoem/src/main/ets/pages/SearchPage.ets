import { AvoidAreaObserver } from 'constants';
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
      Scroll() {
        List() {
          ListItem() {
            Search()
              .onSubmit(async (query: string) => {
                await search(query).then((value: ClassicPoem[]) => {
                  this.classicPoems.push(...value)
                })
              })
          }

          ForEach(this.classicPoems, (item: ClassicPoem) => {
            ListItem() {
              Text(item.title)
            }
          }, (item: ClassicPoem) => item.id.toString())
        }
        .width('100%')
        .padding(16)
        .align(Alignment.TopStart)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
    }
    .title('')
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}