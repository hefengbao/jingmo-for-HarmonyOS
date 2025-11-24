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

  saveClassicalCultureClassicPoemVersion(version: number) {
    this.setNumber(PrefConst.CLASSICALLITERATURE_CLASSICPOEM, version)
  }

  getClassicalCultureClassicPoemVersion(): number {
    return this.getNumber(PrefConst.CLASSICALLITERATURE_CLASSICPOEM)
  }

  saveChineseCharacterVersion(version: number) {
    this.setNumber(PrefConst.CHINESE_CHARACTER, version)
  }

  getChineseCharacterVersion(): number {
    return this.getNumber(PrefConst.CHINESE_CHARACTER)
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