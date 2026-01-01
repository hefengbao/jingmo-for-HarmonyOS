import { AvoidAreaObserver, Icon, ParamNumberId, String, ThemeConst } from 'constants';
import { getRandomSentence, getSentence, search, Sentence } from '../model/Sentence';
import { SentenceView } from '../view/SentenceView';
import { AppStorageV2 } from '@kit.ArkUI';
import SentenceViewModel from '../viewmodel/SentenceViewModel';
import { Bookmark } from 'bookmark';
import { Logger } from 'utils';
import { it } from '@ohos/hypium';

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
      List(){
        ListItem(){
          Search()
            .padding(ThemeConst.P_X16_Y8)
            .onSubmit((query: string) => {
              search(query).then((value: Sentence[]) => {
                this.sentences.push(...value)
              })
            })
        }
        .padding(ThemeConst.P_X16_Y8)
        ForEach(this.sentences, (item: Sentence) => {
          ListItem(){
            Text(item.content)
              .width('100%')
              .padding(ThemeConst.P_X16_Y8)
              .onClick(() => {
                this.pageStack.pushPathByName("SentenceShowPage", new ParamNumberId(item.id))
              })
          }
          .padding(ThemeConst.P_X16_Y8)
        },(item: Sentence) => item.id.toString())
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
