import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbTableConst } from 'constants';
import { Logger } from 'utils';

import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('WorldCulturalHeritage');

export class WorldCulturalHeritage {
  id: number;
  name: string;
  type: string | null = null;
  year: string;
  year2: string | null = null;
  level: string;
  address: string;
  image: string;
  content: string;

  constructor(
    id: number,
    name: string,
    type: string | null,
    year: string,
    year2: string | null,
    level: string,
    address: string,
    image: string,
    content: string,
  ) {
    this.id = id;
    this.name = name;
    this.type = type;
    this.year = year;
    this.year2 = year2;
    this.level = level;
    this.address = address;
    this.image = image;
    this.content = content;
  }
}

export async function createWorldCulturalHeritage(obj: WorldCulturalHeritage) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'name': obj.name,
    'type': obj.type,
    'year': obj.year,
    'year2': obj.year2,
    'level': obj.level,
    'address': obj.address,
    'image': obj.image,
    'content': obj.content,
  }

  DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function readWorldCulturalHeritage(id: number): Promise<WorldCulturalHeritage | null> {
  let obj: WorldCulturalHeritage | null = null
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE);
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
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    })
  return obj;
}

export async function readWorldCulturalHeritageList(): Promise<WorldCulturalHeritage[]> {
  let list: WorldCulturalHeritage[] = []
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE);
  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          list.push(parse(resultSet))
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    })
  return list;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): WorldCulturalHeritage {
  return new WorldCulturalHeritage(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('name')),
    resultSet.getString(resultSet.getColumnIndex('type')),
    resultSet.getString(resultSet.getColumnIndex('year')),
    resultSet.getString(resultSet.getColumnIndex('year2')),
    resultSet.getString(resultSet.getColumnIndex('level')),
    resultSet.getString(resultSet.getColumnIndex('address')),
    resultSet.getString(resultSet.getColumnIndex('image')),
    resultSet.getString(resultSet.getColumnIndex('content')),
  )
}