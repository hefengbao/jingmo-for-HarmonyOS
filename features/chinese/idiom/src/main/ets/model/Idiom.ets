import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { JSON } from '@kit.ArkTS';

let logger: Logger = new Logger('Idiom');

export class Idiom {
  id: number;
  word: string;
  pinyin: string;
  abbr: string;
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
    abbr: string,
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
    this.abbr = abbr;
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

export class IdiomSource {
  text: string | null = null;
  book: string | null = null;
}

export class IdiomQuote {
  text: string | null = null;
  book: string | null = null;
}

export class IdiomExample {
  text: string | null = null;
  book: string | null = null;
}

export async function insertIdiom(obj: Idiom) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': obj.id,
    'word': obj.word,
    'pinyin': obj.pinyin,
    'abbr': obj.abbr,
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

  await DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_IDIOM_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function getRandomIdiom(): Promise<Idiom | undefined> {
  let obj: Idiom | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_IDIOM)
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

export async function getIdiom(id: number): Promise<Idiom | undefined> {
  let obj: Idiom | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_IDIOM_TABLE);
  predicates.equalTo('id', id);

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

export async function getBookmarks(): Promise<Idiom[]> {
  let objs: Idiom[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_IDIOM_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet));
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

export async function search(query: string): Promise<Idiom[]> {
  let objs: Idiom[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CHINESE_IDIOM, [`%${query}%`])
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet));
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
function parse(resultSet: relationalStore.ResultSet): Idiom {
  return new Idiom(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('word')),
    resultSet.getString(resultSet.getColumnIndex('pinyin')),
    resultSet.getString(resultSet.getColumnIndex('abbr')),
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