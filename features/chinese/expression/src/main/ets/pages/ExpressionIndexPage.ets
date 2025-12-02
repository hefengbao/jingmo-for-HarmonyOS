import { AvoidAreaObserver, Icon, String } from 'constants';
import { Expression, readRandomClassicPoem } from '../model/Expression';
import { ExpressionView } from '../view/ExpressionView';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function ExpressionIndexPageBuilder() {
  ExpressionIndexPage();
}

@ComponentV2
export struct ExpressionIndexPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local expression: Expression | null = null;

  aboutToAppear(): void {
    this.refresh();
  }

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
      this.pageStack = ctx.pathStack
    })
  }

  refresh() {
    readRandomClassicPoem().then((value: Expression | null) => {
      this.expression = value;
    })
  }
}
