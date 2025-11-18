import { http } from '@kit.NetworkKit';
import { NetworkConst } from 'constants'

/**
 * Initiates an HTTP request to a given URL.
 *
 * @param url URL for initiating an HTTP request.
 * @param params Params for initiating an HTTP request.
 */
export async function httpRequestGet(url: string): Promise<ResponseResult> {
  let httpRequest = http.createHttp();
  let result = new ResponseResult()
  // Processes the data and returns.
  return httpRequest.request(url, {
    method: http.RequestMethod.GET,
    readTimeout: NetworkConst.HTTP_READ_TIMEOUT,
    header: {
      'Content-Type': 'application/json'
    },
    connectTimeout: NetworkConst.HTTP_READ_TIMEOUT,
    extraData: {}
  }).then((value: http.HttpResponse) => {
    if (value.responseCode === NetworkConst.HTTP_CODE_200) {
      result.data = `${value.result}`
    } else {
      result.msg = `${$r('app.string.http_error_message')}&${value.responseCode}`;
    }
    return result;
  }).catch(() => {
    result.msg = `${$r('app.string.http_error_message')}}`;
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