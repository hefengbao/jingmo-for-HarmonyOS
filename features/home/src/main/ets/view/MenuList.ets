import { Item, Title } from './Menu';
import { String } from 'constants';

@ComponentV2
export struct MenuList {
  @Param @Require @Once pageStack: NavPathStack;

  build() {
    Scroll() {
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
          })
        }

        GridItem() {
          Item({
            title: String.chinese_expression
          })
        }

        GridItem() {
          Item({
            title: String.chinese_idiom
          })
        }

        GridItem() {
          Item({
            title: String.chinese_antitheticalcouplet
          })
        }

        GridItem() {
          Item({
            title: String.chinese_quote
          })
        }

        GridItem() {
          Item({
            title: String.chinese_modernpoetry
          })
        }

        GridItem() {
          Item({
            title: String.chinese_knowledge
          })
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
          })
        }

        GridItem() {
          Item({
            title: String.traditionalculture_solarterm
          })
        }

        GridItem() {
          Item({
            title: String.traditionalculture_color
          })
        }

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
          })
        }
      }
      .width('100%')
      .height('100%')
      .columnsGap(12)
      .rowsGap(12)
      .columnsTemplate('1fr 1fr')
      .padding(8)
    }
  }
}