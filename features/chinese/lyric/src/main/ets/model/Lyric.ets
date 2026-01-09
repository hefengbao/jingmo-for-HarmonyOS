import { Logger } from "utils";
import { relationalStore } from "@kit.ArkData";
import { DbConfigConst, DbCRUDConst, DbTableConst } from "constants";
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Lyric');

export class Lyric {
  id: number;
  title: string;
  writer: string;
  singer: string | null;
  content: string;

  constructor(id: number, title: string, writer: string, singer: string | null, content: string) {
    this.id = id;
    this.title = title;
    this.writer = writer;
    this.singer = singer;
    this.content = content;
  }
}

@Concurrent
export async function batchInsertLyric(context: Context, objs: Lyric[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Lyric#batchInsertLyric');

  let valueBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Lyric) => {
    valueBuckets.push(
      {
        'id': obj.id,
        'title': obj.title,
        'writer': obj.writer,
        'singer': obj.singer,
        'content': obj.content,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_LYRIC_TABLE,
      valueBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertLyric failed, code is ${err.code}, message is ${err.message}`);
  }
}

@Concurrent
export async function batchInsertLyricFTS(context: Context, objs: Lyric[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Lyric#batchInsertLyricFTS');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Lyric) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'title': obj.title,
        'content': obj.content,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_LYRIC_FTS_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertLyricFTS failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomLyric(): Promise<Lyric | undefined>{
  let obj: Lyric | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_LYRIC)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomLyric parse failed, code is ${err.code}, message is ${err.message}`);
      }
    }).catch((err: BusinessError) => {
      logger.error(`getRandomLyric failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function getLyric(id: number): Promise<Lyric | undefined>{
  let obj: Lyric | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_LYRIC_TABLE);
  predicates.equalTo('id', id);

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getLyric parse failed, code is ${err.code}, message is ${err.message}`);
      }
    }).catch((err: BusinessError) => {
      logger.error(`getLyric failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function  search(query: string): Promise<Lyric[]> {
  let objs: Lyric[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_LYRIC, [`${query}`])
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`searchLyric parse failed, code is ${err.code}, message is ${err.message}`);
      }
    }).catch((err: BusinessError) => {
      logger.error(`searchLyric failed, code is ${err.code}, message is ${err.message}`);
    })

  return objs;
}

export async function  getBookmarks(): Promise<Lyric[]> {
  let objs: Lyric[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_LYRIC_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getBookmarks parse failed, code is ${err.code}, message is ${err.message}`);
      }
    }).catch((err: BusinessError) => {
      logger.error(`getBookmarks failed, code is ${err.code}, message is ${err.message}`);
    })

  return objs;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): Lyric{
  return new Lyric(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('title')),
    resultSet.getString(resultSet.getColumnIndex('writer')),
    resultSet.getString(resultSet.getColumnIndex('singer')),
    resultSet.getString(resultSet.getColumnIndex('content')),
  )
}