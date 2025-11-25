import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../log/Logger';
import { PrefConst } from 'constants';

export class PrefUtil {
  preference?: preferences.Preferences;
  logger: Logger = new Logger('PrefUtil');

  init(context: Context) {
    let options: preferences.Options = { name: PrefConst.PREF_NAME, storageType: preferences.StorageType.GSKV };
    try {
      this.preference = preferences.getPreferencesSync(context, options);
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`Init pref failed, code = ${err.code}, messge = ${err.message}`)
    }
  }

  saveChinaWorldCulturalHeritageVersion(version: number) {
    this.setNumber(PrefConst.CHINA_WORLDCULTUREHERITAGE, version)
  }

  getChinaWorldCulturalHeritageVersion(): number {
    return this.getNumber(PrefConst.CHINA_WORLDCULTUREHERITAGE)
  }

  saveChineseAntitheticalCoupletVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_ANTITHETICALCOUPLET, version)
  }

  getChineseAntitheticalCoupletVersion(): number {
    return this.getNumber(PrefConst.CHINESE_ANTITHETICALCOUPLET)
  }

  saveChineseCharacterVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_CHARACTER, version)
  }

  getChineseCharacterVersion(): number {
    return this.getNumber(PrefConst.CHINESE_CHARACTER)
  }

  saveChineseExpressionVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_EXPRESSION, version)
  }

  getChineseExpressionVersion(): number {
    return this.getNumber(PrefConst.CHINESE_EXPRESSION)
  }

  saveChineseIdiomVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_IDIOM, version)
  }

  getChineseIdiomVersion(): number {
    return this.getNumber(PrefConst.CHINESE_IDIOM)
  }

  saveChineseKnowledgeVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_KNOWLEDGE, version)
  }

  getChineseKnowledgeVersion(): number {
    return this.getNumber(PrefConst.CHINESE_KNOWLEDGE)
  }

  saveChineseQuoteVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_QUOTE, version)
  }

  getChineseQuoteVersion(): number {
    return this.getNumber(PrefConst.CHINESE_QUOTE)
  }

  saveClassicalLiteratureClassicPoemVersion(version: number) {
    this.setNumber(PrefConst.CLASSICALLITERATURE_CLASSICPOEM, version)
  }

  getClassicalLiteratureClassicPoemVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
  }

  saveClassicalLiteratureSentenceVersion(version: number) {
    this.setNumber(PrefConst.CLASSICALLITERATURE_SENTENCE, version)
  }

  getClassicalLiteratureSentenceVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_SENTENCE)
  }

  private setNumber(key: string, data: number) {
    try {
      this.preference?.putSync(key, data)
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`save data failed, key = ${key}, code = ${err.code}, messge = ${err.message}`)
    }
  }

  private getNumber(key: string, defaultValue: number = 0): number {
    let value = 0
    try {
      value = this.preference?.getSync(key, defaultValue) as number
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`get data failed, key = ${key}, code = ${err.code}, messge = ${err.message}`)
    }

    return value;
  }
}

export default new PrefUtil()