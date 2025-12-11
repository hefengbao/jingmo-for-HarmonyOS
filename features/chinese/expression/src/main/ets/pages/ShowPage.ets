import { AvoidAreaObserver, Icon, ParamNumberId, String } from 'constants';
import { Expression, getExpression } from '../model/Expression';
import { ExpressionView } from '../view/ExpressionView';
import { AppStorageV2 } from '@kit.ArkUI';
import { Bookmark } from 'bookmark';
import ExpressionViewModel from '../viewmodel/ExpressionViewModel';
import { Logger } from 'utils';

let logger: Logger = new Logger('ExpressionShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local expression: Expression | undefined;
  @Local bookmarked: Bookmark | undefined;

  build() {
    NavDestination() {
      Scroll() {
        if (this.expression) {
          ExpressionView({ expression: this.expression })
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
    .title(String.chinese_expression)
    .toolbarConfiguration([
      {
        "value": this.bookmarked ? String.cancel_bookmark : String.add_bookmark,
        "icon": this.bookmarked ? Icon.ic_bookmark : Icon.ic_bookmark_border,
        "action": () => {
          if (this.bookmarked) {
            ExpressionViewModel.cancelBookmark(this.expression?.id)
              .then(() => {
                this.bookmarked = undefined;
              })
              .catch((error: BusinessError) => {
                logger.error(`cancel bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          } else {
            ExpressionViewModel.addBookmark(this.expression?.id)
              .then((value: Bookmark | undefined) => {
                this.bookmarked = value
              })
              .catch((error: BusinessError) => {
                logger.error(`add bookmark failed, code = ${error.code}, message = ${error.message}`)
              })
          }
        },
        status: this.expression ? ToolbarItemStatus.NORMAL : ToolbarItemStatus.DISABLED
      },
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        getExpression(param.id).then((value: Expression | undefined) => {
          this.expression = value;
        })

        ExpressionViewModel.getBookmark(param.id).then((value: Bookmark | undefined) => {
          this.bookmarked = value;
        })
      }
    })
  }
}
