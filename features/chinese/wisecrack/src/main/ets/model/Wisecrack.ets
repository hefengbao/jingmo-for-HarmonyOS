import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { relationalStore } from '@kit.ArkData';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Wisecrack');

export class Wisecrack {
  id: number;
  riddle: string;
  answer: string;
  firstWord: string | null;
  firstLetter: string | null;

  constructor(id: number, riddle: string, answer: string, firstWord: string | null, firstLetter: string | null) {
    this.id = id;
    this.riddle = riddle;
    this.answer = answer;
    this.firstWord = firstWord;
    this.firstLetter = firstLetter;
  }
}

@Concurrent
export async function batchInsertWisecrack(context: Context, objs: Wisecrack[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Wisecrack#batchInsertWisecrack');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Wisecrack) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'riddle': obj.riddle,
        'answer': obj.answer,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_WISECRACK_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertWisecrack failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomWisecrack(): Promise<Wisecrack | undefined> {
  let obj: Wisecrack | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_WISECRACK)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomWisecrack parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomWisecrack failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function getWisecrack(id: number): Promise<Wisecrack | undefined> {
  let obj: Wisecrack | undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_WISECRACK_TABLE)
  predicates.equalTo('id', id);

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getWisecrack parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getWisecrack failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function search(query: string): Promise<Wisecrack[]> {
  let objs: Wisecrack[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_WISECRACK, [`%${query}%`])
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

export async function getBookmarks(): Promise<Wisecrack[]> {
  let objs: Wisecrack[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_WISECRACK_BOOKMARKS)
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
function parse(resultSet: relationalStore.ResultSet): Wisecrack {
  return new Wisecrack(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('riddle')),
    resultSet.getString(resultSet.getColumnIndex('answer')),
    null,
    null
  )
}