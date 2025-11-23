import { BusinessError } from '@kit.BasicServicesKit';
import { DataWrapper, Logger } from 'utils';
import { Icon, NetworkConst, String, ThemeConst } from 'constants';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import Dataset from '../model/Dataset';
import { ClassicPoem } from 'classicalliterature_classicpoem';
import { BlockTitle } from 'uicomponents';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';

@Builder
export function SyncDataBuilder() {
  SyncData()
}

@ComponentV2
export struct SyncData {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local logger: Logger = new Logger('SyncData');
  @Local dataset: Dataset[] = [];
  @Local getDatasetListLoading: boolean = false;
  @Local classicalliterature_classicpoem_local_version: number = PrefUtil.getClassicalCultureClassicPoemVersion();

  aboutToAppear(): void {
    this.getDatasetList()
  }

  getDatasetList() {
    DatasetViewModel.getDatasetList().then((list: Dataset[]) => {
      this.dataset = list
      this.logger.info(list.toString())
    }).catch((error: string) => {
      this.logger.error(error)
    })
  }

  syncClassicPoem() {
    let page: number | null = 1;

    DatasetViewModel.getClassicPoemList(this.dataset.filter((item: Dataset) => {
      return item.name == NetworkConst.CLASSICALLITERATURE_CLASSICPOEM
    })[0].version, page)
      .then((data: string) => {
        this.logger.info(data)
        let wrapper: DataWrapper<ClassicPoem> = JSON.parse(data)
        this.logger.info(wrapper.total.toString())
        wrapper.data.map((classicPoem: ClassicPoem, index: number) => {
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
          BlockTitle({ title: String.classicalliterature })
          Item({
            title: String.classicalliterature_classicpoem,
            remoteVersion: 3,
            localVersion: 0,
            total: 955,
            value: 0,
            loading: false,
            clickEvent: (() => {
              this.syncClassicPoem()
            })
          })
        }
        .height('100%')
        .width('100%')
      }
      .height('100%')
      .width('100%')
      .padding(16)
      .edgeEffect(EdgeEffect.Spring)
    }
    .title($r('app.string.sync_data'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}

@Preview
@ComponentV2
struct Item {
  @Param @Require @Once title: string | Resource;
  @Param @Require @Once remoteVersion: number;
  @Param @Require localVersion: number;
  @Param @Require @Once total: number;
  @Param @Require value: number;
  @Param @Require loading: boolean
  @Event clickEvent: () => void = () => {
  };

  build() {
    Row() {
      Column() {
        Text(this.title)
        Text(this.total.toString())
          .fontSize(ThemeConst.FontSize_14)
          .fontColor(Color.Gray)
          .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Start)

      Blank()
      if (this.loading) {
        Progress({ value: this.value, total: this.total, type: ProgressType.Ring })
          .width(24)
          .height(24)
          .margin({ right: 16 })
      }
      if (this.localVersion == this.remoteVersion) {
        Image(Icon.ic_public_todo_filled)
          .height(20)
          .width(20)
          .margin({ right: 16 })
      } else {
        Image(Icon.ic_public_todo)
          .height(20)
          .width(20)
          .margin({ right: 16 })
      }
      Image(Icon.ic_public_cloud_download)
        .height(36)
        .width(36)
        .padding(8)
        .stateStyles({
          normal: {
            .backgroundColor(ThemeConst.BackGroundColor_Normal)
          },
          clicked: {
            .backgroundColor(ThemeConst.BackGroundColor_Clicked)
            .borderRadius(18)
          }
        })
        .onClick(this.clickEvent)
    }
    .width('100%')
    .padding(16)
    .alignItems(VerticalAlign.Center)
  }
}