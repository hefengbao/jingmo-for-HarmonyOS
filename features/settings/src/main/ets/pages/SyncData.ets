import { BusinessError } from '@kit.BasicServicesKit';
import { DataWrapper, Logger } from 'utils';
import { Icon, PrefConst, String, ThemeConst } from 'constants';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import Dataset from '../model/Dataset';
import { ClassicPoem } from 'classicalliterature_classicpoem';
import { Character } from 'chinese_character';
import { BlockTitle } from 'uicomponents';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';

let logger: Logger = new Logger('SyncData');

@Builder
export function SyncDataBuilder() {
  SyncData();
}

@ComponentV2
export struct SyncData {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local dataset: Dataset[] = [];
  @Local datasetListLoading: boolean = false;
  @Local datasetListLoadingError: string = '';
  @Local classicalliteratureClassicpoemLocalVersion: number = PrefUtil.getClassicalCultureClassicPoemVersion();
  @Local classicalliteratureClassicpoemRemoteVersion: number = 0;
  @Local classicalliteratureClassicpoemTotal: number = 0;
  @Local classicalliteratureClassicpoemCount: number = 0;
  @Local classicalliteratureClassicpoemLoading: boolean = false;
  @Local classicalliteratureClassicpoemLoadingError: string | null = null;
  @Local classicalliteratureClassicpoemLoadingPage: number | null = 1;
  @Local chineseCharacterLocalVersion: number = PrefUtil.getChineseCharacterVersion();
  @Local chineseCharacterRemoteVersion: number = 0;
  @Local chineseCharacterTotal: number = 0;
  @Local chineseCharacterCount: number = 0;
  @Local chineseCharacterLoading: boolean = false;
  @Local chineseCharacterLoadingError: string | null = null;
  @Local chineseCharacterLoadingPage: number | null = 1;

  aboutToAppear(): void {
    this.getDatasetList()
    try {
      PrefUtil.preference?.on('change', (key: String) => {
        if (key == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
          this.classicalliteratureClassicpoemLocalVersion = PrefUtil.getClassicalCultureClassicPoemVersion();
        }
      })
    } catch (error) {
      logger.error(`preference change observer error = ${error}`);
    }
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          if (this.dataset.length) {
            BlockTitle({ title: String.classicalliterature })
            Item({
              title: String.classicalliterature_classicpoem,
              remoteVersion: this.classicalliteratureClassicpoemRemoteVersion,
              localVersion: this.classicalliteratureClassicpoemLocalVersion,
              total: this.classicalliteratureClassicpoemTotal,
              progress: this.classicalliteratureClassicpoemCount,
              loading: this.classicalliteratureClassicpoemLoading,
              error: this.classicalliteratureClassicpoemLoadingError,
              clickEvent: (): void => {
                this.syncClassicalLiteratureClassicPoem(1)
              }
            })
            BlockTitle({ title: String.chinese })
            Item({
              title: String.chinese_character,
              remoteVersion: this.chineseCharacterRemoteVersion,
              localVersion: this.chineseCharacterLocalVersion,
              total: this.chineseCharacterTotal,
              progress: this.chineseCharacterCount,
              loading: this.chineseCharacterLoading,
              error: this.chineseCharacterLoadingError,
              clickEvent: (): void => {
                this.syncChineseCharacterPoem(1)
              }
            })
          } else {
            if (this.datasetListLoading) {
              LoadingProgress()
                .color(Color.Black)
                .width(80)
                .height(80)
            } else {
              Text(this.datasetListLoadingError)
                .padding(ThemeConst.P_8)
              Text('如果多次尝试无果后，建议更换网络环境或者从网盘下载数据后导入。')
                .padding(ThemeConst.P_8)
              Button("点击重试")
                .padding(ThemeConst.P_8)
                .backgroundColor(Color.Black)
                .fontColor(Color.White)
                .onClick(() => this.getDatasetList())
            }
          }
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
      this.pageStack = ctx.pathStack;
    })
  }

  async getDatasetList() {
    this.datasetListLoading = true
    await DatasetViewModel.getDatasetList().then((list: Dataset[]) => {
      this.dataset = list;
      list.forEach((item: Dataset) => {
        if (item.name == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
          this.classicalliteratureClassicpoemRemoteVersion = item.version;
          this.classicalliteratureClassicpoemTotal = item.count;
        } else if (item.name == PrefConst.CHINESE_CHARACTER) {
          this.chineseCharacterRemoteVersion = item.version;
          this.chineseCharacterTotal = item.count;
        }
      })
      this.datasetListLoading = false;
    }).catch((error: string) => {
      this.datasetListLoading = false;
      this.datasetListLoadingError = error;
      logger.error(`${error}`);
    })
  }

  syncClassicalLiteratureClassicPoem(page: number) {
    this.classicalliteratureClassicpoemLoading = true;
    DatasetViewModel.getClassicPoemList(this.classicalliteratureClassicpoemRemoteVersion, page)
      .then((wrapper: DataWrapper<ClassicPoem>) => {
        wrapper.data.map((classicPoem: ClassicPoem) => {
          DatasetViewModel.insertClassicPoemToDb(classicPoem);
          this.classicalliteratureClassicpoemCount++;
        })
        if (wrapper.next_page) {
          this.syncClassicalLiteratureClassicPoem(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveClassicalCultureClassicPoemVersion(this.classicalliteratureClassicpoemRemoteVersion)
          this.classicalliteratureClassicpoemLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.classicalliteratureClassicpoemLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncClassicalLiteratureClassicPoem, code = ${error.code}, msg = ${error.message}`);
      this.classicalliteratureClassicpoemLoading = false;
    })
  }

  syncChineseCharacterPoem(page: number) {
    this.chineseCharacterLoading = true;

    if (page) {
      DatasetViewModel.getChineseCharacterList(this.chineseCharacterRemoteVersion, page)
        .then((wrapper: DataWrapper<Character>) => {
          wrapper.data.map((character: Character) => {

            this.chineseCharacterCount++;
          })
          if (wrapper.next_page) {
            this.syncChineseCharacterPoem(wrapper.next_page);
          }
          if (!wrapper.next_page) {
            PrefUtil.saveChineseCharacterVersion(this.chineseCharacterRemoteVersion)
            this.chineseCharacterLoading = false;
          }
        }).catch((error: BusinessError) => {
        this.chineseCharacterLoadingError = `code = ${error.code}, msg = ${error.message}`;
        logger.error(`syncChineseCharacterPoem, code = ${error.code}, msg = ${error.message}`);
        this.chineseCharacterLoading = false;
      })
    }
  }
}

@Preview
@ComponentV2
struct Item {
  @Param @Require @Once title: string | Resource;
  @Param @Require @Once remoteVersion: number;
  @Param @Require localVersion: number;
  @Param @Require @Once total: number;
  @Param @Require progress: number;
  @Param @Require loading: boolean;
  @Param @Require error: string | null;
  @Event clickEvent: () => void = () => {
  };

  build() {
    Column() {
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
          Progress({ value: this.progress, total: this.total, type: ProgressType.Ring })
            .width(24)
            .height(24)
            .color(Color.Black)
            .margin({ right: 16 })
        }
        if (this.remoteVersion > 0 && this.localVersion == this.remoteVersion) {
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
        if (this.loading) {
          LoadingProgress()
            .width(36)
            .height(36)
            .color(Color.Black)
        } else {
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
            .onClick((event: ClickEvent) => {
              logger.info('click event triggered')
              this.clickEvent()
            })
        }
      }
      .width('100%')
      .padding(16)
      .alignItems(VerticalAlign.Center)

      if (this.error) {
        Text(this.error)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
          .textAlign(TextAlign.Start)
          .fontColor(Color.Red)
      }
    }
  }
}