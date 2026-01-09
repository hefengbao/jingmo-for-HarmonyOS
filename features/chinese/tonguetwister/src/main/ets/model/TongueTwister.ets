import { relationalStore } from '@kit.ArkData';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('TongueTwister');

export class TongueTwister {
  id: number;
  title: string;
  content: string;
  content2: string | null;

  constructor(id: number, title: string, content: string, content2: string | null) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.content2 = content2;
  }
}

@Concurrent
export async function batchInsertTongueTwister(context: Context, objs: TongueTwister[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('TongueTwister#batchInsertTongueTwister');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: TongueTwister) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'title': obj.title,
        'content': obj.content,
        'content2': obj.content2,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_TONGUETWISTER_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertTongueTwister failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getList(): Promise<TongueTwister[]> {
  let objs: TongueTwister[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_TONGUETWISTER_LIST)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
        resultSet.close()
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`parse tonguetwister failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`get tonguetwister list failed, code is ${err.code}, message is ${err.message}`);
    })

  return objs;
}

export async function getTongueTwister(id: number): Promise<TongueTwister | undefined> {
  let obj: TongueTwister | undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_TONGUETWISTER_TABLE)
  predicates.equalTo('id', id);
  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet);
        }
        resultSet.close()
      } catch (error) {
        const err = error as BusinessError;
        logger.error(`parse tonguetwister failed, code is ${err.code}, message is ${err.message}`);
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`get tonguetwister failed, code is ${err.code}, message is ${err.message}`);
    })
  return obj;
}

/**
 * @throws
 * @param resultSet
 * @returns
 */
function parse(resultSet: relationalStore.ResultSet): TongueTwister {
  return new TongueTwister(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('title')),
    resultSet.getString(resultSet.getColumnIndex('content')),
    resultSet.getString(resultSet.getColumnIndex('content2')),
  )
}