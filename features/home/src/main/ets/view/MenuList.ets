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

      /*GridItem() {
        Item({
          title: String.classicalliterature_writing
        }).onClick(() => {
          this.pageStack.pushPathByName('WritingIndexPage', null)
        })
      }*/

      GridItem() {
        Item({
          title: String.classicalliterature_sentence
        }).onClick(() => {
          this.pageStack.pushPathByName('SentenceIndexPage', null)
        })
      }

      GridItem() {
        Item({
          title: String.classicalliterature_people
        }).onClick(() => {
          this.pageStack.pushPathByName('PeopleIndexPage', null)
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
          title: String.chinese_wisecrack
        }).onClick(() => [
          this.pageStack.pushPathByName('WisecrackIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_proverb
        }).onClick(() => [
          this.pageStack.pushPathByName('ProverbIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_riddle
        }).onClick(() => [
          this.pageStack.pushPathByName('RiddleIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_tonguetwister
        }).onClick(() => [
          this.pageStack.pushPathByName('TongueTwisterIndexPage', null)
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
          title: String.chinese_lyric
        }).onClick(() => [
          this.pageStack.pushPathByName('LyricIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_quote
        }).onClick(() => [
          this.pageStack.pushPathByName('QuoteIndexPage', null)
        ])
      }

      GridItem() {
        Item({
          title: String.chinese_modernpoetry
        }).onClick(() => [
          this.pageStack.pushPathByName('ModernPoetryIndexPage', null)
        ])
      }

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