import { relationalStore } from '@kit.ArkData';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('ModernPoetry');

export class ModernPoetry {
  id: number;
  title: string;
  author: string;
  content: string;
  zhu: string | null;
  yi: string | null;
  shang: string | null;
  authorInfo: string | null;

  constructor(id: number, title: string, author: string, content: string, zhu: string | null, yi: string | null,
    shang: string | null, authorInfo: string | null) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.content = content;
    this.zhu = zhu;
    this.yi = yi;
    this.shang = shang;
    this.authorInfo = authorInfo;
  }
}

@Concurrent
export async function batchInsertModernPoetry(context: Context, objs: ModernPoetry[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('ModernPoetry#batchInsertModernPoetry');

  let valueBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: ModernPoetry) => {
    valueBuckets.push(
      {
        'id': obj.id,
        'title': obj.title,
        'author': obj.author,
        'content': obj.content,
        'zhu': obj.zhu,
        'yi': obj.yi,
        'shang': obj.shang,
        'author_info': obj.authorInfo,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_MODERNPOETRY_TABLE,
      valueBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertModernPoetry failed, code is ${err.code}, message is ${err.message}`);
  }
}

@Concurrent
export async function batchInsertModernPoetryFTS(context: Context, objs: ModernPoetry[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('ModernPoetry#batchInsertModernPoetryFTS');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: ModernPoetry) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'title': obj.title,
        'author': obj.author,
        'content': obj.content,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_MODERNPOETRY_FTS_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertModernPoetryFTS failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomPoetry(): Promise<ModernPoetry | undefined> {
  let obj: ModernPoetry | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_MODERNPOETRY)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet);
        }
        resultSet.close();
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomPoetry parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomPoetry failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function getPoetry(id: number): Promise<ModernPoetry | undefined> {
  let obj: ModernPoetry | undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_MODERNPOETRY_TABLE);
  predicates.equalTo('id', id);

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet);
        }
        resultSet.close();
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomPoetry parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomPoetry failed, code is ${err.code}, message is ${err.message}`);
    })

  return obj;
}

export async function search(query: string): Promise<ModernPoetry[]> {
  let objs: ModernPoetry[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_MODERNPOETRY, [`${query}`])
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet));
        }
        resultSet.close();
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomPoetry parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomPoetry failed, code is ${err.code}, message is ${err.message}`);
    })

  return objs;
}

export async function getBookmarks(): Promise<ModernPoetry[]> {
  let objs: ModernPoetry[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_MODERNPOETRY_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet));
        }
        resultSet.close();
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`getRandomPoetry parse failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getRandomPoetry failed, code is ${err.code}, message is ${err.message}`);
    })

  return objs;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): ModernPoetry {
  return new ModernPoetry(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('title')),
    resultSet.getString(resultSet.getColumnIndex('author')),
    resultSet.getString(resultSet.getColumnIndex('content')),
    resultSet.getString(resultSet.getColumnIndex('zhu')),
    resultSet.getString(resultSet.getColumnIndex('yi')),
    resultSet.getString(resultSet.getColumnIndex('shang')),
    resultSet.getString(resultSet.getColumnIndex('author_info')),
  )
}