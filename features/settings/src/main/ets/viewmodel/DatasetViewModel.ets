import { BusinessError } from '@kit.BasicServicesKit';
import Dataset from '../model/Dataset';
import { DataWrapper, httpRequestGet, Logger, ResponseResult } from 'utils';
import { NetworkConst } from 'constants';
import { ClassicPoem, createClassicPoem } from 'classicalliterature_classicpoem';
import { Character } from 'chinese_character';

class DatasetViewModel {
  private logger: Logger = new Logger('DatasetViewModel');

  getDatasetList(): Promise<Dataset[]> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.DATASET}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          resolve(JSON.parse(result.data as string) as Dataset[])
        } else {
          this.logger.error(result.msg)
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(error)
        reject(error)
      })
    })
  }

  getClassicPoemList(version: number, page: number): Promise<DataWrapper<ClassicPoem>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CLASSICALLITERATURE_CLASSICPOEM}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<ClassicPoem> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getClassicPoemList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertClassicPoemToDb(classicPoem: ClassicPoem) {
    await createClassicPoem(classicPoem).catch((error: BusinessError) => {
      this.logger.error(`insertClassicPoemToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseCharacterList(version: number, page: number): Promise<DataWrapper<Character>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_CHARACTER}_v${version}_${page}.json`;
      this.logger.info(`getChineseCharacterList url = ${url}`)
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Character> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseCharacterList failed, error = ${error}`)
        reject(error)
      })
    })
  }
}


let datasetViewModel = new DatasetViewModel()

export default datasetViewModel as DatasetViewModel