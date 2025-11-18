import DatasetModel from '../model/DatasetModel'
import { httpRequestGet, ResponseResult } from 'utils'
import { NetworkConst } from 'constants'

class DatasetViewModel {
  getDatasetList(): Promise<DatasetModel[]> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.DATASET}.json`;
      httpRequestGet(url).then((data: ResponseResult) => {
        if (data.msg === null) {
          resolve(data.data)
        } else {
          reject(data.msg)
        }
      }).catch((error: string) => {
        reject(error)
      })
    })
  }
}

let datasetViewModel = new DatasetViewModel()

export default datasetViewModel as DatasetViewModel