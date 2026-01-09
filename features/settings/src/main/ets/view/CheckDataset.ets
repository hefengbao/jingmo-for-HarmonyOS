import { Logger } from 'utils';
import { ThemeConst } from 'constants';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import Dataset from '../model/Dataset';

let logger: Logger = new Logger('CheckDataset');

@ComponentV2
export struct CheckDataset {
  @Param @Require dataset: Dataset[]
  @Local datasetListLoading: boolean = true;
  @Local datasetListLoadingError: string = '';
  @Event changeDataset: (dataset: Dataset[]) => void = () => {
  };

  aboutToAppear(): void {
    this.getDatasetList()
  }

  build() {
    if (!this.dataset.length) {
      Column() {
        if (this.datasetListLoading) {
          LoadingProgress()
            .color($r('sys.color.ohos_id_color_text_primary'))
            .width(80)
            .height(80)
        } else {
          Text(this.datasetListLoadingError)
            .padding(ThemeConst.P_8)
          Text('如果多次尝试无果后，建议更换网络环境或者从网盘下载数据后导入。')
            .padding(ThemeConst.P_8)
          Button("点击重试")
            .padding(ThemeConst.P_8)
            .backgroundColor($r('sys.color.background_primary'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .onClick(() => this.getDatasetList())
        }
      }
      .width('100%')
      .height('100%')
    }
  }

  async getDatasetList() {
    this.datasetListLoading = true
    await DatasetViewModel.getDatasetList().then((list: Dataset[]) => {
      this.changeDataset(list)
      this.datasetListLoading = false;
    }).catch((error: string) => {
      this.datasetListLoading = false;
      this.datasetListLoadingError = error;
      logger.error(`${error}`);
    })
  }
}