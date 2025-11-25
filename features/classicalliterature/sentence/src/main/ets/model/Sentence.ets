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

export async function createSentence(obj: Sentence) {
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

export async function readRandomSentence(): Promise<Sentence | null> {
  let obj: Sentence | null = null

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