import { BlockItem, BlockTitle } from '../view/Block';
import { Icon, String, ThemeConst } from 'constants';

@ComponentV2
export struct Home {
  @Provider('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Row() {
        Text(String.app_name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Blank()
        Image(Icon.ic_public_settings)
          .onClick(() => {
            this.pageStack.pushPathByName("Settings", null)
          })
          .width(36)
          .height(36)
          .padding(8)
          .stateStyles({
            normal: {
              .backgroundColor(ThemeConst.BackGroundColor_Normal)
            },
            clicked: {
              .backgroundColor(ThemeConst.BackGroundColor_Clicked)
              .borderRadius(18)
            }
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Grid() {
          GridItem() {
            BlockTitle({
              title: String.classicalliterature
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem() {
            BlockItem({
              title: String.classicalliterature_classicpoem
            }).onClick(() => {
              this.pageStack.pushPathByName('ClassicPoem', null)
            })
          }

          GridItem() {
            BlockItem({
              title: String.classicalliterature_sentence
            })
          }

          GridItem() {
            BlockTitle({
              title: String.chinese
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem() {
            BlockItem({
              title: String.chinese_character
            })
          }

          GridItem() {
            BlockItem({
              title: String.chinese_expression
            })
          }

          GridItem() {
            BlockItem({
              title: String.chinese_idiom
            })
          }

          GridItem() {
            BlockItem({
              title: String.chinese_antitheticalcouplet
            })
          }

          GridItem() {
            BlockItem({
              title: String.chinese_quote
            })
          }

          GridItem() {
            BlockItem({
              title: String.chinese_modernpoetry
            })
          }

          GridItem() {
            BlockItem({
              title: String.chinese_knowledge
            })
          }

          GridItem() {
            BlockTitle({
              title: String.traditionalculture
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem() {
            BlockItem({
              title: String.traditionalculture_festival
            })
          }

          GridItem() {
            BlockItem({
              title: String.traditionalculture_solarterm
            })
          }

          GridItem() {
            BlockItem({
              title: String.traditionalculture_color
            })
          }

          GridItem() {
            BlockTitle({
              title: String.china
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem() {
            BlockItem({
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
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
