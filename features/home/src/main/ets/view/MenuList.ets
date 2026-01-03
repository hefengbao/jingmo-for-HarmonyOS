import { Item, Title } from './Menu';
import { String } from 'constants';

@ComponentV2
export struct MenuList {
  @Param @Require @Once pageStack: NavPathStack;

  build() {
    Grid() {
      GridItem() {
        Title({
          title: String.classicalliterature
        })
      }
      .columnStart(0)
      .columnEnd(1)

      GridItem() {
        Item({
          title: String.classicalliterature_classicpoem
        }).onClick(() => {
          this.pageStack.pushPathByName('ClassicPoemIndexPage', null)
        })
      }

      GridItem() {
        Item({
          title: String.classicalliterature_sentence
        }).onClick(() => {
          this.pageStack.pushPathByName('SentenceIndexPage', null)
        })
      }

      GridItem() {
        Title({
          title: String.chinese
        })
      }
      .columnStart(0)
      .columnEnd(1)

      GridItem() {
        Item({
          title: String.chinese_character
        }).onClick(() => [
          this.pageStack.pushPathByName('CharacterIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_expression
        }).onClick(() => [
          this.pageStack.pushPathByName('ExpressionIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_idiom
        }).onClick(() => [
          this.pageStack.pushPathByName('IdiomIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_antitheticalcouplet
        }).onClick(() => [
          this.pageStack.pushPathByName('AntitheticalCoupletIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_quote
        }).onClick(() => [
          this.pageStack.pushPathByName('QuoteIndexPage', null)
        ])
      }

      /*GridItem() {
        Item({
          title: String.chinese_modernpoetry
        })
      }*/

      GridItem() {
        Item({
          title: String.chinese_knowledge
        }).onClick(() => [
          this.pageStack.pushPathByName('KnowledgeIndexPage', null)
        ])
      }

      GridItem() {
        Title({
          title: String.traditionalculture
        })
      }
      .columnStart(0)
      .columnEnd(1)

      GridItem() {
        Item({
          title: String.traditionalculture_festival
        }).onClick(() => {
          this.pageStack.pushPathByName('FestivalIndexPage', null)
        })
      }

      GridItem() {
        Item({
          title: String.traditionalculture_solarterm
        }).onClick(() => {
          this.pageStack.pushPathByName('SolarTermIndexPage', null)
        })
      }

      GridItem() {
        Item({
          title: String.traditionalculture_color
        }).onClick(() => {
          this.pageStack.pushPathByName('ColorIndexPage', null)
        })
      }

      /*GridItem() {
        Item({
          title: String.traditionalculture_calendar
        }).onClick(() => {
          this.pageStack.pushPathByName('CalendarIndexPage', null)
        })
      }*/

      GridItem() {
        Title({
          title: String.china
        })
      }
      .columnStart(0)
      .columnEnd(1)

      GridItem() {
        Item({
          title: String.china_worldcultureheritage
        }).onClick(() => {
          this.pageStack.pushPathByName('WorldCulturalHeritageIndexPage', null)
        })
      }
    }
    .width('100%')
    .columnsGap(16)
    .rowsGap(16)
    .columnsTemplate('1fr 1fr')
    .padding(16)
  }
}