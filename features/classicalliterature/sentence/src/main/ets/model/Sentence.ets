import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Sentence');

export class Sentence {
  id: number;
  content: string;
  from: string;
  poem_id: number | null;

  constructor(
    id: number,
    content: string,
    from: string,
    poem_id: number | null
  ) {
    this.id = id;
    this.content = content;
    this.from = from;
    this.poem_id = poem_id;
  }
}

export async function insertSentence(obj: Sentence) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'content': obj.content,
    'from_txt': obj.from,
    'poem_id': obj.poem_id,
  }

  DbUtil.objectiveRDB?.insert(
    DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function getRandomSentence(): Promise<Sentence | undefined> {
  let obj: Sentence | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CLASSICALLITERATURE_SENTENCE)
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

export async function getSentence(id: number): Promise<Sentence | undefined> {
  let obj: Sentence | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE)
  predicates.equalTo('id', id)

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = parse(resultSet)
        }
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    })

  return obj;
}

export async function getBookmarks(): Promise<Sentence[]> {
  let objs: Sentence[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CLASSICALLITERATURE_SENTENCE_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    })

  return objs;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): Sentence {
  return new Sentence(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('content')),
    resultSet.getString(resultSet.getColumnIndex('from_txt')),
    resultSet.getLong(resultSet.getColumnIndex('poem_id')),
  )
}