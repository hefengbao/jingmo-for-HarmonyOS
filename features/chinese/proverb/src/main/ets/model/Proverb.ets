import { Logger } from 'utils';
import { relationalStore } from '@kit.ArkData';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

export class Proverb {
  id: number;
  content: string;

  constructor(id: number, content: string) {
    this.id = id;
    this.content = content;
  }
}

let logger: Logger = new Logger('Proverb');

@Concurrent
export async function batchInsertProverb(context: Context, objs: Proverb[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Proverb#batchInsertProverb');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Proverb) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'content': obj.content,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_PROVERB_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertProverb failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomProverb(): Promise<Proverb | undefined> {
  let obj: Proverb | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_PROVERB)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomProverb parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomProverb failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function getProverb(id: number): Promise<Proverb | undefined> {
  let obj: Proverb | undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_PROVERB_TABLE)
  predicates.equalTo('id', id);

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getProverb parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getProverb failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function search(query: string): Promise<Proverb[]> {
  let objs: Proverb[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_PROVERB, [`%${query}%`])
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`search parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`search failed, code is ${err.code}, message is ${err.message}`);
    })
  return objs;
}

export async function getBookmarks(): Promise<Proverb[]> {
  let objs: Proverb[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_PROVERB_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getBookmarks parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getBookmarks failed, code is ${err.code}, message is ${err.message}`);
    })
  return objs;
}

/**
 * @throws
 * @param resultSet
 * @returns
 */
function parse(resultSet: relationalStore.ResultSet): Proverb {
  return new Proverb(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('content'))
  )
}