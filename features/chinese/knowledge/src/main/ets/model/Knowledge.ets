import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Knowledge');


export class Knowledge {
  id: number;
  content: string;
  label: string;
  url: string | null;

  constructor(
    id: number,
    content: string,
    label: string,
    url: string | null
  ) {
    this.id = id;
    this.content = content;
    this.label = label;
    this.url = url;
  }
}

export async function insertKnowledge(obj: Knowledge) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'content': obj.content,
    'label': obj.label,
    'url': obj.url,
  }

  DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_KNOWLEDGE_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

@Concurrent
export async function batchInsertKnowledge(context: Context, objs: Knowledge[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Knowledge#batchInsertKnowledge');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Knowledge) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'content': obj.content,
        'label': obj.label,
        'url': obj.url,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_KNOWLEDGE_TABLE,
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

export async function getRandomKnowledge(): Promise<Knowledge | undefined> {
  let obj: Knowledge | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_KNOWLEDGE)
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

export async function getKnowledge(id: number): Promise<Knowledge | undefined> {
  let obj: Knowledge | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_KNOWLEDGE_TABLE);
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

export async function getBookmarks(): Promise<Knowledge[]> {
  let objs: Knowledge[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_KNOWLEDGE_BOOKMARKS)
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

export async function search(query: string): Promise<Knowledge[]> {
  let objs: Knowledge[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_KNOWLEDGE, [`%${query}%`])
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
function parse(resultSet: relationalStore.ResultSet): Knowledge {
  return new Knowledge(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('content')),
    resultSet.getString(resultSet.getColumnIndex('label')),
    resultSet.getString(resultSet.getColumnIndex('url')),
  )
}