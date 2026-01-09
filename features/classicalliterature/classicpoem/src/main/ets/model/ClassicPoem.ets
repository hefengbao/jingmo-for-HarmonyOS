import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('ClassicPoem');

export class ClassicPoem {
  id: number;
  dynasty: string; // 朝代
  writer: string; // 作者
  writer_introduction: string | null; // 作者简介
  title: string; // 标题
  subtitle: string | null; // 副标题
  preface: string | null; // 序言
  content: string; // 内容
  annotation: string | null; // 注释
  translation: string | null; // 译文
  creative_background: string | null; // 创作背景
  explain: string | null; // 赏析
  comment: string | null; // 点评
  collection: string; // 合集
  category: string | null; // 分类

  constructor(
    id: number,
    dynasty: string,
    writer: string,
    writer_introduction: string,
    title: string,
    subtitle: string | null,
    preface: string | null,
    content: string,
    annotation: string | null,
    translation: string | null,
    creative_background: string | null,
    explain: string | null,
    comment: string | null,
    collection: string,
    category: string | null
  ) {
    this.id = id;
    this.dynasty = dynasty;
    this.writer = writer;
    this.writer_introduction = writer_introduction;
    this.title = title;
    this.subtitle = subtitle;
    this.preface = preface;
    this.content = content;
    this.annotation = annotation;
    this.translation = translation;
    this.creative_background = creative_background;
    this.explain = explain;
    this.comment = comment;
    this.collection = collection;
    this.category = category
  }
}

export async function insertClassicPoem(obj: ClassicPoem) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'dynasty': obj.dynasty,
    'writer': obj.writer,
    'writer_introduction': obj.writer_introduction,
    'title': obj.title,
    'subtitle': obj.subtitle,
    'preface': obj.preface,
    'content': obj.content,
    'annotation': obj.annotation,
    'translation': obj.translation,
    'creative_background': obj.creative_background,
    'explain': obj.explain,
    'comment': obj.comment,
    'collection': obj.collection,
    'category': obj.category,
  }

  DbUtil.objectiveRDB?.insert(
    DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

@Concurrent
export async function batchInsertClassicPoem(context: Context, objs: ClassicPoem[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('ClassicPoem#batchInsertClassicPoem');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: ClassicPoem) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'dynasty': obj.dynasty,
        'writer': obj.writer,
        'writer_introduction': obj.writer_introduction,
        'title': obj.title,
        'subtitle': obj.subtitle,
        'preface': obj.preface,
        'content': obj.content,
        'annotation': obj.annotation,
        'translation': obj.translation,
        'creative_background': obj.creative_background,
        'explain': obj.explain,
        'comment': obj.comment,
        'collection': obj.collection,
        'category': obj.category,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertClassicPoem failed, code is ${err.code}, message is ${err.message}`);
  }
}

@Concurrent
export async function batchInsertClassicPoemFTS(context: Context, objs: ClassicPoem[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('ClassicPoem#batchInsertClassicPoemFTS');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: ClassicPoem) => {
    valuesBuckets.push(
      {
        'id': obj.id,
        'writer': obj.writer,
        'title': obj.title,
        'content': obj.content,
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertClassicPoemFTS failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomClassicPoem(): Promise<ClassicPoem | undefined> {
  let obj: ClassicPoem | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CLASSICALLITERATURE_CLASSICPOEM)
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

export async function getClassicPoem(id: number): Promise<ClassicPoem | undefined> {
  let obj: ClassicPoem | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE)
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

export async function getBookmarks(): Promise<ClassicPoem[]> {
  let objs: ClassicPoem[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CLASSICALLITERATURE_CLASSICPOEM_BOOKMARKS)
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
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });
  return objs;
}

export async function search(query: string): Promise<ClassicPoem[]> {
  let objs: ClassicPoem[] = [];

  logger.info(`查询：${query}`)
  /*//, [`'${query}'`]
    await DbUtil.objectiveRDB?.querySql("select * from classicalliterature_classicpoem tbl join  classicalliterature_classicpoem_fts v on tbl.id = v.id where classicalliterature_classicpoem_fts match ?", [query])
      .then((resultSet: relationalStore.ResultSet) => {
        try {
          while (resultSet.goToNextRow()) {
            logger.info(`id：${resultSet.getString(resultSet.getColumnIndex('id'))}`)
            logger.info(`title：${resultSet.getString(resultSet.getColumnIndex('title'))}`)
            logger.info(`content：${resultSet.getString(resultSet.getColumnIndex('content'))}`)
            //objs.push(parse(resultSet))
          }
          logger.info('这里还好！！！')
          resultSet.close()
        } catch (error) {
          let err = error as BusinessError
          logger.error(`！！Query is failed, code is ${err.code},message is ${err.message}`)
        }
      }).catch(() => {
        // TODO: Implement error handling.
      })*/

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CLASSICALLITERATURE_CLASSICPOEM, [query])
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          logger.info(resultSet.getString(resultSet.getColumnIndex('title')))
          objs.push(parse(resultSet))
        }
        logger.info('有点搞！！！')
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });
  logger.info(`结果：${objs.length}`)
  return objs;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): ClassicPoem {
  return new ClassicPoem(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('dynasty')),
    resultSet.getString(resultSet.getColumnIndex('writer')),
    resultSet.getString(resultSet.getColumnIndex('writer_introduction')),
    resultSet.getString(resultSet.getColumnIndex('title')),
    resultSet.getString(resultSet.getColumnIndex('subtitle')),
    resultSet.getString(resultSet.getColumnIndex('preface')),
    resultSet.getString(resultSet.getColumnIndex('content')),
    resultSet.getString(resultSet.getColumnIndex('annotation')),
    resultSet.getString(resultSet.getColumnIndex('translation')),
    resultSet.getString(resultSet.getColumnIndex('creative_background')),
    resultSet.getString(resultSet.getColumnIndex('explain')),
    resultSet.getString(resultSet.getColumnIndex('comment')),
    resultSet.getString(resultSet.getColumnIndex('collection')),
    resultSet.getString(resultSet.getColumnIndex('category')),
  )
}