import { window } from '@kit.ArkUI';
import { ConfigurationConstant } from '@kit.AbilityKit';

export class AppConst {
  static readonly DB_VERSION = 3; // 数据库迁移更新后，更新此值
  static readonly USER_AGREEMENT_VERSION = 1; // 用户协议更新后，更新此值
  static readonly ICP = '蜀ICP备17009649号-10A';
}

@ObservedV2
export class AvoidAreaObserver {
  @Trace navigation?: window.AvoidArea

  constructor(navigation?: window.AvoidArea) {
    this.navigation = navigation;
  }
}

@ObservedV2
export class ThemeColorModeObserver {
  @Trace mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET

  constructor(mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
    this.mode = mode;
  }
}