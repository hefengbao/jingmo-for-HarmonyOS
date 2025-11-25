import { Icon, String, ThemeConst } from 'constants';

@ComponentV2
export struct TopBar {
  @Param @Require @Once pageStack: NavPathStack;

  build() {
    Row() {
      Text(String.app_name)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Blank()
      Image(Icon.ic_public_settings)
        .onClick(() => {
          this.pageStack.pushPathByName("SettingPage", null)
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
  }
}