import { DbTableConst, Icon, String, ThemeConst } from 'constants';
import { DataWrapper, Logger } from 'utils';
import { fileIo as fs, picker } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BlockTitle } from 'uicomponents';
import { taskpool } from '@kit.ArkTS';
import { relationalStore } from '@kit.ArkData';
import { PromptAction, ShowDialogSuccessResponse } from '@kit.ArkUI';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { batchInsertWorldCulturalHeritage, WorldCulturalHeritage } from 'china_worldcultureheritage';
import { AntitheticalCouplet, batchInsertAntitheticalCouplet } from 'chinese_antitheticalcouplet';
import { batchInsertCharacter, Character } from 'chinese_character';
import { batchInsertExpression, Expression } from 'chinese_expression';
import { batchInsertIdiom, Idiom } from 'chinese_idiom';
import { batchInsertKnowledge, Knowledge } from 'chinese_knowledge';
import { batchInsertLyric, batchInsertLyricFTS, Lyric } from 'chinese_lyric';
import { batchInsertModernPoetry, batchInsertModernPoetryFTS, ModernPoetry } from 'chinese_poetry';
import { batchInsertProverb, Proverb } from 'chinese_proverb';
import { batchInsertQuote, Quote } from 'chinese_quote';
import { batchInsertRiddle, Riddle } from 'chinese_riddle';
import { batchInsertTongueTwister, TongueTwister } from 'chinese_tonguetwister';
import { batchInsertWisecrack, Wisecrack } from 'chinese_wisecrack';
import { batchInsertClassicPoem, batchInsertClassicPoemFTS, ClassicPoem } from 'classicalliterature_classicpoem';
import { batchInsertPeople, People } from 'classicalliterature_people';
import { batchInsertSentence, Sentence } from 'classicalliterature_sentence';
import { batchInsertWriting, batchInsertWritingFTS, Writing } from 'classicalliterature_writing';
import { fileUri } from '@kit.CoreFileKit';
import util from '@ohos.util';

let logger: Logger = new Logger('ImportDataList')

@ComponentV2
export struct ImportDataList {
  @Local promptAction: PromptAction = this.getUIContext().getPromptAction();
  @Local classicalliteratureClassicpoemTotal: number = 0;
  @Local classicalliteratureClassicpoemCount: number = 0;
  @Local classicalliteratureClassicpoemError: BusinessError | null = null;
  @Local classicalliteratureClassicpoemLoading: boolean = false;
  @Local classicalliteraturePeopleTotal: number = 0;
  @Local classicalliteraturePeopleCount: number = 0;
  @Local classicalliteraturePeopleError: BusinessError | null = null;
  @Local classicalliteraturePeopleLoading: boolean = false;
  @Local classicalliteratureSentenceTotal: number = 0;
  @Local classicalliteratureSentenceCount: number = 0;
  @Local classicalliteratureSentenceError: BusinessError | null = null;
  @Local classicalliteratureSentenceLoading: boolean = false;
  @Local classicalliteratureWritingTotal: number = 0;
  @Local classicalliteratureWritingCount: number = 0;
  @Local classicalliteratureWritingError: BusinessError | null = null;
  @Local classicalliteratureWritingLoading: boolean = false;
  @Local chineseAntitheticalCoupletTotal: number = 0;
  @Local chineseAntitheticalCoupletCount: number = 0;
  @Local chineseAntitheticalCoupletError: BusinessError | null = null;
  @Local chineseAntitheticalCoupletLoading: boolean = false;
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
  @Local chineseLyricTotal: number = 0;
  @Local chineseLyricCount: number = 0;
  @Local chineseLyricError: BusinessError | null = null;
  @Local chineseLyricLoading: boolean = false;
  @Local chineseModernPoetryTotal: number = 0;
  @Local chineseModernPoetryCount: number = 0;
  @Local chineseModernPoetryError: BusinessError | null = null;
  @Local chineseModernPoetryLoading: boolean = false;
  @Local chineseProverbTotal: number = 0;
  @Local chineseProverbCount: number = 0;
  @Local chineseProverbError: BusinessError | null = null;
  @Local chineseProverbLoading: boolean = false;
  @Local chineseQuoteTotal: number = 0;
  @Local chineseQuoteCount: number = 0;
  @Local chineseQuoteError: BusinessError | null = null;
  @Local chineseQuoteLoading: boolean = false;
  @Local chineseRiddleTotal: number = 0;
  @Local chineseRiddleCount: number = 0;
  @Local chineseRiddleError: BusinessError | null = null;
  @Local chineseRiddleLoading: boolean = false;
  @Local chineseTongueTwisterTotal: number = 0;
  @Local chineseTongueTwisterCount: number = 0;
  @Local chineseTongueTwisterError: BusinessError | null = null;
  @Local chineseTongueTwisterLoading: boolean = false;
  @Local chineseWisecrackTotal: number = 0;
  @Local chineseWisecrackCount: number = 0;
  @Local chineseWisecrackError: BusinessError | null = null;
  @Local chineseWisecrackLoading: boolean = false;
  @Local chinaWorldcultureheritageTotal: number = 0;
  @Local chinaWorldcultureheritageCount: number = 0;
  @Local chinaWorldcultureheritageError: BusinessError | null = null;
  @Local chinaWorldcultureheritageLoading: boolean = false;
  @Local changeInfos: Callback<Array<relationalStore.ChangeInfo>> =
    (changeInfos: Array<relationalStore.ChangeInfo>) => {
      for (let i = 0; i < changeInfos.length; i++) {
        let info = changeInfos[i]
        logger.info(`changeInfos: table = ${info.table}, type = ${info.type}, inserted = ${info.inserted}, updated = ${info.updated}`);
        if (info.table == DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE) {
          this.classicalliteratureClassicpoemCount += info.inserted.length
        } else if (info.table == DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE) {
          this.classicalliteraturePeopleCount += info.inserted.length
        } else if (info.table == DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE) {
          this.classicalliteratureSentenceCount += info.inserted.length
        } else if (info.table == DbTableConst.CLASSICALLITERATURE_WRITING_TABLE) {
          this.classicalliteratureWritingCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE) {
          this.chineseAntitheticalCoupletCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_CHARACTER_TABLE) {
          this.chineseCharacterCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_EXPRESSION_TABLE) {
          this.chineseExpressionCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_IDIOM_TABLE) {
          this.chineseIdiomCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_KNOWLEDGE_TABLE) {
          this.chineseKnowledgeCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_LYRIC_TABLE) {
          this.chineseLyricCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_MODERNPOETRY_TABLE) {
          this.chineseModernPoetryCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_PROVERB_TABLE) {
          this.chineseProverbCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_QUOTE_TABLE) {
          this.chineseQuoteCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_RIDDLE_TABLE) {
          this.chineseRiddleCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_TONGUETWISTER_TABLE) {
          this.chineseTongueTwisterCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINESE_WISECRACK_TABLE) {
          this.chineseWisecrackCount += info.inserted.length
        } else if (info.table == DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE) {
          this.chinaWorldcultureheritageCount += info.inserted.length
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
          let context = this.getUIContext().getHostContext() as Context;

          if (error) {
            this.classicalliteratureClassicpoemLoading = false
            this.classicalliteratureClassicpoemError = error
          }
          uris.forEach(async (uri: string) => {
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<ClassicPoem>
            if (wrapper) {
              this.classicalliteratureClassicpoemTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertClassicPoem, context, spliced).catch((error: BusinessError) => {
                    logger.error(`classicalliterature_classicpoem taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                  taskpool.execute(batchInsertClassicPoemFTS, context, spliced).catch((error: BusinessError) => {
                    logger.error(`classicalliterature_classicpoem taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.classicalliteratureClassicpoemLoading = false
        })
      })
      Item({
        title: String.classicalliterature_people,
        total: this.classicalliteraturePeopleTotal,
        count: this.classicalliteraturePeopleCount,
        error: this.classicalliteraturePeopleError,
        loading: this.classicalliteraturePeopleLoading,
        loadingStatusChange: (() => {
          this.classicalliteraturePeopleLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          let context = this.getUIContext().getHostContext() as Context;

          if (error) {
            this.classicalliteraturePeopleLoading = false
            this.classicalliteraturePeopleError = error
          }
          uris.forEach(async (uri: string) => {
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<People>
            if (wrapper) {
              this.classicalliteraturePeopleTotal = wrapper.total;

              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertPeople, context, spliced).catch((error: BusinessError) => {
                    logger.error(`classicalliterature_people taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.classicalliteraturePeopleLoading = false
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
          let context = this.getUIContext().getHostContext() as Context;
          if (error) {
            this.classicalliteratureSentenceLoading = false
            this.classicalliteratureSentenceError = error
          }
          uris.forEach(async (uri: string) => {
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Sentence>
            if (wrapper) {
              this.classicalliteratureSentenceTotal = wrapper.total;

              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertSentence, context, spliced).catch((error: BusinessError) => {
                    logger.error(`classicalliterature_sentence taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.classicalliteratureSentenceLoading = false
        })
      })
      Item({
        title: String.classicalliterature_writing,
        total: this.classicalliteratureWritingTotal,
        count: this.classicalliteratureWritingCount,
        error: this.classicalliteratureWritingError,
        loading: this.classicalliteratureWritingLoading,
        loadingStatusChange: (() => {
          this.classicalliteratureWritingLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          let context = this.getUIContext().getHostContext() as Context;
          if (error) {
            this.classicalliteratureWritingLoading = false
            this.classicalliteratureWritingError = error
          }
          uris.forEach(async (uri: string) => {
            taskpool.execute(readDataToDb, context, uri).catch((error: BusinessError) => {
              logger.error(`readDataToDb taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
            /*let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Writing>
            if (wrapper) {
              logger.info(`import classicalliterature_writing ${wrapper.data.length}`)
              this.classicalliteratureWritingTotal = wrapper.total;

              let objs = wrapper.data;
              let limit: number = 50;

              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > limit ? limit : objs.length)
                  taskpool.execute(batchInsertWriting, context, spliced).catch((error: BusinessError) => {
                    logger.error(`classicalliterature_writing taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                  taskpool.execute(batchInsertWritingFTS, context, spliced).catch((error: BusinessError) => {
                    logger.error(`classicalliterature_writing taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }*/
          })
          this.classicalliteratureWritingLoading = false
        })
      })
      BlockTitle({ title: String.chinese })
      Item({
        title: String.chinese_antitheticalcouplet,
        total: this.chineseAntitheticalCoupletTotal,
        count: this.chineseAntitheticalCoupletCount,
        error: this.chineseAntitheticalCoupletError,
        loading: this.chineseAntitheticalCoupletLoading,
        loadingStatusChange: (() => {
          this.chineseAntitheticalCoupletLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseAntitheticalCoupletLoading = false
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<AntitheticalCouplet>
            if (wrapper) {
              this.chineseAntitheticalCoupletTotal = wrapper.total;
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertAntitheticalCouplet, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_antitheticalcouplet taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseAntitheticalCoupletLoading = false
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
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Character>
            if (wrapper) {
              this.chineseCharacterTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertCharacter, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_character taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
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
        clickEventCallback: (async (uris: string[], error: BusinessError | null) => {
          let context: Context = this.getUIContext().getHostContext() as Context;

          if (error) {
            this.chineseExpressionLoading = false
            this.chineseExpressionError = error
          } else {
            let wrapper: DataWrapper<Expression> | null;

            uris.forEach(async (uri: string) => {
              wrapper = JSON.parse(await readData(uri)) as DataWrapper<Expression>
              if (wrapper) {
                this.chineseExpressionTotal = wrapper.total
                let objs = wrapper.data
                try {
                  while (objs.length) {
                    let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                    taskpool.execute(batchInsertExpression, context, spliced).catch((error: BusinessError) => {
                      logger.error(`chinese_expression taskpool execute error, code = ${error.code} message = ${error.message}`)
                    })
                  }
                } catch (error) {
                  let err = error as BusinessError
                  logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
                }
              }
            })
            wrapper = null;
            this.chineseExpressionLoading = false;
          }
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

          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Idiom>
            let objs = wrapper.data
            try {
              while (objs.length) {
                let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                taskpool.execute(batchInsertIdiom, context, spliced).catch((error: BusinessError) => {
                  logger.error(`chinese_idiom taskpool execute error, code = ${error.code} message = ${error.message}`)
                })
              }
            } catch (error) {
              let err = error as BusinessError
              logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
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
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Knowledge>
            if (wrapper) {
              this.chineseKnowledgeTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertKnowledge, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_knowledge taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseKnowledgeLoading = false
        })
      })
      Item({
        title: String.chinese_lyric,
        total: this.chineseLyricTotal,
        count: this.chineseLyricCount,
        error: this.chineseLyricError,
        loading: this.chineseLyricLoading,
        loadingStatusChange: (() => {
          this.chineseLyricLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseLyricLoading = false
            this.chineseLyricError = error
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Lyric>
            if (wrapper) {
              this.chineseLyricTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertLyric, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_lyric taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                  taskpool.execute(batchInsertLyricFTS, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_lyric taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseLyricLoading = false
        })
      })
      Item({
        title: String.chinese_modernpoetry,
        total: this.chineseModernPoetryTotal,
        count: this.chineseModernPoetryCount,
        error: this.chineseModernPoetryError,
        loading: this.chineseModernPoetryLoading,
        loadingStatusChange: (() => {
          this.chineseModernPoetryLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseModernPoetryLoading = false
            this.chineseModernPoetryError = error
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<ModernPoetry>
            if (wrapper) {
              this.chineseModernPoetryTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertModernPoetry, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_modernpoetry taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                  taskpool.execute(batchInsertModernPoetryFTS, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_modernpoetry taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseModernPoetryLoading = false
        })
      })
      Item({
        title: String.chinese_proverb,
        total: this.chineseProverbTotal,
        count: this.chineseProverbCount,
        error: this.chineseProverbError,
        loading: this.chineseProverbLoading,
        loadingStatusChange: (() => {
          this.chineseProverbLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseProverbLoading = false
            this.chineseProverbError = error
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Proverb>;
            if (wrapper) {
              this.chineseProverbTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertProverb, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_proverb taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseProverbLoading = false
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
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Quote>;
            if (wrapper) {
              this.chineseQuoteTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertQuote, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_quote taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseQuoteLoading = false
        })
      })
      Item({
        title: String.chinese_riddle,
        total: this.chineseRiddleTotal,
        count: this.chineseRiddleCount,
        error: this.chineseRiddleError,
        loading: this.chineseRiddleLoading,
        loadingStatusChange: (() => {
          this.chineseRiddleLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseRiddleLoading = false
            this.chineseRiddleError = error
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Riddle>;
            if (wrapper) {
              this.chineseRiddleTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertRiddle, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_riddle taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseRiddleLoading = false
        })
      })
      Item({
        title: String.chinese_tonguetwister,
        total: this.chineseTongueTwisterTotal,
        count: this.chineseTongueTwisterCount,
        error: this.chineseTongueTwisterError,
        loading: this.chineseTongueTwisterLoading,
        loadingStatusChange: (() => {
          this.chineseTongueTwisterLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseTongueTwisterLoading = false
            this.chineseTongueTwisterError = error
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<TongueTwister>;
            if (wrapper) {
              this.chineseTongueTwisterTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertTongueTwister, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_tonguetwister taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseTongueTwisterLoading = false
        })
      })
      Item({
        title: String.chinese_wisecrack,
        total: this.chineseWisecrackTotal,
        count: this.chineseWisecrackCount,
        error: this.chineseWisecrackError,
        loading: this.chineseWisecrackLoading,
        loadingStatusChange: (() => {
          this.chineseWisecrackLoading = true
        }),
        clickEventCallback: ((uris: string[], error: BusinessError | null) => {
          if (error) {
            this.chineseWisecrackLoading = false
            this.chineseWisecrackError = error
          }
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper = JSON.parse(await readData(uri)) as DataWrapper<Wisecrack>;
            if (wrapper) {
              this.chineseWisecrackTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertWisecrack, context, spliced).catch((error: BusinessError) => {
                    logger.error(`chinese_wisecrack taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
          })
          this.chineseWisecrackLoading = false
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
          uris.forEach(async (uri: string) => {
            let context = this.getUIContext().getHostContext() as Context;
            let wrapper: DataWrapper<WorldCulturalHeritage> | null =
              JSON.parse(await readData(uri)) as DataWrapper<WorldCulturalHeritage>
            if (wrapper) {
              this.chinaWorldcultureheritageTotal = wrapper.total
              let objs = wrapper.data
              try {
                while (objs.length) {
                  let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
                  taskpool.execute(batchInsertWorldCulturalHeritage, context, spliced).catch((error: BusinessError) => {
                    logger.error(`china_worldcultureheritage taskpool execute error, code = ${error.code} message = ${error.message}`)
                  })
                }
              } catch (error) {
                let err = error as BusinessError
                logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
              }
            }
            wrapper = null
          })
          this.chinaWorldcultureheritageLoading = false
        })
      })
    }
    .width('100%')
    .onAppear(() => {
      this.promptAction.showDialog({
        'title': '温馨提示',
        'message': '为了避免占用内存过多导致应用奔溃，请一项一项导入。',
        'buttons': [
          {
            text: '知道了',
            color: $r('sys.color.popup_text_primary_color'),
          },
        ]
      }, (error: BusinessError, data: ShowDialogSuccessResponse) => {

      })
    })
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
        if (this.loading || this.count != this.total) {
          LoadingProgress()
            .width(36)
            .height(36)
            .color($r('sys.color.ohos_id_color_text_primary'))
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
                .backgroundColor(ThemeConst.BackGroundColor_Pressed)
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

async function readData(uri: string): Promise<string> {
  let text = '';
  try {
    let file = await fs.open(uri, fs.OpenMode.READ_ONLY);
    let stat = await fs.stat(file.path)
    let arrayBuffer = new ArrayBuffer(stat.size);
    await fs.read(file.fd, arrayBuffer);
    text = util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(arrayBuffer))
    //logger.info(`readData = ${text}`)
    //读取完成后关闭fd。
    await fs.close(file);
  } catch (error) {
    let err = error as BusinessError
    logger.error(`read data failed, code = ${err.code}, message = ${err.message}`)
  }

  return text
}


@Concurrent
async function readDataToDb(context: Context, uri: string): Promise<void> {
  let logger: Logger = new Logger('readDataToDb')
  let text = '';
  try {
    let file = await fs.open(uri, fs.OpenMode.READ_ONLY);
    let stat = await fs.stat(file.path)
    let arrayBuffer = new ArrayBuffer(stat.size);
    await fs.read(file.fd, arrayBuffer);
    //读取完成后关闭fd。
    await fs.close(file);
    text = util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(arrayBuffer))
    //logger.info(`readData = ${text}`)
    let wrapper = JSON.parse(text) as DataWrapper<Writing>
    if (wrapper) {
      logger.info(`import classicalliterature_writing ${wrapper.data.length}`)
      //this.classicalliteratureWritingTotal = wrapper.total;

      let objs = wrapper.data;
      let limit: number = 50;

      /*batchInsertWriting(context, objs)
      batchInsertWritingFTS(context, objs)*/

      try {
        while (objs.length) {
          let spliced = objs.splice(0, objs.length > limit ? limit : objs.length)
          batchInsertWriting(context, spliced)
          batchInsertWritingFTS(context, spliced)
          /*taskpool.execute(batchInsertWriting, context, spliced).catch((error: BusinessError) => {
            logger.error(`classicalliterature_writing taskpool execute error, code = ${error.code} message = ${error.message}`)
          })
          taskpool.execute(batchInsertWritingFTS, context, spliced).catch((error: BusinessError) => {
            logger.error(`classicalliterature_writing taskpool execute error, code = ${error.code} message = ${error.message}`)
          })*/
        }
      } catch (error) {
        let err = error as BusinessError
        logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
      }
    }
  } catch (error) {
    let err = error as BusinessError
    logger.error(`read data failed, code = ${err.code}, message = ${err.message}`)
  }

  //return text
}