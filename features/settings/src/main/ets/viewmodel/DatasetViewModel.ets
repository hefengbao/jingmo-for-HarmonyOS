import DatasetModel from '../model/DatasetModel'
import { httpRequestGet, ResponseResult, Logger } from 'utils'
import { NetworkConst } from 'constants'

class DatasetViewModel {
  getDatasetList(): Promise<DatasetModel[]> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.DATASET}.json`;
      httpRequestGet(url).then((data: ResponseResult) => {
        if (data.msg === null) {
          resolve(data.data)
        } else {
          reject([])
        }
      })
    })
  }
}

let datasetViewModel = new DatasetViewModel()

export default datasetViewModel as DatasetViewModel