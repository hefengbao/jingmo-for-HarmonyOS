import { BusinessError } from '@kit.BasicServicesKit';
import { DataWrapper, Logger } from 'utils';
import { Icon, PrefConst, String, ThemeConst } from 'constants';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import Dataset from '../model/Dataset';
import { WorldCulturalHeritage } from 'china_worldcultureheritage';
import { AntitheticalCouplet } from 'chinese_antitheticalcouplet';
import { Character } from 'chinese_character';
import { Expression } from 'chinese_expression';
import { Idiom } from 'chinese_idiom';
import { Knowledge } from 'chinese_knowledge';
import { Quote } from 'chinese_quote';
import { ClassicPoem } from 'classicalliterature_classicpoem';
import { Sentence } from 'classicalliterature_sentence';
import { BlockTitle } from 'uicomponents';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';

let logger: Logger = new Logger('SyncData');

@ComponentV2
export struct SyncDataList {
  @Param @Require @Once dataset: Dataset[]
  @Local classicalliteratureClassicpoemLocalVersion: number = PrefUtil.getClassicalLiteratureClassicPoemVersion();
  @Local classicalliteratureClassicpoemRemoteVersion: number = 0;
  @Local classicalliteratureClassicpoemTotal: number = 0;
  @Local classicalliteratureClassicpoemCount: number = 0;
  @Local classicalliteratureClassicpoemLoading: boolean = false;
  @Local classicalliteratureClassicpoemLoadingError: string | null = null;
  @Local classicalliteratureSentenceLocalVersion: number = PrefUtil.getClassicalLiteratureSentenceVersion();
  @Local classicalliteratureSentenceRemoteVersion: number = 0;
  @Local classicalliteratureSentenceTotal: number = 0;
  @Local classicalliteratureSentenceCount: number = 0;
  @Local classicalliteratureSentenceLoading: boolean = false;
  @Local classicalliteratureSentenceLoadingError: string | null = null;
  @Local chineseAntitheticalCoupletLocalVersion: number = PrefUtil.getChineseAntitheticalCoupletVersion();
  @Local chineseAntitheticalCoupletRemoteVersion: number = 0;
  @Local chineseAntitheticalCoupletTotal: number = 0;
  @Local chineseAntitheticalCoupletCount: number = 0;
  @Local chineseAntitheticalCoupletLoading: boolean = false;
  @Local chineseAntitheticalCoupletLoadingError: string | null = null;
  @Local chineseCharacterLocalVersion: number = PrefUtil.getChineseCharacterVersion();
  @Local chineseCharacterRemoteVersion: number = 0;
  @Local chineseCharacterTotal: number = 0;
  @Local chineseCharacterCount: number = 0;
  @Local chineseCharacterLoading: boolean = false;
  @Local chineseCharacterLoadingError: string | null = null;
  @Local chineseExpressionLocalVersion: number = PrefUtil.getChineseExpressionVersion();
  @Local chineseExpressionRemoteVersion: number = 0;
  @Local chineseExpressionTotal: number = 0;
  @Local chineseExpressionCount: number = 0;
  @Local chineseExpressionLoading: boolean = false;
  @Local chineseExpressionLoadingError: string | null = null;
  @Local chineseIdiomLocalVersion: number = PrefUtil.getChineseIdiomVersion();
  @Local chineseIdiomRemoteVersion: number = 0;
  @Local chineseIdiomTotal: number = 0;
  @Local chineseIdiomCount: number = 0;
  @Local chineseIdiomLoading: boolean = false;
  @Local chineseIdiomLoadingError: string | null = null;
  @Local chineseKnowledgeLocalVersion: number = PrefUtil.getChineseKnowledgeVersion();
  @Local chineseKnowledgeRemoteVersion: number = 0;
  @Local chineseKnowledgeTotal: number = 0;
  @Local chineseKnowledgeCount: number = 0;
  @Local chineseKnowledgeLoading: boolean = false;
  @Local chineseKnowledgeLoadingError: string | null = null;
  @Local chineseQuoteLocalVersion: number = PrefUtil.getChineseQuoteVersion();
  @Local chineseQuoteRemoteVersion: number = 0;
  @Local chineseQuoteTotal: number = 0;
  @Local chineseQuoteCount: number = 0;
  @Local chineseQuoteLoading: boolean = false;
  @Local chineseQuoteLoadingError: string | null = null;
  @Local chinaWorldCulturalHeritageLocalVersion: number = PrefUtil.getChinaWorldCulturalHeritageVersion();
  @Local chinaWorldCulturalHeritageRemoteVersion: number = 0;
  @Local chinaWorldCulturalHeritageTotal: number = 0;
  @Local chinaWorldCulturalHeritageCount: number = 0;
  @Local chinaWorldCulturalHeritageLoading: boolean = false;
  @Local chinaWorldCulturalHeritageLoadingError: string | null = null;
  observer = (key: string) => {
    if (key == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
      this.classicalliteratureClassicpoemLocalVersion = PrefUtil.getClassicalLiteratureClassicPoemVersion();
    } else if (key == PrefConst.CLASSICALLITERATURE_SENTENCE) {
      this.classicalliteratureSentenceLocalVersion = PrefUtil.getClassicalLiteratureSentenceVersion()
    } else if (key == PrefConst.CHINESE_ANTITHETICALCOUPLET) {
      this.chineseAntitheticalCoupletLocalVersion = PrefUtil.getChineseAntitheticalCoupletVersion()
    } else if (key == PrefConst.CHINESE_CHARACTER) {
      this.chineseCharacterLocalVersion = PrefUtil.getChineseCharacterVersion()
    } else if (key == PrefConst.CHINESE_EXPRESSION) {
      this.chineseExpressionLocalVersion = PrefUtil.getChineseExpressionVersion()
    } else if (key == PrefConst.CHINESE_IDIOM) {
      this.chineseIdiomLocalVersion = PrefUtil.getChineseIdiomVersion()
    } else if (key == PrefConst.CHINESE_KNOWLEDGE) {
      this.chineseKnowledgeLocalVersion = PrefUtil.getChineseKnowledgeVersion()
    } else if (key == PrefConst.CHINESE_QUOTE) {
      this.chineseQuoteLocalVersion = PrefUtil.getChineseQuoteVersion()
    } else if (key == PrefConst.CHINA_WORLDCULTUREHERITAGE) {
      this.chinaWorldCulturalHeritageLocalVersion = PrefUtil.getChinaWorldCulturalHeritageVersion()
    }
  }

  aboutToAppear(): void {
    this.dataset.forEach((item: Dataset) => {
      if (item.name == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
        this.classicalliteratureClassicpoemRemoteVersion = item.version;
        this.classicalliteratureClassicpoemTotal = item.count;
      } else if (item.name == PrefConst.CLASSICALLITERATURE_SENTENCE) {
        this.classicalliteratureSentenceRemoteVersion = item.version;
        this.classicalliteratureSentenceTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_ANTITHETICALCOUPLET) {
        this.chineseAntitheticalCoupletRemoteVersion = item.version;
        this.chineseAntitheticalCoupletTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_CHARACTER) {
        this.chineseCharacterRemoteVersion = item.version;
        this.chineseCharacterTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_EXPRESSION) {
        this.chineseExpressionRemoteVersion = item.version;
        this.chineseExpressionTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_IDIOM) {
        this.chineseIdiomRemoteVersion = item.version;
        this.chineseIdiomTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_KNOWLEDGE) {
        this.chineseKnowledgeRemoteVersion = item.version;
        this.chineseKnowledgeTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_QUOTE) {
        this.chineseQuoteRemoteVersion = item.version;
        this.chineseQuoteTotal = item.count;
      } else if (item.name == PrefConst.CHINA_WORLDCULTUREHERITAGE) {
        this.chinaWorldCulturalHeritageRemoteVersion = item.version;
        this.chinaWorldCulturalHeritageTotal = item.count;
      }
    })
    try {
      PrefUtil.preference?.on('change', this.observer)
    } catch (error) {
      logger.error(`preference add change observer error = ${error}`);
    }
  }

  aboutToRecycle(): void {
    try {
      PrefUtil.preference?.off('change', this.observer)
    } catch (error) {
      logger.error(`preference off change observer error = ${error}`);
    }
  }

  build() {
    Column() {
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
      Item({
        title: String.classicalliterature_sentence,
        remoteVersion: this.classicalliteratureSentenceRemoteVersion,
        localVersion: this.classicalliteratureSentenceLocalVersion,
        total: this.classicalliteratureSentenceTotal,
        progress: this.classicalliteratureSentenceCount,
        loading: this.classicalliteratureSentenceLoading,
        error: this.classicalliteratureSentenceLoadingError,
        clickEvent: (): void => {
          this.syncClassicalLiteratureSentence(1)
        }
      })
      BlockTitle({ title: String.chinese })
      Item({
        title: String.chinese_antitheticalcouplet,
        remoteVersion: this.chineseAntitheticalCoupletRemoteVersion,
        localVersion: this.chineseAntitheticalCoupletLocalVersion,
        total: this.chineseAntitheticalCoupletTotal,
        progress: this.chineseAntitheticalCoupletCount,
        loading: this.chineseAntitheticalCoupletLoading,
        error: this.chineseAntitheticalCoupletLoadingError,
        clickEvent: (): void => {
          this.syncChineseAntitheticalCouplet(1)
        }
      })
      Item({
        title: String.chinese_character,
        remoteVersion: this.chineseCharacterRemoteVersion,
        localVersion: this.chineseCharacterLocalVersion,
        total: this.chineseCharacterTotal,
        progress: this.chineseCharacterCount,
        loading: this.chineseCharacterLoading,
        error: this.chineseCharacterLoadingError,
        clickEvent: (): void => {
          this.syncChineseCharacter(1)
        }
      })
      Item({
        title: String.chinese_expression,
        remoteVersion: this.chineseExpressionRemoteVersion,
        localVersion: this.chineseExpressionLocalVersion,
        total: this.chineseExpressionTotal,
        progress: this.chineseExpressionCount,
        loading: this.chineseExpressionLoading,
        error: this.chineseExpressionLoadingError,
        clickEvent: (): void => {
          this.syncChineseExpression(1)
        }
      })
      Item({
        title: String.chinese_idiom,
        remoteVersion: this.chineseIdiomRemoteVersion,
        localVersion: this.chineseIdiomLocalVersion,
        total: this.chineseIdiomTotal,
        progress: this.chineseIdiomCount,
        loading: this.chineseIdiomLoading,
        error: this.chineseIdiomLoadingError,
        clickEvent: (): void => {
          this.syncChineseIdiom(1)
        }
      })
      Item({
        title: String.chinese_knowledge,
        remoteVersion: this.chineseKnowledgeRemoteVersion,
        localVersion: this.chineseKnowledgeLocalVersion,
        total: this.chineseKnowledgeTotal,
        progress: this.chineseKnowledgeCount,
        loading: this.chineseKnowledgeLoading,
        error: this.chineseKnowledgeLoadingError,
        clickEvent: (): void => {
          this.syncChineseKnowledge(1)
        }
      })
      Item({
        title: String.chinese_quote,
        remoteVersion: this.chineseQuoteRemoteVersion,
        localVersion: this.chineseQuoteLocalVersion,
        total: this.chineseQuoteTotal,
        progress: this.chineseQuoteCount,
        loading: this.chineseQuoteLoading,
        error: this.chineseQuoteLoadingError,
        clickEvent: (): void => {
          this.syncChineseQuote(1)
        }
      })
      BlockTitle({ title: String.china })
      Item({
        title: String.china_worldcultureheritage,
        remoteVersion: this.chinaWorldCulturalHeritageRemoteVersion,
        localVersion: this.chinaWorldCulturalHeritageLocalVersion,
        total: this.chinaWorldCulturalHeritageTotal,
        progress: this.chinaWorldCulturalHeritageCount,
        loading: this.chinaWorldCulturalHeritageLoading,
        error: this.chinaWorldCulturalHeritageLoadingError,
        clickEvent: (): void => {
          this.syncChinaWorldCulturalHeritage(1)
        }
      })
    }
    .width('100%')
  }

  syncClassicalLiteratureClassicPoem(page: number) {
    this.classicalliteratureClassicpoemLoading = true;
    DatasetViewModel.getClassicalLiteratureClassicPoemList(this.classicalliteratureClassicpoemRemoteVersion, page)
      .then((wrapper: DataWrapper<ClassicPoem>) => {
        wrapper.data.map((obj: ClassicPoem) => {
          DatasetViewModel.insertClassicalLiteratureClassicPoemToDb(obj);
          this.classicalliteratureClassicpoemCount++;
        })
        if (wrapper.next_page) {
          this.syncClassicalLiteratureClassicPoem(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveClassicalLiteratureClassicPoemVersion(this.classicalliteratureClassicpoemRemoteVersion)
          this.classicalliteratureClassicpoemLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.classicalliteratureClassicpoemLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncClassicalLiteratureClassicPoem, code = ${error.code}, msg = ${error.message}`);
      this.classicalliteratureClassicpoemLoading = false;
    })
  }

  syncClassicalLiteratureSentence(page: number) {
    this.classicalliteratureSentenceLoading = true;
    DatasetViewModel.getClassicalLiteratureSentenceList(this.classicalliteratureSentenceRemoteVersion, page)
      .then((wrapper: DataWrapper<Sentence>) => {
        wrapper.data.map((obj: Sentence) => {
          DatasetViewModel.insertClassicalLiteratureSentenceToDb(obj);
          this.classicalliteratureSentenceCount++;
        })
        if (wrapper.next_page) {
          this.syncClassicalLiteratureSentence(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveClassicalLiteratureSentenceVersion(this.classicalliteratureSentenceRemoteVersion)
          this.classicalliteratureSentenceLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.classicalliteratureSentenceLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncClassicalLiteratureSentence, code = ${error.code}, msg = ${error.message}`);
      this.classicalliteratureSentenceLoading = false;
    })
  }

  syncChineseAntitheticalCouplet(page: number) {
    this.chineseAntitheticalCoupletLoading = true;
    DatasetViewModel.getChineseAntitheticalCoupletList(this.chineseAntitheticalCoupletRemoteVersion, page)
      .then((wrapper: DataWrapper<AntitheticalCouplet>) => {
        wrapper.data.map((obj: AntitheticalCouplet) => {
          DatasetViewModel.insertChineseAntitheticalCoupletToDb(obj)
          this.chineseAntitheticalCoupletCount++;
        })
        if (wrapper.next_page) {
          this.syncChineseAntitheticalCouplet(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseAntitheticalCoupletVersion(this.chineseAntitheticalCoupletRemoteVersion)
          this.chineseAntitheticalCoupletLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseAntitheticalCoupletLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseAntitheticalCouplet, code = ${error.code}, msg = ${error.message}`);
      this.chineseAntitheticalCoupletLoading = false;
    })
  }

  syncChineseCharacter(page: number) {
    this.chineseCharacterLoading = true;
    DatasetViewModel.getChineseCharacterList(this.chineseCharacterRemoteVersion, page)
      .then((wrapper: DataWrapper<Character>) => {
        wrapper.data.map((obj: Character) => {
          DatasetViewModel.insertChineseCharacterToDb(obj)
          this.chineseCharacterCount++;
        })
        if (wrapper.next_page) {
          this.syncChineseCharacter(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseCharacterVersion(this.chineseCharacterRemoteVersion)
          this.chineseCharacterLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseCharacterLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseCharacter, code = ${error.code}, msg = ${error.message}`);
      this.chineseCharacterLoading = false;
    })
  }

  syncChineseExpression(page: number) {
    this.chineseExpressionLoading = true;
    DatasetViewModel.getChineseExpressionList(this.chineseExpressionRemoteVersion, page)
      .then((wrapper: DataWrapper<Expression>) => {
        wrapper.data.map((obj: Expression) => {
          DatasetViewModel.insertChineseExpressionToDb(obj)
          this.chineseExpressionCount++;
        })
        if (wrapper.next_page) {
          this.syncChineseExpression(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseExpressionVersion(this.chineseExpressionRemoteVersion)
          this.chineseExpressionLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseExpressionLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseExpression, code = ${error.code}, msg = ${error.message}`);
      this.chineseExpressionLoading = false;
    })
  }

  syncChineseIdiom(page: number) {
    this.chineseIdiomLoading = true;
    DatasetViewModel.getChineseIdiomList(this.chineseIdiomRemoteVersion, page)
      .then((wrapper: DataWrapper<Idiom>) => {
        wrapper.data.map((obj: Idiom) => {
          DatasetViewModel.insertChineseIdiomToDb(obj)
          this.chineseIdiomCount++;
        })
        if (wrapper.next_page) {
          this.syncChineseIdiom(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseIdiomVersion(this.chineseIdiomRemoteVersion)
          this.chineseIdiomLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseIdiomLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseIdiom, code = ${error.code}, msg = ${error.message}`);
      this.chineseIdiomLoading = false;
    })
  }

  syncChineseKnowledge(page: number) {
    this.chineseKnowledgeLoading = true;
    DatasetViewModel.getChineseKnowledgeList(this.chineseKnowledgeRemoteVersion, page)
      .then((wrapper: DataWrapper<Knowledge>) => {
        wrapper.data.map((obj: Knowledge) => {
          DatasetViewModel.insertChineseKnowledgeToDb(obj)
          this.chineseKnowledgeCount++;
        })
        if (wrapper.next_page) {
          this.syncChineseKnowledge(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseKnowledgeVersion(this.chineseKnowledgeRemoteVersion)
          this.chineseKnowledgeLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseKnowledgeLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseKnowledge, code = ${error.code}, msg = ${error.message}`);
      this.chineseKnowledgeLoading = false;
    })
  }

  syncChineseQuote(page: number) {
    this.chineseQuoteLoading = true;
    DatasetViewModel.getChineseQuoteList(this.chineseQuoteRemoteVersion, page)
      .then((wrapper: DataWrapper<Quote>) => {
        wrapper.data.map((obj: Quote) => {
          DatasetViewModel.insertChineseQuoteToDb(obj)
          this.chineseQuoteCount++;
        })
        if (wrapper.next_page) {
          this.syncChineseQuote(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseQuoteVersion(this.chineseQuoteRemoteVersion)
          this.chineseQuoteLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseQuoteLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseQuote, code = ${error.code}, msg = ${error.message}`);
      this.chineseQuoteLoading = false;
    })
  }

  syncChinaWorldCulturalHeritage(page: number) {
    this.chinaWorldCulturalHeritageLoading = true;
    DatasetViewModel.getChinaWorldCulturalHeritageList(this.chinaWorldCulturalHeritageRemoteVersion, page)
      .then((wrapper: DataWrapper<WorldCulturalHeritage>) => {
        wrapper.data.map((obj: WorldCulturalHeritage) => {
          DatasetViewModel.insertChinaWorldCulturalHeritageToDb(obj)
          this.chinaWorldCulturalHeritageCount++;
        })
        if (wrapper.next_page) {
          this.syncChinaWorldCulturalHeritage(wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChinaWorldCulturalHeritageVersion(this.chinaWorldCulturalHeritageRemoteVersion)
          this.chinaWorldCulturalHeritageLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chinaWorldCulturalHeritageLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChinaWorldCulturalHeritage, code = ${error.code}, msg = ${error.message}`);
      this.chinaWorldCulturalHeritageLoading = false;
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
            .onClick(() => {
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