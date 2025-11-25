import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('AntitheticalCouplet');

export class AntitheticalCouplet {
  id: number;
  body: string;
  description: string | null;
  image: string | null;

  constructor(
    id: number,
    body: string,
    description: string | null,
    image: string | null
  ) {
    this.id = id;
    this.body = body;
    this.description = description;
    this.image = image;
  }
}

export async function createAntitheticalCouplet(obj: AntitheticalCouplet) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'body': obj.body,
    'description': obj.description,
    'image': obj.image,
  }

  DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function readRandomAntitheticalCouplet(): Promise<AntitheticalCouplet | null> {
  let obj: AntitheticalCouplet | null = null

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_ANTITHETICALCOUPLET)
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
function parse(resultSet: relationalStore.ResultSet): AntitheticalCouplet {
  return new AntitheticalCouplet(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('body')),
    resultSet.getString(resultSet.getColumnIndex('description')),
    resultSet.getString(resultSet.getColumnIndex('image')),
  )
}