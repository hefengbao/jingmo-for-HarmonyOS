import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Quote');


export class Quote {
  id: number;
  content: string;
  author: string;
  from: string;

  constructor(
    id: number,
    content: string,
    author: string,
    from: string,
  ) {
    this.id = id;
    this.content = content;
    this.author = author;
    this.from = from;
  }
}

export async function createQuote(obj: Quote) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'content': obj.content,
    'author': obj.author,
    'from_txt': obj.from,
  }

  DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_QUOTE_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function readRandomQuote(): Promise<Quote | null> {
  let obj: Quote | null = null

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_QUOTE)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return obj;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): Quote {
  return new Quote(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('content')),
    resultSet.getString(resultSet.getColumnIndex('author')),
    resultSet.getString(resultSet.getColumnIndex('from_txt')),
  )
}