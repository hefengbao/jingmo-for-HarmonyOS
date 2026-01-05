import { AvoidAreaObserver, ParamNumberId, PrefConst, String, ThemeConst } from 'constants';
import { Logger } from 'utils';
import { BookmarkEntity, getEntities } from '../model/BookmarkEntity';
import { AppStorageV2, uiObserver } from '@kit.ArkUI';
import { BlockTitle } from 'uicomponents';

let logger: Logger = new Logger('BookmarkIndexPage')

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local entities: BookmarkEntity[] = [];

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      if (info.name == 'BookmarkIndexPage' && info.state == 4) {
        getEntities().then((value: BookmarkEntity[]) => {
          logger.info(`entities count = ${value.length}`)
          this.entities = value;
        })
      }
    });
  }

  aboutToDisappear() {
    uiObserver.off('navDestinationUpdate');
  }

  build() {
    NavDestination() {
      List() {
        Repeat<BookmarkEntity>(this.entities)
          .each((repeatItem: RepeatItem<BookmarkEntity>) => {
            ListItem() {
              if (repeatItem.item.bookmarkable_model == PrefConst.CHINESE_ANTITHETICALCOUPLET) {
                Item({
                  model: String.chinese_antitheticalcouplet,
                  content: repeatItem.item.chinese_antitheticalcouplet
                })
                  .onClick(() => {
                    logger.info(`chinese_antitheticalcouplet clicked`);
                    this.pageStack.pushPathByName('AntitheticalCoupletShowPage',
                      new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CHINESE_CHARACTER) {
                Item({
                  model: String.chinese_character,
                  content: repeatItem.item.chinese_character
                })
                  .onClick(() => {
                    this.pageStack.pushPathByName('CharacterShowPage',
                      new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CHINESE_EXPRESSION) {
                Item({
                  model: String.chinese_expression,
                  content: repeatItem.item.chinese_expression
                })
                  .onClick(() => {
                    logger.info(`chinese_expression clicked`);
                    this.pageStack.pushPathByName('ExpressionShowPage',
                      new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CHINESE_IDIOM) {
                Item({
                  model: String.chinese_idiom,
                  content: repeatItem.item.chinese_idiom
                })
                  .onClick(() => {
                    this.pageStack.pushPathByName('IdiomShowPage', new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CHINESE_KNOWLEDGE) {
                Item({
                  model: String.chinese_knowledge,
                  content: repeatItem.item.chinese_knowledge
                })
                  .onClick(() => {
                    this.pageStack.pushPathByName('KnowledgeShowPage',
                      new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CHINESE_QUOTE) {
                Item({
                  model: String.chinese_quote,
                  content: repeatItem.item.chinese_quote
                })
                  .onClick(() => {
                    this.pageStack.pushPathByName('QuoteShowPage', new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
                Item({
                  model: String.classicalliterature_classicpoem,
                  content: repeatItem.item.classicalliterature_classicpoem
                })
                  .onClick(() => {
                    this.pageStack.pushPathByName('ClassicPoemShowPage',
                      new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              } else if (repeatItem.item.bookmarkable_model == PrefConst.CLASSICALLITERATURE_SENTENCE) {
                Item({
                  model: String.classicalliterature_sentence,
                  content: repeatItem.item.classicalliterature_sentence
                })
                  .onClick(() => {
                    this.pageStack.pushPathByName('SentenceShowPage',
                      new ParamNumberId(repeatItem.item.bookmarkable_id))
                  })
              }
            }
          })
          .key((item: BookmarkEntity) => `${item.id}`)
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider({ strokeWidth: 2 })
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}

@ComponentV2
struct Item {
  @Param @Require model: Resource;
  @Param @Require content: string | null;

  build() {
    Column() {
      BlockTitle({ title: this.model })
      Text(this.content)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .padding(ThemeConst.P_8)
    .stateStyles({
      normal: {
        .backgroundColor(ThemeConst.BackGroundColor_Normal)
      },
      pressed: {
        .backgroundColor(ThemeConst.BackGroundColor_Pressed)
      }
    })
  }
}
