import { ParamNumberId, String, ThemeConst } from 'constants';
import { ClassicPoem, getBookmarks } from '../model/ClassicPoem';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'utils';
import { uiObserver } from '@kit.ArkUI';

let logger: Logger = new Logger('ClassicPoemBookmarkPage');

@Builder
export function BookmarkPageBuilder() {
  BookmarkPage()
}

@ComponentV2
export struct BookmarkPage {
  @Consumer("NavStackPath") pageStack: NavPathStack = new NavPathStack();
  @Local classicPoems: ClassicPoem[] = []

  aboutToAppear(): void {
    uiObserver.on('navDestinationUpdate', (info: uiObserver.NavDestinationInfo) => {
      // logger.info(`NavDestination state update ${JSON.stringify(info)}`);
      // 初次加载状态码： 6 2 4 0 8
      // 回退返回到本页面状态码： 4 0 8
      // 在这里加载数据，是为了确保用户在查看页面取消了收藏时收藏列表数据会更新
      if (info.name == 'ClassicPoemBookmarkPage' && info.state == 4) {
        getBookmarks().then((value: ClassicPoem[]) => {
          this.classicPoems = value
          logger.info(`getBookmarks successful, count = ${value.length}`)
        }).catch((error: BusinessError) => {
          logger.error(`getBookmarks failed, code = ${error.code}, message = ${error.message}`)
        })
      }
    });
  }

  aboutToDisappear() {
    uiObserver.off('navDestinationUpdate');
  }

  build() {
    NavDestination() {
      List() {
        Repeat<ClassicPoem>(this.classicPoems)
          .each((repeatItem: RepeatItem<ClassicPoem>) => {
            ListItem() {
              Item({ classicPoem: repeatItem.item })
                .onClick(() => {
                  this.pageStack.pushPathByName('ClassicPoemShowPage', new ParamNumberId(repeatItem.item.id))
                })
            }
          })
          .key((item: ClassicPoem) => `${item.id}`)
      }
      .width('100%')
      .height('100%')
      .divider({ strokeWidth: 2 })
      .edgeEffect(EdgeEffect.Spring)
      .alignListItem(ListItemAlign.Start)
      .align(Alignment.TopStart)
    }
    .title(String.bookmark)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}

@ComponentV2
struct Item {
  @Param @Require classicPoem: ClassicPoem

  build() {
    Column() {
      Text(this.classicPoem.title)
        .width('100%')
        .padding({
          left: 16,
          top: 12,
          right: 16,
          bottom: 8
        })
      Text(`${this.classicPoem.dynasty}·${this.classicPoem.writer}`)
        .width('100%')
        .padding({
          left: 16,
          right: 16,
          bottom: 12
        })
        .fontSize(ThemeConst.FontSize_14)
    }
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