import { TopBar } from '../view/TopBar';
import { MenuList } from '../view/MenuList';
import { AppConst, AvoidAreaObserver, PrefConst } from 'constants';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { UserAgreement } from '../view/UserAgreement';
import { Logger } from 'utils';
import { AppStorageV2, PromptAction, ShowDialogSuccessResponse } from '@kit.ArkUI';

let logger: Logger = new Logger('HomePage')

@ComponentV2
export struct HomePage {
  @Provider('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local userAgreementVersionPref: number = PrefUtil.getUserAgreementVersion();
  @Local isFirstLaunchPref: boolean = PrefUtil.getIsFirstLaunch();
  @Local promptAction: PromptAction = this.getUIContext().getPromptAction();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local scroller: Scroller = new Scroller();
  @Local observer: Callback<string> = (key: string) => {
    if (key == PrefConst.USER_AGREEMENT_VERSION) {
      this.userAgreementVersionPref = PrefUtil.getUserAgreementVersion();
    } else if (key == PrefConst.IS_FIRST_LAUNCH) {
      this.isFirstLaunchPref = PrefUtil.getIsFirstLaunch();
    }
  }

  aboutToAppear(): void {
    try {
      PrefUtil.preference?.on('change', this.observer)
    } catch (error) {
      logger.error(`preference add change observer error = ${error}`);
    }
  }

  aboutToRecycle(): void {
    try {
      PrefUtil.preference?.off('change', this.observer)
    } catch (error) {
      logger.error(`preference off change observer error = ${error}`);
    }
  }

  build() {
    Navigation(this.pageStack) {
      if (AppConst.USER_AGREEMENT_VERSION > this.userAgreementVersionPref) {
        UserAgreement({ pageStack: this.pageStack })
      } else {
        Scroll(this.scroller) {
          Column() {
            TopBar({ pageStack: this.pageStack })
            MenuList({ pageStack: this.pageStack })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .padding({
          bottom: this.avoidAreaObserver.navigation?.bottomRect.height
        })
        .onAppear(() => {
          if (this.isFirstLaunchPref) {
            this.promptAction.showDialog({
              'title': '温馨提示',
              'message': 'APP 以【离线数据】的方式提供服务，所以首次使用时请点击右上角【设置】，点击【同步数据】或者【导入数据】获取数据。\n成功获取数据后如果出现点击进入功能模块仍然显示空白的情况，请完全退出 APP 后重新打开。',
              'buttons': [
                {
                  text: '知道了',
                  color: $r('sys.color.popup_text_primary_color'),
                },
              ]
            }, (error: BusinessError, data: ShowDialogSuccessResponse) => {
              if (data.index == 0) {
                PrefUtil.saveIsFirstLaunch(false)
              }
            })
          }
        })
      }
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}