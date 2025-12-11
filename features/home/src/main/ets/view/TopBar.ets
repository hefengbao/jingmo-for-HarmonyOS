import { Icon, String } from 'constants';

@ComponentV2
export struct TopBar {
  @Param @Require @Once pageStack: NavPathStack;

  build() {
    Row() {
      Text(String.app_name)
        .fontSize($r('sys.float.titlebar_main_title_text_font_size_min'))
        .fontWeight(FontWeight.Bold)
        .margin({
          left: $r('sys.float.titlebar_title_margin_left'),
          right: $r('sys.float.titlebar_title_margin_right')
        })
      Blank()
      CustomMenuItem({
        icon: Icon.ic_bookmark_border,
        pageStack: this.pageStack,
        pathName: "BookmarkIndexPage"
      })
      CustomMenuItem({
        icon: Icon.ic_link,
        pageStack: this.pageStack,
        pathName: "LinkIndexPage"
      })
      CustomMenuItem({
        icon: Icon.ic_public_settings,
        pageStack: this.pageStack,
        pathName: "SettingPage"
      })
    }
    .width('100%')
    .height($r('sys.float.titlebar_default_height'))
    .padding({ left: $r('sys.float.titlebar_padding_left'), right: $r('sys.float.titlebar_padding_right') })
    .alignItems(VerticalAlign.Center)
  }
}

@ComponentV2
struct CustomMenuItem {
  @Param @Require @Once pageStack: NavPathStack;
  @Param @Require icon: Resource;
  @Param @Require pathName: string;

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Image(this.icon)
        .width($r('sys.float.titlebar_icon_width'))
        .height($r('sys.float.titlebar_icon_height'))
        .fillColor($r('sys.color.icon'))
    }
    .padding(8)
    .margin({ right: $r('sys.float.titlebar_menu_margin_right') })
    .onClick(() => {
      this.pageStack.pushPathByName(this.pathName, null)
    })
    .stateStyles({
      normal: {
        .backgroundColor($r('sys.color.titlebar_icon_background_color'))
        .borderRadius(18)
      },
      pressed: {
        .backgroundColor($r('sys.color.titlebar_icon_background_pressed_color'))
        .borderRadius(18)
      }
    })
  }
}