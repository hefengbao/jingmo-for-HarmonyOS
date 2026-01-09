import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
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

export async function insertQuote(obj: Quote) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'content': obj.content,
    'author': obj.author,
    'from_txt': obj.from,
  }

  await DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_QUOTE_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

@Concurrent
export async function batchInsertQuote(context: Context, objs: Quote[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Quote#batchInsertKnowledge');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Quote) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'content': obj.content,
        'author': obj.author,
        'from_txt': obj.from,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_QUOTE_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertKnowledge failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomQuote(): Promise<Quote | undefined> {
  let obj: Quote | undefined;

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

export async function getQuote(id: number): Promise<Quote | undefined> {
  let obj: Quote | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_QUOTE_TABLE)
  predicates.equalTo('id', id);

  await DbUtil.objectiveRDB?.query(predicates)
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

export async function getBookmarks(): Promise<Quote[]> {
  let objs: Quote[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_QUOTE_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return objs;
}

export async function search(query: string): Promise<Quote[]> {
  let objs: Quote[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_QUOTE, [`%${query}%`])
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return objs;
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