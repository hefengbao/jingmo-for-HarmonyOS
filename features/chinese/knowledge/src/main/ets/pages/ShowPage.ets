import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { getKnowledge, Knowledge } from '../model/Knowledge';
import { KnowledgeView } from '../view/KnowledgeView';
import { AppStorageV2 } from '@kit.ArkUI';
import KnowledgeViewModel from '../viewmodel/KnowledgeViewModel';
import { Bookmark } from 'bookmark';
import { Logger } from 'utils';

let logger: Logger = new Logger('KnowledgeShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local knowledge: Knowledge | undefined;
  @Local bookmarked: Bookmark | undefined;

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
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        getKnowledge(param.id).then((value: Knowledge | undefined) => {
          this.knowledge = value;
        })

        KnowledgeViewModel.getBookmark(param.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}
