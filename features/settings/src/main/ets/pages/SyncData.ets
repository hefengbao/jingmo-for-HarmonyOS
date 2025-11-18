import { Logger } from 'utils'
import DatasetViewModel from '../viewmodel/DatasetViewModel'
import DatasetModel from '../model/DatasetModel'

@ComponentV2
export struct SyncData {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack()
  @Local logger: Logger = new Logger()

  aboutToAppear(): void {
    DatasetViewModel.getDatasetList().then((list: DatasetModel[]) => {
      this.logger.info(list.toString())
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {

        }
      }
    }
    .title($r('app.string.sync_data'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}