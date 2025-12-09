import { BlockTitle } from 'uicomponents';
import { AdvancedDialogV2Button, SelectDialogV2 } from '@kit.ArkUI';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { ThemeConst } from 'constants';

@Builder
export function SettingPageBuilder() {
  SettingPage();
}

@ComponentV2
export struct SettingPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local themeMode: number = PrefUtil.getSettingThemeMode(); // 选中项索引

  @Builder
  dialogBuilder(): void {
    SelectDialogV2({
      title: '请选择模式', // 必选标题
      selectedIndex: this.themeMode, // 当前选中项
      confirm: new AdvancedDialogV2Button({
        content: '取消',
        action: () => {
        },
      }),
      radioContent: [
        {
          title: '跟随系统',
          action: () => {
            PrefUtil.saveSettingThemeMode(0);
            this.themeMode = PrefUtil.getSettingThemeMode();
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            try {
              context.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
            } catch (error) {
              this.getUIContext().getPromptAction().showToast({
                'message': '设置深色模式失败',
                'duration': 1000
              })
            }
          }
        },
        {
          title: '深色模式',
          action: () => {
            PrefUtil.saveSettingThemeMode(1);
            this.themeMode = PrefUtil.getSettingThemeMode();
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            try {
              context.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
            } catch (error) {
              this.getUIContext().getPromptAction().showToast({
                'message': '设置深色模式失败',
                'duration': 1000
              })
            }
          }
        },
        {
          title: '浅色模式',
          action: () => {
            PrefUtil.saveSettingThemeMode(2);
            this.themeMode = PrefUtil.getSettingThemeMode();
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            try {
              context.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
            } catch (error) {
              this.getUIContext().getPromptAction().showToast({
                'message': '设置深色模式失败',
                'duration': 1000
              })
            }
          }
        },
      ]
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          BlockTitle({ title: $r('app.string.ui') })
          Item({ title: $r('app.string.theme_setting') })
            .onClick(() => {
              let uiContext: UIContext = this.getUIContext();
              uiContext.getPromptAction().openCustomDialog({
                builder: () => {
                  this.dialogBuilder();
                }
              }).catch(() => {
                // TODO: Implement error handling.
              })
            })
          BlockTitle({ title: $r('app.string.feature') })
          Item({ title: $r('app.string.sync_data') })
            .onClick(() => {
              this.pageStack.pushPathByName('SyncDataPage', null)
            })
          Item({ title: $r('app.string.import_data') })
            .onClick(() => {
              this.pageStack.pushPathByName('ImportDataPage', null)
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
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
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
        pressed: {
          .backgroundColor(ThemeConst.BackGroundColor_Pressed)
        }
      })
  }
}
