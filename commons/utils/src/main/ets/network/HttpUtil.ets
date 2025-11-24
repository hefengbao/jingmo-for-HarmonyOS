import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { NetworkConst } from 'constants';
import { Logger } from '../log/Logger';

let logger: Logger = new Logger('HttpUtils')

export async function httpRequestGet(url: string): Promise<ResponseResult> {
  let httpRequest = http.createHttp();

  //配置参考：https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-http#httprequestoptions
  const requestConfig: http.HttpRequestOptions = {
    method: http.RequestMethod.GET,
    readTimeout: NetworkConst.HTTP_READ_TIMEOUT,
    connectTimeout: NetworkConst.HTTP_READ_TIMEOUT,
    maxLimit: 100 * 1024 * 1024,
    header: {
      'Content-Type': 'application/json'
    },
    extraData: {}
  }

  let result = new ResponseResult()

  return httpRequest.request(url, requestConfig).then((response: http.HttpResponse) => {
    if (response.responseCode === NetworkConst.HTTP_CODE_200) {
      result.data = `${response.result}`
    } else {
      result.msg = `${$r('app.string.http_error_message')}&${response.responseCode}`;
      logger.info(result.msg)
    }
    httpRequest.destroy();
    return result;
  }).catch((error: BusinessError) => {
    result.msg = `${$r('app.string.http_error_message')}} => ${error.message}`;
    logger.info(result.msg)
    httpRequest.destroy();
    return result;
  })
}

export class ResponseResult {
  /**
   * 网络请求错误
   */
  msg: string | null;
  /**
   * api 返回的数据
   */
  data: string | null;

  constructor() {
    this.msg = null;
    this.data = null;
  }
}

export class DataWrapper<T> {
  total: number;
  data: T[];
  next_page: number | null;

  constructor() {
    this.total = 0;
    this.data = [];
    this.next_page = null
  }
}