import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import { ConfigurationConstant, UIAbility } from '@kit.AbilityKit';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { AppStorageV2 } from '@kit.ArkUI';
import { AvoidAreaObserver, ThemeColorModeObserver } from 'constants';
import { Configuration } from '@ohos.app.ability.Configuration';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    PrefUtil.init(this.context)
    AppStorageV2.connect<ThemeColorModeObserver>(ThemeColorModeObserver,
      () => new ThemeColorModeObserver(this.context.config.colorMode ??
      ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET))
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    /**
     * newConfig.colorMode 返回的值只有 0（COLOR_MODE_DARK） 和 1（COLOR_MODE_LIGHT）
     */
    let themeColorModeObserver =
      AppStorageV2.connect<ThemeColorModeObserver>(ThemeColorModeObserver,
        () => new ThemeColorModeObserver(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)!);
    if (newConfig.colorMode != undefined && newConfig.colorMode !== themeColorModeObserver?.mode) {
      AppStorageV2.connect<ThemeColorModeObserver>(ThemeColorModeObserver,
        () => new ThemeColorModeObserver(newConfig.colorMode!))
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    DbUtil.init(this.context)
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });


    let applicationContext = this.context.getApplicationContext();
    try {
      applicationContext.setColorMode(
        PrefUtil.getSettingThemeMode() == 0 ? ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET :
          (PrefUtil.getSettingThemeMode() == 1 ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK :
            ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
      );
    } catch (error) {
      // TODO: Implement error handling.
    }

    /**
     * 尝试解决如下问题：
     * 应用未适配导航条，底部控件抬高避让小于28vp:
     * 1、控件序号：[1]，控件坐标：[[0,2473][1260,2720]]，控件类型：[ToolBar]
     */
    window.getLastWindow(this.context, (err: BusinessError, windowClass) => {
      if (err) {
        return;
      }

      // 初始化获取避让区
      const navigation = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
      try {
        let avoidArea = windowClass.getWindowAvoidArea(navigation);
        AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver(avoidArea))
      } catch (error) {
        hilog.info(DOMAIN, 'getWindowAvoidArea(navigation) fail', `error = ${error}`);
      }

      // 监听窗口变化
      windowClass.on('windowSizeChange', () => {
        try {
          let avoidArea = windowClass.getWindowAvoidArea(navigation);
          AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver(avoidArea))
        } catch (error) {
          hilog.info(DOMAIN, 'getWindowAvoidArea(navigation) fail', `error = ${error}`);
        }

      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
