import { AvoidAreaObserver, ParamNumberId, String, ThemeConst } from 'constants';
import { search, Sentence } from '../model/Sentence';
import { AppStorageV2 } from '@kit.ArkUI';
import { Logger } from 'utils';
import { ContentText } from 'uicomponents';

let logger: Logger = new Logger('SentenceSearchPage');

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local sentences: Sentence[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .onSubmit((query: string) => {
              search(query).then((value: Sentence[]) => {
                this.sentences.length = 0;
                this.sentences.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.sentences, (item: Sentence) => {
          ListItem() {
            Column(){
              ContentText({text: item.content})
            }
            .onClick(() => {
              this.pageStack.pushPathByName("SentenceShowPage", new ParamNumberId(item.id))
            })
          }
          .padding(ThemeConst.P_X16_Y8)
        }, (item: Sentence) => item.id.toString())
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
