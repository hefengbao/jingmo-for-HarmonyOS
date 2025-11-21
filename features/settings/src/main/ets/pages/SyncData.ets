import { BusinessError } from '@kit.BasicServicesKit'
import { DataWrapper, Logger } from 'utils';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import Dataset from '../model/Dataset';
import { ClassicPoem, } from 'classicalliterature_classicpoem';

@Builder
export function SyncDataBuilder() {
  SyncData()
}

@ComponentV2
export struct SyncData {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack()
  @Local logger: Logger = new Logger('SyncData')
  @Local dataset: Dataset[] = []

  aboutToAppear(): void {
    DatasetViewModel.getDatasetList().then((list: Dataset[]) => {
      this.dataset = list
      this.logger.info(list.toString())
    }).catch((error: string) => {
      this.logger.error(error)
    })

    DatasetViewModel.getClassicPoemList().then((data: string) => {
      this.logger.info(data)
      let wrapper: DataWrapper<ClassicPoem> = JSON.parse(data)
      this.logger.info(wrapper.total.toString())
      wrapper.data.map((classicPoem:ClassicPoem, index: number) => {
        this.logger.info(`index = ${index}`)
        DatasetViewModel.insertClassicPoemToDb(classicPoem)
      })
    }).catch((error: BusinessError) => {
      this.logger.error(`code = ${error.code}, msg = ${error.message}`)
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