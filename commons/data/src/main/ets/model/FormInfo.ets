import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { relationalStore } from '@kit.ArkData';
import { DbTableConst } from 'constants';
import { Logger } from 'utils';

let logger: Logger = new Logger('FormInfo');

export class FormInfo{
  id: string;
  name: string;
  dimension: string;
  ability: string | null;

  constructor(id: string, name: string, dimension: string, ability: string | null) {
    this.id = id;
    this.name = name;
    this.dimension = dimension;
    this.ability = ability;
  }
}

export async function insertFormInfo(obj: FormInfo){
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'name': obj.name,
    'dimension': obj.dimension,
    'ability': obj.ability,
  }

  await DbUtil.objectiveRDB?.insert(
    DbTableConst.FORM_INFO_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function getFormInfo(id: string): Promise<FormInfo | undefined>{
  let obj: FormInfo | undefined = undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.FORM_INFO_TABLE)
  predicates.equalTo('id', id)

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          obj = new FormInfo(
            resultSet.getString(resultSet.getColumnIndex('id')),
            resultSet.getString(resultSet.getColumnIndex('name')),
            resultSet.getString(resultSet.getColumnIndex('dimension')),
            resultSet.getString(resultSet.getColumnIndex('ability')),
          )
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

export async function deleteFormInfo(id: string){
  let predicates = new relationalStore.RdbPredicates(DbTableConst.FORM_INFO_TABLE)
  predicates.equalTo('id', id)
  return await DbUtil.objectiveRDB?.delete(predicates)
    .catch((err: BusinessError) => {
      logger.error(`deleteFormInfo is failed, code is ${err.code},message is ${err.message}`)
    });
}