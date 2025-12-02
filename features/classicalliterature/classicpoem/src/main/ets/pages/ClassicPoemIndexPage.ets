import { ClassicPoem, readRandomClassicPoem } from '../model/ClassicPoem';
import { AvoidAreaObserver, Icon, String } from 'constants';
import { ClassicPoemView } from '../view/ClassicPoemView';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
export function ClassicPoemIndexPageBuilder() {
  ClassicPoemIndexPage();
}

@ComponentV2
export struct ClassicPoemIndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local classicPoem: ClassicPoem | null = null;

  aboutToAppear(): void {
    this.refresh()
  }

  refresh() {
    readRandomClassicPoem().then((value: ClassicPoem | null) => {
      this.classicPoem = value
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        if (this.classicPoem) {
          ClassicPoemView({
            classicPoem: this.classicPoem
          })
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
    }
    .title(String.classicalliterature_classicpoem)
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
}
