import { BusinessError } from '@kit.BasicServicesKit';
import { PromptAction, ShowDialogSuccessResponse } from '@kit.ArkUI';
import { DataWrapper, httpRequestGet, Logger, ResponseResult } from 'utils';
import { DbTableConst, Icon, NetworkConst, PrefConst, String, ThemeConst } from 'constants';
import { BlockTitle } from 'uicomponents';
import { relationalStore } from '@kit.ArkData';
import { taskpool } from '@kit.ArkTS';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';
import DatasetViewModel from '../viewmodel/DatasetViewModel';
import Dataset from '../model/Dataset';
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

let logger: Logger = new Logger('SyncData');

@ComponentV2
export struct SyncDataList {
  @Local promptAction: PromptAction = this.getUIContext().getPromptAction();
  @Param @Require @Once dataset: Dataset[]
  @Local classicalliteratureClassicpoemLocalVersion: number = PrefUtil.getClassicalLiteratureClassicPoemVersion();
  @Local classicalliteratureClassicpoemRemoteVersion: number = 0;
  @Local classicalliteratureClassicpoemTotal: number = 0;
  @Local classicalliteratureClassicpoemCount: number = 0;
  @Local classicalliteratureClassicpoemLoading: boolean = false;
  @Local classicalliteratureClassicpoemLoadingError: string | null = null;
  @Local classicalliteraturePeopleLocalVersion: number = PrefUtil.getClassicalLiteraturePeopleVersion();
  @Local classicalliteraturePeopleRemoteVersion: number = 0;
  @Local classicalliteraturePeopleTotal: number = 0;
  @Local classicalliteraturePeopleCount: number = 0;
  @Local classicalliteraturePeopleLoading: boolean = false;
  @Local classicalliteraturePeopleLoadingError: string | null = null;
  @Local classicalliteratureSentenceLocalVersion: number = PrefUtil.getClassicalLiteratureSentenceVersion();
  @Local classicalliteratureSentenceRemoteVersion: number = 0;
  @Local classicalliteratureSentenceTotal: number = 0;
  @Local classicalliteratureSentenceCount: number = 0;
  @Local classicalliteratureSentenceLoading: boolean = false;
  @Local classicalliteratureSentenceLoadingError: string | null = null;
  @Local classicalliteratureWritingLocalVersion: number = PrefUtil.getClassicalLiteratureWritingVersion();
  @Local classicalliteratureWritingRemoteVersion: number = 0;
  @Local classicalliteratureWritingTotal: number = 0;
  @Local classicalliteratureWritingCount: number = 0;
  @Local classicalliteratureWritingLoading: boolean = false;
  @Local classicalliteratureWritingLoadingError: string | null = null;
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
  @Local chineseLyricLocalVersion: number = PrefUtil.getChineseLyricVersion();
  @Local chineseLyricRemoteVersion: number = 0;
  @Local chineseLyricTotal: number = 0;
  @Local chineseLyricCount: number = 0;
  @Local chineseLyricLoading: boolean = false;
  @Local chineseLyricLoadingError: string | null = null;
  @Local chinesePoetryLocalVersion: number = PrefUtil.getChineseModernPoetryVersion();
  @Local chineseModernPoetryRemoteVersion: number = 0;
  @Local chineseModernPoetryTotal: number = 0;
  @Local chineseModernPoetryCount: number = 0;
  @Local chineseModernPoetryLoading: boolean = false;
  @Local chineseModernPoetryLoadingError: string | null = null;
  @Local chineseProverbLocalVersion: number = PrefUtil.getChineseProverbVersion();
  @Local chineseProverbRemoteVersion: number = 0;
  @Local chineseProverbTotal: number = 0;
  @Local chineseProverbCount: number = 0;
  @Local chineseProverbLoading: boolean = false;
  @Local chineseProverbLoadingError: string | null = null;
  @Local chineseQuoteLocalVersion: number = PrefUtil.getChineseQuoteVersion();
  @Local chineseQuoteRemoteVersion: number = 0;
  @Local chineseQuoteTotal: number = 0;
  @Local chineseQuoteCount: number = 0;
  @Local chineseQuoteLoading: boolean = false;
  @Local chineseQuoteLoadingError: string | null = null;
  @Local chineseRiddleLocalVersion: number = PrefUtil.getChineseRiddleVersion();
  @Local chineseRiddleRemoteVersion: number = 0;
  @Local chineseRiddleTotal: number = 0;
  @Local chineseRiddleCount: number = 0;
  @Local chineseRiddleLoading: boolean = false;
  @Local chineseRiddleLoadingError: string | null = null;
  @Local chineseTongueTwisterLocalVersion: number = PrefUtil.getChineseTongueTwisterVersion();
  @Local chineseTongueTwisterRemoteVersion: number = 0;
  @Local chineseTongueTwisterTotal: number = 0;
  @Local chineseTongueTwisterCount: number = 0;
  @Local chineseTongueTwisterLoading: boolean = false;
  @Local chineseTongueTwisterLoadingError: string | null = null;
  @Local chineseWisecrackLocalVersion: number = PrefUtil.getChineseWisecrackVersion();
  @Local chineseWisecrackRemoteVersion: number = 0;
  @Local chineseWisecrackTotal: number = 0;
  @Local chineseWisecrackCount: number = 0;
  @Local chineseWisecrackLoading: boolean = false;
  @Local chineseWisecrackLoadingError: string | null = null;
  @Local chinaWorldCulturalHeritageLocalVersion: number = PrefUtil.getChinaWorldCulturalHeritageVersion();
  @Local chinaWorldCulturalHeritageRemoteVersion: number = 0;
  @Local chinaWorldCulturalHeritageTotal: number = 0;
  @Local chinaWorldCulturalHeritageCount: number = 0;
  @Local chinaWorldCulturalHeritageLoading: boolean = false;
  @Local chinaWorldCulturalHeritageLoadingError: string | null = null;
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
          this.chinaWorldCulturalHeritageCount += info.inserted.length
        }
      }
    }
  @Local observer: Callback<string> = (key: string) => {
    if (key == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
      this.classicalliteratureClassicpoemLocalVersion = PrefUtil.getClassicalLiteratureClassicPoemVersion();
    } else if (key == PrefConst.CLASSICALLITERATURE_PEOPLE) {
      this.classicalliteraturePeopleLocalVersion = PrefUtil.getClassicalLiteraturePeopleVersion()
    } else if (key == PrefConst.CLASSICALLITERATURE_SENTENCE) {
      this.classicalliteratureSentenceLocalVersion = PrefUtil.getClassicalLiteratureSentenceVersion()
    } else if (key == PrefConst.CLASSICALLITERATURE_WRITING) {
      this.classicalliteratureWritingLocalVersion = PrefUtil.getClassicalLiteratureWritingVersion()
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
    } else if (key == PrefConst.CHINESE_LYRIC) {
      this.chineseLyricLocalVersion = PrefUtil.getChineseLyricVersion()
    } else if (key == PrefConst.CHINESE_MODERNPOETRY) {
      this.chinesePoetryLocalVersion = PrefUtil.getChineseModernPoetryVersion()
    } else if (key == PrefConst.CHINESE_PROVERB) {
      this.chineseProverbLocalVersion = PrefUtil.getChineseProverbVersion()
    } else if (key == PrefConst.CHINESE_QUOTE) {
      this.chineseQuoteLocalVersion = PrefUtil.getChineseQuoteVersion()
    } else if (key == PrefConst.CHINESE_RIDDLE) {
      this.chineseRiddleLocalVersion = PrefUtil.getChineseRiddleVersion()
    } else if (key == PrefConst.CHINESE_TONGUETWISTER) {
      this.chineseTongueTwisterLocalVersion = PrefUtil.getChineseTongueTwisterVersion()
    } else if (key == PrefConst.CHINESE_WISECRACK) {
      this.chineseWisecrackLocalVersion = PrefUtil.getChineseWisecrackVersion()
    } else if (key == PrefConst.CHINA_WORLDCULTUREHERITAGE) {
      this.chinaWorldCulturalHeritageLocalVersion = PrefUtil.getChinaWorldCulturalHeritageVersion()
    }
  }

  aboutToAppear(): void {
    this.dataset.forEach((item: Dataset) => {
      if (item.name == PrefConst.CLASSICALLITERATURE_CLASSICPOEM) {
        this.classicalliteratureClassicpoemRemoteVersion = item.version;
        this.classicalliteratureClassicpoemTotal = item.count;
      } else if (item.name == PrefConst.CLASSICALLITERATURE_WRITING) {
        this.classicalliteratureWritingRemoteVersion = item.version;
        this.classicalliteratureWritingTotal = item.count;
      } else if (item.name == PrefConst.CLASSICALLITERATURE_SENTENCE) {
        this.classicalliteratureSentenceRemoteVersion = item.version;
        this.classicalliteratureSentenceTotal = item.count;
      } else if (item.name == PrefConst.CLASSICALLITERATURE_PEOPLE) {
        this.classicalliteraturePeopleRemoteVersion = item.version;
        this.classicalliteraturePeopleTotal = item.count;
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
      } else if (item.name == PrefConst.CHINESE_LYRIC) {
        this.chineseLyricRemoteVersion = item.version;
        this.chineseLyricTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_MODERNPOETRY) {
        this.chineseModernPoetryRemoteVersion = item.version;
        this.chineseModernPoetryTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_PROVERB) {
        this.chineseProverbRemoteVersion = item.version;
        this.chineseProverbTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_QUOTE) {
        this.chineseQuoteRemoteVersion = item.version;
        this.chineseQuoteTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_RIDDLE) {
        this.chineseRiddleRemoteVersion = item.version;
        this.chineseRiddleTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_TONGUETWISTER) {
        this.chineseTongueTwisterRemoteVersion = item.version;
        this.chineseTongueTwisterTotal = item.count;
      } else if (item.name == PrefConst.CHINESE_WISECRACK) {
        this.chineseWisecrackRemoteVersion = item.version;
        this.chineseWisecrackTotal = item.count;
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
      PrefUtil.preference?.off('change', this.observer)
    } catch (error) {
      logger.error(`preference off change observer error = ${error}`);
    }

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
        remoteVersion: this.classicalliteratureClassicpoemRemoteVersion,
        localVersion: this.classicalliteratureClassicpoemLocalVersion,
        total: this.classicalliteratureClassicpoemTotal,
        progress: this.classicalliteratureClassicpoemCount,
        loading: this.classicalliteratureClassicpoemLoading,
        error: this.classicalliteratureClassicpoemLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncClassicalLiteratureClassicPoem(context)
        }
      })
      /*Item({
        title: String.classicalliterature_writing,
        remoteVersion: this.classicalliteratureWritingRemoteVersion,
        localVersion: this.classicalliteratureWritingLocalVersion,
        total: this.classicalliteratureWritingTotal,
        progress: this.classicalliteratureWritingCount,
        loading: this.classicalliteratureWritingLoading,
        error: this.classicalliteratureWritingLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncClassicalLiteratureWriting(context)
        }
      })*/
      Item({
        title: String.classicalliterature_sentence,
        remoteVersion: this.classicalliteratureSentenceRemoteVersion,
        localVersion: this.classicalliteratureSentenceLocalVersion,
        total: this.classicalliteratureSentenceTotal,
        progress: this.classicalliteratureSentenceCount,
        loading: this.classicalliteratureSentenceLoading,
        error: this.classicalliteratureSentenceLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncClassicalLiteratureSentence(context)
        }
      })
      Item({
        title: String.classicalliterature_people,
        remoteVersion: this.classicalliteraturePeopleRemoteVersion,
        localVersion: this.classicalliteraturePeopleLocalVersion,
        total: this.classicalliteraturePeopleTotal,
        progress: this.classicalliteraturePeopleCount,
        loading: this.classicalliteraturePeopleLoading,
        error: this.classicalliteraturePeopleLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncClassicalLiteraturePeople(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseAntitheticalCouplet(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseCharacter(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseExpression(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseIdiom(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseKnowledge(context)
        }
      })
      Item({
        title: String.chinese_lyric,
        remoteVersion: this.chineseLyricRemoteVersion,
        localVersion: this.chineseLyricLocalVersion,
        total: this.chineseLyricTotal,
        progress: this.chineseLyricCount,
        loading: this.chineseLyricLoading,
        error: this.chineseLyricLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseLyric(context)
        }
      })
      Item({
        title: String.chinese_modernpoetry,
        remoteVersion: this.chineseModernPoetryRemoteVersion,
        localVersion: this.chinesePoetryLocalVersion,
        total: this.chineseModernPoetryTotal,
        progress: this.chineseModernPoetryCount,
        loading: this.chineseModernPoetryLoading,
        error: this.chineseModernPoetryLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseModernPoetry(context)
        }
      })
      Item({
        title: String.chinese_proverb,
        remoteVersion: this.chineseProverbRemoteVersion,
        localVersion: this.chineseProverbLocalVersion,
        total: this.chineseProverbTotal,
        progress: this.chineseProverbCount,
        loading: this.chineseProverbLoading,
        error: this.chineseProverbLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseProverb(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseQuote(context)
        }
      })
      Item({
        title: String.chinese_riddle,
        remoteVersion: this.chineseRiddleRemoteVersion,
        localVersion: this.chineseRiddleLocalVersion,
        total: this.chineseRiddleTotal,
        progress: this.chineseRiddleCount,
        loading: this.chineseRiddleLoading,
        error: this.chineseRiddleLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseRiddle(context)
        }
      })
      Item({
        title: String.chinese_tonguetwister,
        remoteVersion: this.chineseTongueTwisterRemoteVersion,
        localVersion: this.chineseTongueTwisterLocalVersion,
        total: this.chineseTongueTwisterTotal,
        progress: this.chineseTongueTwisterCount,
        loading: this.chineseTongueTwisterLoading,
        error: this.chineseTongueTwisterLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseTongueTwister(context)
        }
      })
      Item({
        title: String.chinese_wisecrack,
        remoteVersion: this.chineseWisecrackRemoteVersion,
        localVersion: this.chineseWisecrackLocalVersion,
        total: this.chineseWisecrackTotal,
        progress: this.chineseWisecrackCount,
        loading: this.chineseWisecrackLoading,
        error: this.chineseWisecrackLoadingError,
        clickEvent: (): void => {
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChineseWisecrack(context)
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
          let context: Context = this.getUIContext().getHostContext() as Context;
          this.syncChinaWorldCulturalHeritage(context)
        }
      })
    }
    .width('100%')
    .onAppear(() => {
      this.promptAction.showDialog({
        'title': '温馨提示',
        'message': '为了避免占用内存过多导致应用奔溃，请一项一项同步。',
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

  syncClassicalLiteratureClassicPoem(context: Context, page: number = 1) {
    this.classicalliteratureClassicpoemLoading = true;
    DatasetViewModel.getClassicalLiteratureClassicPoemList(this.classicalliteratureClassicpoemRemoteVersion, page)
      .then((wrapper: DataWrapper<ClassicPoem>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertClassicPoem, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
            taskpool.execute(batchInsertClassicPoemFTS, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncClassicalLiteratureClassicPoem(context, wrapper.next_page);
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

  syncClassicalLiteraturePeople(context: Context, page: number = 1) {
    this.classicalliteraturePeopleLoading = true;
    DatasetViewModel.getClassicalLiteraturePeopleList(this.classicalliteraturePeopleRemoteVersion, page)
      .then((wrapper: DataWrapper<People>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertPeople, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncClassicalLiteraturePeople(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveClassicalLiteraturePeopleVersion(this.classicalliteraturePeopleRemoteVersion)
          this.classicalliteraturePeopleLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.classicalliteraturePeopleLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncClassicalLiteraturePeople, code = ${error.code}, msg = ${error.message}`);
      this.classicalliteraturePeopleLoading = false;
    })
  }

  syncClassicalLiteratureSentence(context: Context, page: number = 1) {
    this.classicalliteratureSentenceLoading = true;
    DatasetViewModel.getClassicalLiteratureSentenceList(this.classicalliteratureSentenceRemoteVersion, page)
      .then((wrapper: DataWrapper<Sentence>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertSentence, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncClassicalLiteratureSentence(context, wrapper.next_page);
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

  syncClassicalLiteratureWriting(context: Context, page: number = 1) {
    this.classicalliteratureWritingLoading = true;
    taskpool.execute(getWritings,this.classicalliteratureWritingRemoteVersion, page)
      .then((obj: object) => {
        let wrapper = obj as  DataWrapper<Writing>;

        logger.info(`datawrapper total = ${wrapper.total}`)

        let objs = wrapper.data

        let limit: number = 50;
        if (page <= 1) {
          limit = 50;
        } else if (page <= 2) {
          limit = 20;
        } else if (page <= 5) {
          limit = 100;
        } else if (page <= 8) {
          limit = 200;
        } else {
          limit = 180;
        }

        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > limit ? limit : objs.length)
            taskpool.execute(batchInsertWriting, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
            taskpool.execute(batchInsertWritingFTS, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncClassicalLiteratureWriting(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveClassicalLiteratureWritingVersion(this.classicalliteratureWritingRemoteVersion)
          this.classicalliteratureWritingLoading = false;
        }
      })
      .catch((err: BusinessError) => {
        logger.error(` taskpool.execute(getWritings), code = ${err.code}, msg = ${err.message}`);
        this.classicalliteratureWritingLoading = false;
      })
    /*DatasetViewModel.getClassicalLiteratureWritingList(this.classicalliteratureWritingRemoteVersion, page)
      .then((wrapper: DataWrapper<Writing>) => {
        let objs = wrapper.data
        let limit: number = 50;
        if (page <= 1) {
          limit = 50;
        } else if (page <= 2) {
          limit = 20;
        } else if (page <= 5) {
          limit = 100;
        } else if (page <= 8) {
          limit = 200;
        } else {
          limit = 180;
        }

        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > limit ? limit : objs.length)
            taskpool.execute(batchInsertWriting, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
            taskpool.execute(batchInsertWritingFTS, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncClassicalLiteratureWriting(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveClassicalLiteratureWritingVersion(this.classicalliteratureWritingRemoteVersion)
          this.classicalliteratureWritingLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.classicalliteratureWritingLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncClassicalLiteratureWriting, code = ${error.code}, msg = ${error.message}`);
      this.classicalliteratureWritingLoading = false;
    })*/
  }

  syncChineseAntitheticalCouplet(context: Context, page: number = 1) {
    this.chineseAntitheticalCoupletLoading = true;
    DatasetViewModel.getChineseAntitheticalCoupletList(this.chineseAntitheticalCoupletRemoteVersion, page)
      .then((wrapper: DataWrapper<AntitheticalCouplet>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertAntitheticalCouplet, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncChineseAntitheticalCouplet(context, wrapper.next_page);
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

  syncChineseCharacter(context: Context, page: number = 1) {
    this.chineseCharacterLoading = true;
    DatasetViewModel.getChineseCharacterList(this.chineseCharacterRemoteVersion, page)
      .then((wrapper: DataWrapper<Character>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertCharacter, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncChineseCharacter(context, wrapper.next_page);
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

  syncChineseExpression(context: Context, page: number = 1) {
    this.chineseExpressionLoading = true;
    DatasetViewModel.getChineseExpressionList(this.chineseExpressionRemoteVersion, page)
      .then((wrapper: DataWrapper<Expression>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertExpression, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseExpression(context, wrapper.next_page);
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

  syncChineseIdiom(context: Context, page: number = 1) {
    this.chineseIdiomLoading = true;
    DatasetViewModel.getChineseIdiomList(this.chineseIdiomRemoteVersion, page)
      .then((wrapper: DataWrapper<Idiom>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertIdiom, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncChineseIdiom(context, wrapper.next_page);
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

  syncChineseKnowledge(context: Context, page: number = 1) {
    this.chineseKnowledgeLoading = true;
    DatasetViewModel.getChineseKnowledgeList(this.chineseKnowledgeRemoteVersion, page)
      .then((wrapper: DataWrapper<Knowledge>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertKnowledge, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncChineseKnowledge(context, wrapper.next_page);
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

  syncChineseLyric(context: Context, page: number = 1) {
    this.chineseLyricLoading = true;
    DatasetViewModel.getChineseLyricList(this.chineseLyricRemoteVersion, page)
      .then((wrapper: DataWrapper<Lyric>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertLyric, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
            taskpool.execute(batchInsertLyricFTS, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseLyric(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseLyricVersion(this.chineseLyricRemoteVersion)
          this.chineseLyricLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseLyricLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseLyric, code = ${error.code}, msg = ${error.message}`);
      this.chineseLyricLoading = false;
    })
  }

  syncChineseModernPoetry(context: Context, page: number = 1) {
    this.chineseModernPoetryLoading = true;
    DatasetViewModel.getChineseModernPoetryList(this.chineseModernPoetryRemoteVersion, page)
      .then((wrapper: DataWrapper<ModernPoetry>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertModernPoetry, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
            taskpool.execute(batchInsertModernPoetryFTS, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseModernPoetry(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseModernPoetryVersion(this.chineseModernPoetryRemoteVersion)
          this.chineseModernPoetryLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseModernPoetryLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseModernPoetry, code = ${error.code}, msg = ${error.message}`);
      this.chineseModernPoetryLoading = false;
    })
  }

  syncChineseProverb(context: Context, page: number = 1) {
    this.chineseProverbLoading = true;
    DatasetViewModel.getChineseProverbList(this.chineseProverbRemoteVersion, page)
      .then((wrapper: DataWrapper<Proverb>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertProverb, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseProverb(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseProverbVersion(this.chineseProverbRemoteVersion)
          this.chineseProverbLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseProverbLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseProverb, code = ${error.code}, msg = ${error.message}`);
      this.chineseProverbLoading = false;
    })
  }

  syncChineseQuote(context: Context, page: number = 1) {
    this.chineseQuoteLoading = true;
    DatasetViewModel.getChineseQuoteList(this.chineseQuoteRemoteVersion, page)
      .then((wrapper: DataWrapper<Quote>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertQuote, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncChineseQuote(context, wrapper.next_page);
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

  syncChineseRiddle(context: Context, page: number = 1) {
    this.chineseRiddleLoading = true;
    DatasetViewModel.getChineseRiddleList(this.chineseRiddleRemoteVersion, page)
      .then((wrapper: DataWrapper<Riddle>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertRiddle, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseRiddle(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseRiddleVersion(this.chineseRiddleRemoteVersion)
          this.chineseRiddleLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseRiddleLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseRiddle, code = ${error.code}, msg = ${error.message}`);
      this.chineseRiddleLoading = false;
    })
  }

  syncChineseTongueTwister(context: Context, page: number = 1) {
    this.chineseTongueTwisterLoading = true;
    DatasetViewModel.getChineseRTongueTwisterList(this.chineseTongueTwisterRemoteVersion, page)
      .then((wrapper: DataWrapper<TongueTwister>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertTongueTwister, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseTongueTwister(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseTongueTwisterVersion(this.chineseTongueTwisterRemoteVersion)
          this.chineseTongueTwisterLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseTongueTwisterLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseTongueTwister, code = ${error.code}, msg = ${error.message}`);
      this.chineseTongueTwisterLoading = false;
    })
  }

  syncChineseWisecrack(context: Context, page: number = 1) {
    this.chineseWisecrackLoading = true;
    DatasetViewModel.getChineseWisecrackList(this.chineseWisecrackRemoteVersion, page)
      .then((wrapper: DataWrapper<Wisecrack>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertWisecrack, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }

        if (wrapper.next_page) {
          this.syncChineseWisecrack(context, wrapper.next_page);
        }
        if (!wrapper.next_page) {
          PrefUtil.saveChineseWisecrackVersion(this.chineseWisecrackRemoteVersion)
          this.chineseWisecrackLoading = false;
        }
      }).catch((error: BusinessError) => {
      this.chineseWisecrackLoadingError = `code = ${error.code}, msg = ${error.message}`;
      logger.error(`syncChineseWisecrack, code = ${error.code}, msg = ${error.message}`);
      this.chineseWisecrackLoading = false;
    })
  }

  syncChinaWorldCulturalHeritage(context: Context, page: number = 1) {
    this.chinaWorldCulturalHeritageLoading = true;
    DatasetViewModel.getChinaWorldCulturalHeritageList(this.chinaWorldCulturalHeritageRemoteVersion, page)
      .then((wrapper: DataWrapper<WorldCulturalHeritage>) => {
        let objs = wrapper.data
        try {
          while (objs.length) {
            let spliced = objs.splice(0, objs.length > 500 ? 500 : objs.length)
            taskpool.execute(batchInsertWorldCulturalHeritage, context, spliced).catch((error: BusinessError) => {
              logger.error(`expression taskpool execute error, code = ${error.code} message = ${error.message}`)
            })
          }
        } catch (error) {
          let err = error as BusinessError
          logger.error(`taskpool.execute error code = ${err.code} message = ${err.message}`)
        }
        if (wrapper.next_page) {
          this.syncChinaWorldCulturalHeritage(context, wrapper.next_page);
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
            .color($r('sys.color.ohos_id_color_text_primary'))
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
                .backgroundColor(ThemeConst.BackGroundColor_Pressed)
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

@Concurrent
async function getWritings(version: number, page: number = 1): Promise<DataWrapper<Writing>>{
  return await DatasetViewModel.getClassicalLiteratureWritingList(version, page)
}