import { IdiomExample, IdiomQuote, IdiomSource } from 'chinese_idiom';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { JSON } from '@kit.ArkTS';

let logger: Logger = new Logger('Expression');

export class Expression {
  id: number;
  word: string;
  pinyin: string;
  explanation: string | null;
  source: IdiomSource | null;
  quote: IdiomQuote | null;
  example: IdiomExample | null;
  similar: string[] | null;
  opposite: string[] | null;
  usage: string | null;
  story: string[] | null;
  notice: string | null;

  constructor(
    id: number,
    word: string,
    pinyin: string,
    explanation: string | null,
    source: IdiomSource | null,
    quote: IdiomQuote | null,
    example: IdiomExample | null,
    similar: string[] | null,
    opposite: string[] | null,
    usage: string | null,
    story: string[] | null,
    notice: string | null
  ) {
    this.id = id;
    this.word = word;
    this.pinyin = pinyin;
    this.explanation = explanation;
    this.source = source;
    this.quote = quote;
    this.example = example;
    this.similar = similar;
    this.opposite = opposite;
    this.usage = usage;
    this.story = story;
    this.notice = notice;
  }
}

export async function insertExpression(obj: Expression): Promise<number | undefined> {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'word': obj.word,
    'pinyin': obj.pinyin,
    'explanation': obj.explanation,
    'source': JSON.stringify(obj.source),
    'quote': JSON.stringify(obj.quote),
    'example': JSON.stringify(obj.example),
    'similar': JSON.stringify(obj.similar),
    'opposite': JSON.stringify(obj.opposite),
    'usage': obj.usage,
    'story': JSON.stringify(obj.story),
    'notice': obj.notice,
  }

  return await DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_EXPRESSION_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
    return rowId;
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
    return 0;
  })
}

@Concurrent
export async function batchInsertExpression(context: Context, objs: Expression[]): Promise<void> {
  let logger: Logger = new Logger('Expression#batchInsertInsertExpression');
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);

  let valuesBuckets: relationalStore.ValuesBucket[] = [];

  for (let obj of objs) {
    valuesBuckets.push({
      'id': obj.id,
      'word': obj.word,
      'pinyin': obj.pinyin,
      'explanation': obj.explanation,
      'source': JSON.stringify(obj.source),
      'quote': JSON.stringify(obj.quote),
      'example': JSON.stringify(obj.example),
      'similar': JSON.stringify(obj.similar),
      'opposite': JSON.stringify(obj.opposite),
      'usage': obj.usage,
      'story': JSON.stringify(obj.story),
      'notice': obj.notice,
    })
  }

  // 数据插入
  try {
    store.batchInsertWithConflictResolution(
      DbTableConst.CHINESE_EXPRESSION_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((rowId: number) => {
      logger.info(`insert id = ${rowId}`)
    }).catch((err: BusinessError) => {
      logger.error(`insert failed error code = ${err.code} message = ${err.message}`)
    })
  } catch (error) {
    let err = error as BusinessError
    logger.error(`insert failed error code = ${err.code} message = ${err.message}`)
  }
}

export async function getRandomExpression(): Promise<Expression | undefined> {
  let obj: Expression | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_EXPRESSION)
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

export async function getExpression(id: number): Promise<Expression | undefined> {
  let obj: Expression | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_EXPRESSION_TABLE)
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


export async function getBookmarks(): Promise<Expression[]> {
  let objs: Expression[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_EXPRESSION_BOOKMARKS)
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

export async function search(query: string): Promise<Expression[]> {
  let objs: Expression[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_EXPRESSION, [`%${query}%`])
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
function parse(resultSet: relationalStore.ResultSet): Expression {
  return new Expression(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('word')),
    resultSet.getString(resultSet.getColumnIndex('pinyin')),
    resultSet.getString(resultSet.getColumnIndex('explanation')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('source'))) as IdiomSource,
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('quote'))) as IdiomQuote,
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('example'))) as IdiomExample,
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('similar'))) as string[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('opposite'))) as string[],
    resultSet.getString(resultSet.getColumnIndex('usage')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('story'))) as string[],
    resultSet.getString(resultSet.getColumnIndex('notice')),
  )
}