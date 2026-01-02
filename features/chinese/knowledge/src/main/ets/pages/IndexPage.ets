import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { getRandomKnowledge, Knowledge } from '../model/Knowledge';
import { KnowledgeView } from '../view/KnowledgeView';
import { AppStorageV2 } from '@kit.ArkUI';
import KnowledgeViewModel from '../viewmodel/KnowledgeViewModel';
import { Bookmark } from 'bookmark';
import { Logger } from 'utils';

let logger: Logger = new Logger('KnowledgeIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local knowledge: Knowledge | undefined;
  @Local bookmarked: Bookmark | undefined;

  aboutToAppear(): void {
    this.refresh();
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.knowledge) {
          KnowledgeView({ knowledge: this.knowledge })
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.chinese_knowledge)
    .menus([
      {
        value: String.bookmark,
        icon: Icon.ic_bookmark_border,
        action: (() => {
          this.pageStack.pushPathByName("KnowledgeBookmarkPage", null)
        })
      },
      {
        value: String.snapshot,
        icon: Icon.ic_public_picture,
        action: (() => {
          if (this.knowledge) {
            this.pageStack.pushPathByName("KnowledgeSnapshotPage", new ParamNumberId(this.knowledge.id))
          }
        })
      },
      {
        value: String.search,
        icon: Icon.ic_public_search,
        action: (() => {
          this.pageStack.pushPathByName("KnowledgeSearchPage", null)
        })
      }
    ])
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            KnowledgeViewModel.cancelBookmark(this.knowledge?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            KnowledgeViewModel.addBookmark(this.knowledge?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.knowledge ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      },
      {
        "value": String.refresh,
        "icon": Icon.ic_public_refresh,
        "action": () => {
          this.refresh()
        }
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }

  refresh() {
    getRandomKnowledge().then((value: Knowledge | undefined) => {
      this.knowledge = value;
      if (value) {
        KnowledgeViewModel.getBookmark(value.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}
