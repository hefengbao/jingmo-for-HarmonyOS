import { BusinessError } from '@kit.BasicServicesKit'
import Dataset from '../model/Dataset';
import { httpRequestGet, ResponseResult, Logger } from 'utils';
import { NetworkConst } from 'constants';
import { ClassicPoem, ClassicPoemDao } from 'classicalliterature_classicpoem'

class DatasetViewModel {
  logger: Logger = new Logger('DatasetViewModel');
  classicPoemDao: ClassicPoemDao = new ClassicPoemDao();

  getDatasetList(): Promise<Dataset[]> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.DATASET}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          resolve(result.data)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        reject(error)
      })
    })
  }

  getClassicPoemList(): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      let page: number | null = 1;
      //TODO V3_1.json
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CLASSICALLITERATURE_CLASSICPOEM}${page}.json`;
      this.logger.info(`getClassicPoemList url :${url}`)
      httpRequestGet(url).then((result: ResponseResult) => {
        this.logger.info(`getClassicPoemList result msg :${result.msg}`)
        if (result.msg === null) {
          this.logger.info(`getClassicPoemList result data :${result.data}`)
          this.logger.info(`getClassicPoemList result data type :${typeof result.data}`)
          resolve(result.data)
        } else {
          this.logger.info(`getClassicPoemList result error :${result.msg}`)
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.info(`getClassicPoemList catch error :${error}`)
        reject(error)
      })
    })
  }

  async insertClassicPoemToDb(classicPoem: ClassicPoem){
    await this.classicPoemDao.createClassicPoem(classicPoem).catch((error: BusinessError) => {
      this.logger.error(`insertClassicPoemToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }
}

let datasetViewModel = new DatasetViewModel()

export default datasetViewModel as DatasetViewModel