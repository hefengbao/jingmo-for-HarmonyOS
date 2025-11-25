import Dataset from '../model/Dataset';
import { CheckDataset } from '../view/CheckDataset';
import { SyncDataList } from '../view/SyncDataList';

@Builder
export function SyncDataPageBuilder() {
  SyncDataPage();
}

@ComponentV2
export struct SyncDataPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local dataset: Dataset[] = [];

  build() {
    NavDestination() {
      Scroll() {
        if (this.dataset.length) {
          SyncDataList({
            dataset: this.dataset
          })
        } else {
          CheckDataset({
            dataset: this.dataset,
            changeDataset: ((dataset: Dataset[]) => {
              this.dataset = dataset
            })
          })
        }
      }
      .height('100%')
      .width('100%')
      .padding(16)
      .edgeEffect(EdgeEffect.Spring)
    }
    .title($r('app.string.sync_data'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}

