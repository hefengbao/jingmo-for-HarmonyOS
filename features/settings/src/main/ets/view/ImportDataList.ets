import { DbTableConst, Icon, String, ThemeConst } from 'constants';
import { DataWrapper, Logger } from 'utils';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BlockTitle } from 'uicomponents';
import util from '@ohos.util';
import { JSON } from '@kit.ArkTS';
import { ClassicPoem } from 'classicalliterature_classicpoem';
import { Sentence } from 'classicalliterature_sentence';
import { AntitheticalCouplet } from 'chinese_antitheticalcouplet';
import { WorldCulturalHeritage } from 'china_worldcultureheritage';
import { Character } from 'chinese_character';
import { Expression } from 'chinese_expression';
import { Idiom } from 'chinese_idiom';
import { Knowledge } from 'chinese_knowledge';
import { Quote } from 'chinese_quote';
import { relationalStore } from '@kit.ArkData';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

import DatasetViewModel from '../viewmodel//DatasetViewModel';

let logger: Logger = new Logger('ImportDataList')

@ComponentV2
export struct ImportDataList {
  @Local classicalliteratureClassicpoemTotal: number = 0;
  @Local classicalliteratureClassicpoemCount: number = 0;
  @Local classicalliteratureClassicpoemError: BusinessError | null = null;
  @Local classicalliteratureClassicpoemLoading: boolean = false;
  @Local classicalliteratureSentenceTotal: number = 0;
  @Local classicalliteratureSentenceCount: number = 0;
  @Local classicalliteratureSentenceError: BusinessError | null = null;
  @Local classicalliteratureSentenceLoading: boolean = false;
  @Local chineseAntitheticalcoupletTotal: number = 0;
  @Local chineseAntitheticalcoupletCount: number = 0;
  @Local chineseAntitheticalcoupletError: BusinessError | null = null;
  @Local chineseAntitheticalcoupletLoading: boolean = false;
  @Local chineseCharacterTotal: number = 0;
  @Local chineseCharacterCount: number = 0;
  @Local chineseCharacterError: BusinessError | null = null;
  @Local chineseCharacterLoading: boolean = false;
  @Local chineseExpressionTotal: number = 0;
  @Local chineseExpressionCount: number = 0;
  @Local chineseExpressionError: BusinessError | null = null;
  @Local chineseExpressionLoading: boolean = false;
  @Local chineseIdiomTotal: number = 0;
  @Local chineseIdiomCount: number = 0;
  @Local chineseIdiomError: BusinessError | null = null;
  @Local chineseIdiomLoading: boolean = false;
  @Local chineseKnowledgeTotal: number = 0;
  @Local chineseKnowledgeCount: number = 0;
  @Local chineseKnowledgeError: BusinessError | null = null;
  @Local chineseKnowledgeLoading: boolean = false;
  @Local chineseQuoteTotal: number = 0;
  @Local chineseQuoteCount: number = 0;
  @Local chineseQuoteError: BusinessError | null = null;
  @Local chineseQuoteLoading: boolean = false;
  @Local chinaWorldcultureheritageTotal: number = 0;
  @Local chinaWorldcultureheritageCount: number = 0;
  @Local chinaWorldcultureheritageError: BusinessError | null = null;
  @Local chinaWorldcultureheritageLoading: boolean = false;
  changeInfos = (changeInfos: Array<relationalStore.ChangeInfo>) => {
    for (let i = 0; i < changeInfos.length; i++) {
      let info = changeInfos[i]
      logger.info(`changeInfos: table = ${info.table}, type = ${info.type}, inserted = ${info.inserted}, updated = ${info.updated}`);
      if (info.table == DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE) {
        this.classicalliteratureClassicpoemCount++
      } else if (info.table == DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE) {
        this.classicalliteratureSentenceCount++
      } else if (info.table == DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE) {
        this.chineseAntitheticalcoupletCount++
      } else if (info.table == DbTableConst.CHINESE_CHARACTER_TABLE) {
        this.chineseCharacterCount++
      } else if (info.table == DbTableConst.CHINESE_EXPRESSION_TABLE) {
        this.chineseExpressionCount++
      } else if (info.table == DbTableConst.CHINESE_IDIOM_TABLE) {
        this.chineseIdiomCount++
      } else if (info.table == DbTableConst.CHINESE_KNOWLEDGE_TABLE) {
        this.chineseKnowledgeCount++
      } else if (info.table == DbTableConst.CHINESE_QUOTE_TABLE) {
        this.chineseQuoteCount++
      } else if (info.table == DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE) {
        this.chinaWorldcultureheritageCount++
      }
    }
  }

  aboutToAppear(): void {
    try {
      DbUtil.objectiveRDB?.on(
        'dataChange',
        relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS,
        this.changeInfos
      )
    } catch (error) {
      logger.error(`add dataChange failed, error = ${error}`)
    }
  }

  aboutToRecycle(): void {
    try {
      DbUtil.objectiveRDB?.off
      (
        'dataChange',
        relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS,
        this.changeInfos
      )
    } catch (error) {
      logger.error(`off dataChange failed, error = ${error}`)
    }
  }

  build() {
    Column() {
      BlockTitle({ title: String.classicalliterature })
      Item({
        title: String.classicalliterature_classicpoem,
        total: this.classicalliteratureClassicpoemTotal,
        count: this.classicalliteratureClassicpoemCount,
        error: this.classicalliteratureClassicpoemError,
        loading: this.classicalliteratureClassicpoemLoading,
        loadingStatusChange: (() => {
          this.classicalliteratureClassicpoemLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.classicalliteratureClassicpoemLoading = false
            this.classicalliteratureClassicpoemError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<ClassicPoem>
            if (wrapper) {
              this.classicalliteratureClassicpoemTotal = wrapper.total
              logger.info(`classicalliteratureClassicpoemTotal = ${this.classicalliteratureClassicpoemTotal}`)
              wrapper.data.forEach((obj: ClassicPoem) => {
                DatasetViewModel.insertClassicalLiteratureClassicPoemToDb(obj);
              })
            }
          })
          this.classicalliteratureClassicpoemLoading = false
        })
      })
      Item({
        title: String.classicalliterature_sentence,
        total: this.classicalliteratureSentenceTotal,
        count: this.classicalliteratureSentenceCount,
        error: this.classicalliteratureSentenceError,
        loading: this.classicalliteratureSentenceLoading,
        loadingStatusChange: (() => {
          this.classicalliteratureSentenceLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.classicalliteratureSentenceLoading = false
            this.classicalliteratureSentenceError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<Sentence>
            if (wrapper) {
              this.classicalliteratureSentenceTotal = wrapper.total
              wrapper.data.forEach((obj: Sentence) => {
                DatasetViewModel.insertClassicalLiteratureSentenceToDb(obj);
              })
            }
          })
          this.classicalliteratureSentenceLoading = false
        })
      })
      BlockTitle({ title: String.chinese })
      Item({
        title: String.chinese_antitheticalcouplet,
        total: this.chineseAntitheticalcoupletTotal,
        count: this.chineseAntitheticalcoupletCount,
        error: this.chineseAntitheticalcoupletError,
        loading: this.chineseAntitheticalcoupletLoading,
        loadingStatusChange: (() => {
          this.chineseAntitheticalcoupletLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseAntitheticalcoupletLoading = false
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<AntitheticalCouplet>
            if (wrapper) {
              this.chineseAntitheticalcoupletTotal = wrapper.total
              wrapper.data.forEach((obj: AntitheticalCouplet) => {
                DatasetViewModel.insertChineseAntitheticalCoupletToDb(obj);
              })
            }
          })
          this.chineseAntitheticalcoupletLoading = false
        })
      })
      Item({
        title: String.chinese_character,
        total: this.chineseCharacterTotal,
        count: this.chineseCharacterCount,
        error: this.chineseCharacterError,
        loading: this.chineseCharacterLoading,
        loadingStatusChange: (() => {
          this.chineseCharacterLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseCharacterLoading = false
            this.chineseCharacterError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<Character>
            if (wrapper) {
              this.chineseCharacterTotal = wrapper.total
              wrapper.data.forEach((obj: Character) => {
                DatasetViewModel.insertChineseCharacterToDb(obj);
              })
            }
          })
          this.chineseCharacterLoading = false
        })
      })
      Item({
        title: String.chinese_expression,
        total: this.chineseExpressionTotal,
        count: this.chineseExpressionCount,
        error: this.chineseExpressionError,
        loading: this.chineseExpressionLoading,
        loadingStatusChange: (() => {
          this.chineseExpressionLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseExpressionLoading = false
            this.chineseExpressionError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<Expression>
            if (wrapper) {
              this.chineseExpressionTotal = wrapper.total
              wrapper.data.forEach((obj: Expression) => {
                DatasetViewModel.insertChineseExpressionToDb(obj);
              })
            }
          })
          this.chineseExpressionLoading = false
        })
      })
      Item({
        title: String.chinese_idiom,
        total: this.chineseIdiomTotal,
        count: this.chineseIdiomCount,
        error: this.chineseIdiomError,
        loading: this.chineseIdiomLoading,
        loadingStatusChange: (() => {
          this.chineseIdiomLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseIdiomLoading = false
            this.chineseIdiomError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<Idiom>
            if (wrapper) {
              this.chineseIdiomTotal = wrapper.total
              wrapper.data.forEach((obj: Idiom) => {
                DatasetViewModel.insertChineseIdiomToDb(obj);
              })
            }
          })
          this.chineseIdiomLoading = false
        })
      })
      Item({
        title: String.chinese_knowledge,
        total: this.chineseKnowledgeTotal,
        count: this.chineseKnowledgeCount,
        error: this.chineseKnowledgeError,
        loading: this.chineseKnowledgeLoading,
        loadingStatusChange: (() => {
          this.chineseKnowledgeLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseKnowledgeLoading = false
            this.chineseKnowledgeError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<Knowledge>
            if (wrapper) {
              this.chineseKnowledgeTotal = wrapper.total
              wrapper.data.forEach((obj: Knowledge) => {
                DatasetViewModel.insertChineseKnowledgeToDb(obj);
              })
            }
          })
          this.chineseKnowledgeLoading = false
        })
      })
      Item({
        title: String.chinese_quote,
        total: this.chineseQuoteTotal,
        count: this.chineseQuoteCount,
        error: this.chineseQuoteError,
        loading: this.chineseQuoteLoading,
        loadingStatusChange: (() => {
          this.chineseQuoteLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseQuoteLoading = false
            this.chineseQuoteError = error
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<Quote>
            if (wrapper) {
              this.chineseQuoteTotal = wrapper.total
              wrapper.data.forEach((obj: Quote) => {
                DatasetViewModel.insertChineseQuoteToDb(obj);
              })
            }
          })
          this.chineseQuoteLoading = false
        })
      })
      BlockTitle({ title: String.china })
      Item({
        title: String.china_worldcultureheritage,
        total: this.chinaWorldcultureheritageTotal,
        count: this.chinaWorldcultureheritageCount,
        error: this.chinaWorldcultureheritageError,
        loading: this.chinaWorldcultureheritageLoading,
        loadingStatusChange: (() => {
          this.chinaWorldcultureheritageLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chinaWorldcultureheritageLoading = false
          }
          uris.forEach((uri: string) => {
            let wrapper = JSON.parse(readData(uri)) as DataWrapper<WorldCulturalHeritage>
            if (wrapper) {
              this.chinaWorldcultureheritageTotal = wrapper.total
              wrapper.data.forEach((obj: WorldCulturalHeritage) => {
                DatasetViewModel.insertChinaWorldCulturalHeritageToDb(obj);
              })
            }
          })
          this.chinaWorldcultureheritageLoading = false
        })
      })
    }
    .width('100%')
  }
}

@ComponentV2
struct Item {
  @Param @Require @Once title: Resource | string;
  @Param @Require total: number;
  @Param @Require count: number;
  @Param @Require error: BusinessError | null;
  @Param @Require loading: boolean;
  @Event loadingStatusChange: () => void = () => {
  };
  @Event clickEventCallback: (uris: string[], error: BusinessError | null) => void = () => {
  }

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.title)
        }
        .alignItems(HorizontalAlign.Start)

        Blank()
        if (this.count) {
          Text(this.count.toString())
            .fontSize(ThemeConst.FontSize_14)
            .fontColor(Color.Gray)
            .margin({ right: 16 })
        }
        if (this.loading) {
          LoadingProgress()
            .width(36)
            .height(36)
            .color(Color.Black)
        } else {
          Image(Icon.ic_public_folder)
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
            .onClick(() => {
              if (!this.loading) {
                this.loadingStatusChange()
                // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
                let context = this.getUIContext().getHostContext() as common.UIAbilityContext;

                let documentSelectOptions = new picker.DocumentSelectOptions();
                let uris: string[] = [];
                let error: BusinessError | null = null
                documentSelectOptions.defaultFilePathUri = "file://docs/storage/Users/currentUser/Download"
                // 创建文件选择器实例
                const documentViewPicker = new picker.DocumentViewPicker(context);
                documentViewPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
                  //文件选择成功后，返回被选中文档的URI结果集。
                  uris = documentSelectResult
                  this.clickEventCallback(uris, error)
                  logger.info('documentViewPicker.select to file succeed and uris are:' + uris);
                }).catch((err: BusinessError) => {
                  this.clickEventCallback(uris, error)
                  logger.error(`Invoke documentViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
                })
              }
            })
        }
        if (this.error) {
          Text(`code = ${this.error.code}, message = ${this.error.message}`)
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            .textAlign(TextAlign.Start)
            .fontColor(Color.Red)
        }
      }
      .width('100%')
      .padding(16)
      .alignItems(VerticalAlign.Center)
    }
  }
}

function readData(uri: string): string {
  let text = '';
  try {
    let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
    let stat = fs.statSync(file.path)
    let arrayBuffer = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, arrayBuffer);
    text = util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(arrayBuffer))
    logger.info(`readData = ${text}`)
    //读取完成后关闭fd。
    fs.closeSync(file);
  } catch (error) {
    let err = error as BusinessError
    logger.error(`read data failed, code = ${err.code}, message = ${err.message}`)
  }

  return text
}