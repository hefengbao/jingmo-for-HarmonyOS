import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../log/Logger';
import { PrefConst } from 'constants';

/**
 * 在 products/default/src/main/ets/entryability/EntryAbility.ets 的 onCreate() 初始化
 */
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

  saveUserAgreementVersion(version: number) {
    this.set(PrefConst.USER_AGREEMENT_VERSION, version)
  }

  getUserAgreementVersion(): number {
    return this.getNumber(PrefConst.USER_AGREEMENT_VERSION)
  }

  saveIsFirstLaunch(bool: boolean) {
    this.set(PrefConst.IS_FIRST_LAUNCH, bool)
  }

  getIsFirstLaunch(): boolean {
    return this.getBoolean(PrefConst.IS_FIRST_LAUNCH, true)
  }

  saveSettingThemeMode(mode: number) {
    this.set(PrefConst.SETTING_THEME_MODE, mode)
  }

  getSettingThemeMode(): number {
    return this.getNumber(PrefConst.SETTING_THEME_MODE)
  }

  saveChinaWorldCulturalHeritageVersion(version: number) {
    this.set(PrefConst.CHINA_WORLDCULTUREHERITAGE, version)
  }

  getChinaWorldCulturalHeritageVersion(): number {
    return this.getNumber(PrefConst.CHINA_WORLDCULTUREHERITAGE)
  }

  saveChineseAntitheticalCoupletVersion(version: number) {
    this.set(PrefConst.CHINESE_ANTITHETICALCOUPLET, version)
  }

  getChineseAntitheticalCoupletVersion(): number {
    return this.getNumber(PrefConst.CHINESE_ANTITHETICALCOUPLET)
  }

  saveChineseCharacterVersion(version: number) {
    this.set(PrefConst.CHINESE_CHARACTER, version)
  }

  getChineseCharacterVersion(): number {
    return this.getNumber(PrefConst.CHINESE_CHARACTER)
  }

  saveChineseExpressionVersion(version: number) {
    this.set(PrefConst.CHINESE_EXPRESSION, version)
  }

  getChineseExpressionVersion(): number {
    return this.getNumber(PrefConst.CHINESE_EXPRESSION)
  }

  saveChineseIdiomVersion(version: number) {
    this.set(PrefConst.CHINESE_IDIOM, version)
  }

  getChineseIdiomVersion(): number {
    return this.getNumber(PrefConst.CHINESE_IDIOM)
  }

  saveChineseKnowledgeVersion(version: number) {
    this.set(PrefConst.CHINESE_KNOWLEDGE, version)
  }

  getChineseKnowledgeVersion(): number {
    return this.getNumber(PrefConst.CHINESE_KNOWLEDGE)
  }

  getChineseLyricVersion(): number {
    return this.getNumber(PrefConst.CHINESE_LYRIC)
  }

  saveChineseLyricVersion(version: number) {
    this.set(PrefConst.CHINESE_LYRIC, version)
  }

  getChineseModernPoetryVersion(): number {
    return this.getNumber(PrefConst.CHINESE_MODERNPOETRY)
  }

  saveChineseModernPoetryVersion(version: number) {
    this.set(PrefConst.CHINESE_MODERNPOETRY, version)
  }

  getChineseProverbVersion(): number {
    return this.getNumber(PrefConst.CHINESE_PROVERB)
  }

  saveChineseProverbVersion(version: number) {
    this.set(PrefConst.CHINESE_PROVERB, version)
  }

  getChineseQuoteVersion(): number {
    return this.getNumber(PrefConst.CHINESE_QUOTE)
  }

  saveChineseQuoteVersion(version: number) {
    this.set(PrefConst.CHINESE_QUOTE, version)
  }

  getChineseRiddleVersion(): number {
    return this.getNumber(PrefConst.CHINESE_RIDDLE)
  }

  saveChineseRiddleVersion(version: number) {
    this.set(PrefConst.CHINESE_RIDDLE, version)
  }

  getChineseTongueTwisterVersion(): number {
    return this.getNumber(PrefConst.CHINESE_TONGUETWISTER)
  }

  saveChineseTongueTwisterVersion(version: number) {
    this.set(PrefConst.CHINESE_TONGUETWISTER, version)
  }

  getChineseWisecrackVersion(): number {
    return this.getNumber(PrefConst.CHINESE_WISECRACK)
  }

  saveChineseWisecrackVersion(version: number) {
    this.set(PrefConst.CHINESE_WISECRACK, version)
  }

  saveClassicalLiteratureClassicPoemVersion(version: number) {
    this.set(PrefConst.CLASSICALLITERATURE_CLASSICPOEM, version)
  }

  getClassicalLiteratureClassicPoemVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
  }

  saveClassicalLiteraturePeopleVersion(version: number) {
    this.set(PrefConst.CLASSICALLITERATURE_PEOPLE, version)
  }

  getClassicalLiteraturePeopleVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_PEOPLE)
  }

  saveClassicalLiteratureSentenceVersion(version: number) {
    this.set(PrefConst.CLASSICALLITERATURE_SENTENCE, version)
  }

  getClassicalLiteratureSentenceVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_SENTENCE)
  }

  saveClassicalLiteratureWritingVersion(version: number) {
    this.set(PrefConst.CLASSICALLITERATURE_WRITING, version)
  }

  getClassicalLiteratureWritingVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_WRITING)
  }

  saveSnapshotFontColor(color: string) {
    this.set(PrefConst.SNAPSHOT_FONT_COLOR, color)
  }

  getSnapshotFontColor(): string {
    return this.getString(PrefConst.SNAPSHOT_FONT_COLOR, '#000000');
  }

  saveSnapshotFontSize(size: number) {
    this.set(PrefConst.SNAPSHOT_FONT_SIZE, size)
  }

  getSnapshotFontSize(): number {
    return this.getNumber(PrefConst.SNAPSHOT_FONT_SIZE, 18)
  }

  saveSnapshotPaddingX(x: number) {
    this.set(PrefConst.SNAPSHOT_PADDING_X, x)
  }

  getSnapshotPaddingX(): number {
    return this.getNumber(PrefConst.SNAPSHOT_PADDING_X, 16)
  }

  saveSnapshotPaddingY(y: number) {
    this.set(PrefConst.SNAPSHOT_PADDING_Y, y)
  }

  getSnapshotPaddingY(): number {
    return this.getNumber(PrefConst.SNAPSHOT_PADDING_Y, 32)
  }

  saveSnapshotBackgroundColor(color: string) {
    this.set(PrefConst.SNAPSHOT_BACKGROUND_COLOR, color)
  }

  getSnapshotBackgroundColor(): string {
    return this.getString(PrefConst.SNAPSHOT_BACKGROUND_COLOR, '#426666')
  }

  public getBoolean(key: string, defaultValue: boolean = false) {
    let value = defaultValue;

    try {
      value = this.preference?.getSync(key, defaultValue) as boolean
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`get data failed, key = ${key}, code = ${err.code}, messge = ${err.message}`)
    }

    return value;
  }

  private getNumber(key: string, defaultValue: number = 0): number {
    let value = defaultValue
    try {
      value = this.preference?.getSync(key, defaultValue) as number
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`get data failed, key = ${key}, code = ${err.code}, messge = ${err.message}`)
    }

    return value;
  }

  private getString(key: string, defaultValue: string = ''): string {
    let value = defaultValue
    try {
      value = this.preference?.getSync(key, defaultValue) as string
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`get data failed, key = ${key}, code = ${err.code}, messge = ${err.message}`)
    }
    return value;
  }

  private set(key: string, data: boolean | number | string) {
    try {
      this.preference?.putSync(key, data)
    } catch (error) {
      let err = error as BusinessError
      this.logger.error(`save data failed, key = ${key}, code = ${err.code}, messge = ${err.message}`)
    }
  }
}

export default new PrefUtil()