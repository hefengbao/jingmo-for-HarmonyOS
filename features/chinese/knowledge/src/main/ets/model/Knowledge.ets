import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbCRUDConst, DbTableConst } from 'constants';
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

export async function createKnowledge(obj: Knowledge) {
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

export async function readRandomKnowledge(): Promise<Knowledge | null> {
  let obj: Knowledge | null = null

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