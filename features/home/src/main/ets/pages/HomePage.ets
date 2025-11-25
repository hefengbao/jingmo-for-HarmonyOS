import { TopBar } from '../view/TopBar';
import { MenuList } from '../view/MenuList';

@ComponentV2
export struct HomePage {
  @Provider('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Column() {
        TopBar({ pageStack: this.pageStack })
        MenuList({ pageStack: this.pageStack })
      }
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
