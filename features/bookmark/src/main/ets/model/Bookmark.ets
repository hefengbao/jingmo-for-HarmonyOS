import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbTableConst } from 'constants';
import { Logger } from 'utils';

import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('BookmarkModel')

export class Bookmark {
  id: number;
  bookmarkable_id: number;
  bookmarkable_model: string;

  constructor(id: number, bookmarkable_id: number, bookmarkable_model: string) {
    this.id = id;
    this.bookmarkable_id = bookmarkable_id;
    this.bookmarkable_model = bookmarkable_model;
  }
}

export async function addBookmark(obj: Bookmark) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'bookmarkable_id': obj.bookmarkable_id,
    'bookmarkable_model': obj.bookmarkable_model,
  }

  await DbUtil.objectiveRDB?.insert(
    DbTableConst.BOOKMARKS_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function cancelBookmark(bookmarkable_id: number, bookmarkable_model: string): Promise<number | undefined> {
  let predicates = new relationalStore.RdbPredicates(DbTableConst.BOOKMARKS_TABLE);
  predicates.equalTo('bookmarkable_id', bookmarkable_id);
  predicates.equalTo('bookmarkable_model', bookmarkable_model);

  let id: number | undefined

  await DbUtil.objectiveRDB?.delete(predicates)
    .then((rowId: number) => {
      id = rowId
      logger.info(`Delete is successful, rowId = ${rowId}`)
    })
    .catch((err: BusinessError) => {
      logger.error(`Delete is failed, code is ${err.code},message is ${err.message}`)
    })

  return id;
}

export async function getBookmark(bookmarkable_id: number, bookmarkable_model: string): Promise<Bookmark | undefined> {
  let predicates = new relationalStore.RdbPredicates(DbTableConst.BOOKMARKS_TABLE);
  predicates.equalTo('bookmarkable_id', bookmarkable_id);
  predicates.equalTo('bookmarkable_model', bookmarkable_model);

  let bookmark: Bookmark | undefined

  await DbUtil.objectiveRDB?.query(predicates).then((resultSet: relationalStore.ResultSet) => {
    try {
      while (resultSet.goToNextRow()) {
        bookmark = parse(resultSet)
      }
      resultSet.close()
    } catch (error) {
      let err = error as BusinessError
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    }
  }).catch((err: BusinessError) => {
    logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
  });

  return bookmark;
}


export async function getBookmarks(): Promise<Bookmark[]> {
  let predicates = new relationalStore.RdbPredicates(DbTableConst.BOOKMARKS_TABLE);

  let objs: Bookmark[] = [];

  await DbUtil.objectiveRDB?.query(predicates).then((resultSet: relationalStore.ResultSet) => {
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
function parse(resultSet: relationalStore.ResultSet): Bookmark {
  return new Bookmark(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getLong(resultSet.getColumnIndex('bookmarkable_id')),
    resultSet.getString(resultSet.getColumnIndex('bookmarkable_model')),
  )
}