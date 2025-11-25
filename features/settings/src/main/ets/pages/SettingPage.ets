import { ThemeConst } from 'constants';
import { BlockTitle } from 'uicomponents';

@Builder
export function SettingPageBuilder() {
  SettingPage();
}

@ComponentV2
export struct SettingPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          BlockTitle({ title: $r('app.string.feature') })
          Item({ title: $r('app.string.sync_data') })
            .onClick(() => {
              this.pageStack.pushPathByName('SyncDataPage', null)
            })
          BlockTitle({ title: $r('app.string.privacy') })
          Item({ title: $r('app.string.tos') })
            .onClick(() => {
              this.pageStack.pushPathByName("TosPage", null)
            })
          Item({ title: $r('app.string.privacy_policy') })
            .onClick(() => {
              this.pageStack.pushPathByName("PrivacyPage", null)
            })
          Item({ title: $r('app.string.collected_user_info') })
            .onClick(() => {
              this.pageStack.pushPathByName("CollectedUserInfoPage", null)
            })
          Item({ title: $r('app.string.shared_user_info') })
            .onClick(() => {
              this.pageStack.pushPathByName("SharedUserInfoPage", null)
            })
          BlockTitle({ title: $r('app.string.other') })
          Item({ title: $r('app.string.about') })
            .onClick(() => {
              this.pageStack.pushPathByName('AboutPage', null)
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
