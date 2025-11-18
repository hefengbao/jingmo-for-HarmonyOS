import { Logger } from 'utils';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import DatasetModel from '../model/DatasetModel';

@Builder
export function SyncDataBuilder() {
  SyncData()
}

@ComponentV2
export struct SyncData {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack()
  @Local logger: Logger = new Logger('SyncData')
  @Local error: string = ''
  @Local dataset: DatasetModel[] = []

  aboutToAppear(): void {
    DatasetViewModel.getDatasetList().then((list: DatasetModel[]) => {
      this.dataset = list
      this.logger.info(list.toString())
    }).catch((error: string) => {
      this.error = error
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {

        }
      }
      .height('100%')
      .width('100%')
      .edgeEffect(EdgeEffect.Spring)
    }
    .title($r('app.string.sync_data'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}