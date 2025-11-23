import { BusinessError } from '@kit.BasicServicesKit';
import Dataset from '../model/Dataset';
import { httpRequestGet, Logger, ResponseResult } from 'utils';
import { NetworkConst } from 'constants';
import { ClassicPoem, ClassicPoemDao } from 'classicalliterature_classicpoem';

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

  getClassicPoemList(version: number, pageNum: number): Promise<string> {
    return new Promise((resolve: Function, reject: Function) => {
      let page: number | null = pageNum;
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CLASSICALLITERATURE_CLASSICPOEM}_${version}_${page}.json`;
      this.logger.info(`getClassicPoemList url :${url}`)
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

  async insertClassicPoemToDb(classicPoem: ClassicPoem) {
    await this.classicPoemDao.createClassicPoem(classicPoem).catch((error: BusinessError) => {
      this.logger.error(`insertClassicPoemToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }
}

let datasetViewModel = new DatasetViewModel()

export default datasetViewModel as DatasetViewModel