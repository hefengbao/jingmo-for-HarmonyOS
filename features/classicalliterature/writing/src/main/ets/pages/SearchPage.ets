import { ParamNumberId, String, ThemeConst } from 'constants';
import { ContentText } from 'uicomponents';
import { Logger } from 'utils';
import { Allusion, Clause, Quote, search, Tune, Writing } from '../model/Writing';
import { JSON, taskpool } from '@kit.ArkTS';
import { relationalStore } from '@kit.ArkData';

let logger: Logger = new Logger('WritingSearchPage');

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local writings: Writing[] = [];

  build() {
    NavDestination() {
      List() {
        ListItem() {
          Search()
            .onSubmit((query: string) => {
              let context = this.getUIContext().getHostContext() as Context;
              taskpool.execute(search, context, query)
                .then((value) => {
                  this.writings.length = 0;

                  let values = value as Array<relationalStore.ValuesBucket>;
                  values.forEach((value: relationalStore.ValuesBucket) => {

                    logger.info(`${value}`)
                    this.writings.push(
                      new Writing(
                        value['id'] as number,
                        value['group_index'] as number,
                        JSON.parse(value['classes'] as string) as string[],
                        JSON.parse(value['froms'] as string) as string[],
                        JSON.parse(value['allusions'] as string) as Allusion[],
                        JSON.parse(value['pictures'] as string) as string[],
                        value['dynasty'] as string,
                        value['author'] as string,
                        value['author_id'] as number,
                        value['author_date'] as string,
                        value['author_years'] as string,
                        value['author_place'] as string,
                        value['type'] as string,
                        value['type_detail'] as string,
                        value['rhyme'] as string,
                        value['first_clause_rhyme'] as string,
                        JSON.parse(value['title'] as string) as Clause,
                        JSON.parse(value['subtitle'] as string) as Clause,
                        JSON.parse(value['tune_id'] as string) as Tune,
                        value['preface'] as string,
                        JSON.parse(value['clauses'] as string) as Clause[],
                        value['note'] as string,
                        JSON.parse(value['comments'] as string) as Quote[],
                      )
                    )
                  })
                })
                .catch((error: BusinessError) => {
                  logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
                })
            })
        }
        .padding(ThemeConst.P_X16_Y8)

        ForEach(this.writings, (item: Writing) => {
          ListItem() {
            Column() {
              ContentText({ text: item.Title.Content })
              Text(item.Clauses?.map((item: Clause) => {
                return item.Content
              }).join())
                .lineHeight('150%')
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('100%')
                .padding(ThemeConst.P_X16_Y8)
            }
            .onClick(() => {
              this.pageStack.pushPathByName("WritingShowPage", new ParamNumberId(item.Id))
            })
          }
          .padding(ThemeConst.P_X16_Y8)
        }, (item: Writing) => item.Id.toString())
      }
      .width('100%')
      .height('100%')
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