import { PageName, ThemeConst } from 'constants'

@ComponentV2
export struct Settings {
  @Local message: string = 'Settings';
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Title({ title: $r('app.string.feature') })
          Item({ title: $r('app.string.sync_data') })
            .onClick(() => {
              this.pageStack.pushPathByName(PageName.SyncData, "")
            })
          Title({ title: $r('app.string.other') })
          Item({ title: $r('app.string.about') })
            .onClick(() => {
              this.pageStack.pushPathByName(PageName.About, "")
            })
        }
        .height('100%')
      }
      .height('100%')
    }
    .title($r('app.string.settings'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}

@Preview
@ComponentV2
struct Title {
  @Param @Once title: string | Resource = '其他'

  build() {
    Text(this.title)
      .width('100%')
      .padding({
        left: 16,
        top: 8,
        right: 16,
        bottom: 8
      })
      .fontColor(ThemeConst.FontColor_BlockTitle)
      .fontSize(ThemeConst.FontSize_BlockTitle)
  }
}

@Preview
@ComponentV2
struct Item {
  @Param @Once title: string | Resource = '关于'

  build() {
    Text(this.title)
      .width('100%')
      .padding({
        left: 16,
        top: 12,
        right: 16,
        bottom: 12
      })
      .stateStyles({
        normal: {
          .backgroundColor(ThemeConst.BackGroundColor_Normal)
        },
        clicked: {
          .backgroundColor(ThemeConst.BackGroundColor_Clicked)
        }
      })
  }
}
