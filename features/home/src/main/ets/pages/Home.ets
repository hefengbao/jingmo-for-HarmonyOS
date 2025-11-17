import { BlockTitle, BlockItem } from '../view/Block'
import { Settings, About } from 'settings'
import { PageName } from 'config'

@ComponentV2
export struct Home {
  @Provider('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  @Builder
  PagesMap(name: string) {
    if (name == PageName.Settings) {
      Settings();
    }else if (name == PageName.About){
      About()
    }
  }

  build() {
    Navigation(this.pageStack){
      Row(){
        Text($r('app.string.app_name'))
          .fontSize(24)
        Blank()
        Text('设置')
          .onClick(() => {
            this.pageStack.pushPathByName(PageName.Settings, "")
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16})
      .alignItems(VerticalAlign.Center)

      Scroll(){
        Grid(){
          GridItem(){
            BlockTitle({
              title: "古诗文"
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem(){
            BlockItem({
              title: "经典诗文"
            })
          }

          GridItem(){
            BlockItem({
              title: "诗文名句"
            })
          }

          GridItem(){
            BlockTitle({
              title: "现代汉语"
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem(){
            BlockItem({
              title: "汉字"
            })
          }

          GridItem(){
            BlockItem({
              title: "词语"
            })
          }

          GridItem(){
            BlockItem({
              title: "成语"
            })
          }

          GridItem(){
            BlockItem({
              title: "对联"
            })
          }

          GridItem(){
            BlockItem({
              title: "句子"
            })
          }

          GridItem(){
            BlockItem({
              title: "诗歌"
            })
          }

          GridItem(){
            BlockItem({
              title: "知识卡片"
            })
          }

          GridItem(){
            BlockTitle({
              title: "传统文化"
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem(){
            BlockItem({
              title: "节日"
            })
          }

          GridItem(){
            BlockItem({
              title: "节气"
            })
          }

          GridItem(){
            BlockItem({
              title: "传统色"
            })
          }

          GridItem(){
            BlockTitle({
              title: "中国"
            })
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem(){
            BlockItem({
              title: "世界遗产名录"
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
    .navDestination(this.PagesMap)
    .title("京墨文库")
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
