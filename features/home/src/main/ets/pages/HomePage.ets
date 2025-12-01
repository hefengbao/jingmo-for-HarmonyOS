import { TopBar } from '../view/TopBar';
import { MenuList } from '../view/MenuList';
import { AppConst } from 'constants';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import { UserAgreement } from '../view/UserAgreement';
import { Logger } from 'utils';

let logger: Logger = new Logger('HomePage')

@ComponentV2
export struct HomePage {
  @Provider('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local userAgreementVersionPref: number = PrefUtil.getUserAgreementVersion();
  observer = (key: string) => {
    this.userAgreementVersionPref = PrefUtil.getUserAgreementVersion()
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
        Column() {
          TopBar({ pageStack: this.pageStack })
          MenuList({ pageStack: this.pageStack })
        }
      }
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
