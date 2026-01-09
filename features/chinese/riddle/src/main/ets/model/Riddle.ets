import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import relationalStore from '@ohos.data.relationalStore';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Riddle');

export class Riddle {
  id: number;
  puzzle: string;
  answer: string;

  constructor(id: number, puzzle: string, answer: string) {
    this.id = id;
    this.puzzle = puzzle;
    this.answer = answer;
  }
}

@Concurrent
export async function batchInsertRiddle(context: Context, objs: Riddle[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Riddle#batchInsertRiddle');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Riddle) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'puzzle': obj.puzzle,
        'answer': obj.answer,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_RIDDLE_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertRiddle failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomRiddle(): Promise<Riddle | undefined> {
  let obj: Riddle | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_RIDDLE)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomRiddle parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomRiddle failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function getRiddle(id: number): Promise<Riddle | undefined> {
  let obj: Riddle | undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_RIDDLE_TABLE)
  predicates.equalTo('id', id);

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRiddle parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRiddle failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function search(query: string): Promise<Riddle[]> {
  let objs: Riddle[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_RIDDLE, [`%${query}%`])
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

export async function getBookmarks(): Promise<Riddle[]> {
  let objs: Riddle[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_RIDDLE_BOOKMARKS)
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
function parse(resultSet: relationalStore.ResultSet): Riddle {
  return new Riddle(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('puzzle')),
    resultSet.getString(resultSet.getColumnIndex('answer')),
  )
}