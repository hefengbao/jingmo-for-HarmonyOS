import { DbCRUDConst } from 'constants';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'utils';

let logger: Logger = new Logger('BookmarkEntity');

export class BookmarkEntity {
  id: number;
  bookmarkable_id: number;
  bookmarkable_model: string;
  chinese_antitheticalcouplet: string | null;
  chinese_character: string | null;
  chinese_expression: string | null;
  chinese_idiom: string | null;
  chinese_knowledge: string | null;
  chinese_quote: string | null;
  classicalliterature_classicpoem: string | null;
  classicalliterature_sentence: string | null;

  constructor(
    id: number,
    bookmarkable_id: number,
    bookmarkable_model: string,
    chinese_antitheticalcouplet: string | null,
    chinese_character: string | null,
    chinese_expression: string | null,
    chinese_idiom: string | null,
    chinese_knowledge: string | null,
    chinese_quote: string | null,
    classicalliterature_classicpoem: string | null,
    classicalliterature_sentence: string | null
  ) {
    this.id = id;
    this.bookmarkable_id = bookmarkable_id;
    this.bookmarkable_model = bookmarkable_model;
    this.chinese_antitheticalcouplet = chinese_antitheticalcouplet;
    this.chinese_character = chinese_character;
    this.chinese_expression = chinese_expression;
    this.chinese_idiom = chinese_idiom;
    this.chinese_knowledge = chinese_knowledge;
    this.chinese_quote = chinese_quote;
    this.classicalliterature_classicpoem = classicalliterature_classicpoem;
    this.classicalliterature_sentence = classicalliterature_sentence;
  }
}

export async function getEntities(): Promise<BookmarkEntity[]> {
  let objs: BookmarkEntity[] = [];

  logger.info(`sql = ${DbCRUDConst.BOOKMARKS}`)

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(new BookmarkEntity(
            resultSet.getLong(resultSet.getColumnIndex('id')),
            resultSet.getLong(resultSet.getColumnIndex('bookmarkable_id')),
            resultSet.getString(resultSet.getColumnIndex('bookmarkable_model')),
            resultSet.getString(resultSet.getColumnIndex('chinese_antitheticalcouplet')),
            resultSet.getString(resultSet.getColumnIndex('chinese_character')),
            resultSet.getString(resultSet.getColumnIndex('chinese_expression')),
            resultSet.getString(resultSet.getColumnIndex('chinese_idiom')),
            resultSet.getString(resultSet.getColumnIndex('chinese_knowledge')),
            resultSet.getString(resultSet.getColumnIndex('chinese_quote')),
            resultSet.getString(resultSet.getColumnIndex('classicalliterature_classicpoem')),
            resultSet.getString(resultSet.getColumnIndex('classicalliterature_sentence')),
          ))
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError;
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    })

  return objs;
}