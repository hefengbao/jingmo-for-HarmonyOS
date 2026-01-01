export class ThemeConst {
  static readonly BackGroundColor_Pressed = $r('app.color.background_color_pressed');
  static readonly BackGroundColor_Normal = $r('sys.color.background_primary');
  static readonly CardBackGroundColor_Normal = $r('app.color.card_background_color_normal');
  static readonly CardBackGroundColor_Pressed = $r('app.color.card_background_color_pressed');
  static readonly FontColor_BlockTitle = '#ff7a7a7a';
  static readonly FontSize_BlockTitle = 14;
  static readonly FontSize_14 = 14;
  static readonly P_8: Length = 8;
  static readonly P_16: Length = 16;
  static readonly PY_16: Padding = { top: 16, bottom: 16 };
  static readonly PX_16: Padding = { left: 16, right: 16 };
  static readonly P_X16_Y8: Padding = {
    left: 16,
    top: 8,
    right: 16,
    bottom: 8
  };
  static readonly ListDivider: ListDividerOptions = {
    strokeWidth: 1,
    color: $r('sys.color.ohos_id_color_text_primary'),
    startMargin: ThemeConst.P_16,
    endMargin: ThemeConst.P_16
  }
}