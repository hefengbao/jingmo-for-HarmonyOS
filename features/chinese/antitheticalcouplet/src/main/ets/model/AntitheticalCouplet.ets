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

export async function insertAntitheticalCouplet(obj: AntitheticalCouplet) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'body': obj.body,
    'description': obj.description,
    'image': obj.image,
  }

  await DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function getRandomAntitheticalCouplet(): Promise<AntitheticalCouplet | undefined> {
  let obj: AntitheticalCouplet | undefined

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

export async function getAntitheticalCouplet(id: number): Promise<AntitheticalCouplet | undefined> {
  let obj: AntitheticalCouplet | undefined

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE)
  predicates.equalTo('id', id)

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

export async function search(query: string): Promise<AntitheticalCouplet[]> {
  let objs: AntitheticalCouplet[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_ANTITHETICALCOUPLET, [`%${query}%`])
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

export async function getBookmarks(): Promise<AntitheticalCouplet[]> {
  let objs: AntitheticalCouplet[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_ANTITHETICALCOUPLETI_BOOKMARKS)
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
function parse(resultSet: relationalStore.ResultSet): AntitheticalCouplet {
  return new AntitheticalCouplet(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('body')),
    resultSet.getString(resultSet.getColumnIndex('description')),
    resultSet.getString(resultSet.getColumnIndex('image')),
  )
}