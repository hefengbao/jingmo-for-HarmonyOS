import { DbCRUDConst } from 'constants';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'utils';
import { Clause } from 'data';

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
  chinese_lyric: string | null;
  chinese_poetry: string | null;
  chinese_proverb: string | null;
  chinese_quote: string | null;
  chinese_riddle: string | null;
  chinese_wisecrack: string | null;
  classicalliterature_classicpoem_title: string | null;
  classicalliterature_classicpoem_author: string | null;
  classicalliterature_sentence: string | null;
  classicalliterature_writing_title: Clause | null;
  classicalliterature_writing_author: string | null;

  constructor(id: number, bookmarkable_id: number, bookmarkable_model: string,
    chinese_antitheticalcouplet: string | null, chinese_character: string | null, chinese_expression: string | null,
    chinese_idiom: string | null, chinese_knowledge: string | null, chinese_lyric: string | null,
    chinese_poetry: string | null, chinese_proverb: string | null, chinese_quote: string | null,
    chinese_riddle: string | null, chinese_wisecrack: string | null,
    classicalliterature_classicpoem_title: string | null, classicalliterature_classicpoem_author: string | null,
    classicalliterature_sentence: string | null, classicalliterature_writing_title: Clause | null,
    classicalliterature_writing_author: string | null) {
    this.id = id;
    this.bookmarkable_id = bookmarkable_id;
    this.bookmarkable_model = bookmarkable_model;
    this.chinese_antitheticalcouplet = chinese_antitheticalcouplet;
    this.chinese_character = chinese_character;
    this.chinese_expression = chinese_expression;
    this.chinese_idiom = chinese_idiom;
    this.chinese_knowledge = chinese_knowledge;
    this.chinese_lyric = chinese_lyric;
    this.chinese_poetry = chinese_poetry;
    this.chinese_proverb = chinese_proverb;
    this.chinese_quote = chinese_quote;
    this.chinese_riddle = chinese_riddle;
    this.chinese_wisecrack = chinese_wisecrack;
    this.classicalliterature_classicpoem_title = classicalliterature_classicpoem_title;
    this.classicalliterature_classicpoem_author = classicalliterature_classicpoem_author;
    this.classicalliterature_sentence = classicalliterature_sentence;
    this.classicalliterature_writing_title = classicalliterature_writing_title;
    this.classicalliterature_writing_author = classicalliterature_writing_author;
  }
}

export async function getEntities(): Promise<BookmarkEntity[]> {
  let objs: BookmarkEntity[] = [];

  logger.info(`sql = ${DbCRUDConst.BOOKMARKS}`)

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(
            new BookmarkEntity(
              resultSet.getLong(resultSet.getColumnIndex('id')),
              resultSet.getLong(resultSet.getColumnIndex('bookmarkable_id')),
              resultSet.getString(resultSet.getColumnIndex('bookmarkable_model')),
              resultSet.getString(resultSet.getColumnIndex('chinese_antitheticalcouplet')),
              resultSet.getString(resultSet.getColumnIndex('chinese_character')),
              resultSet.getString(resultSet.getColumnIndex('chinese_expression')),
              resultSet.getString(resultSet.getColumnIndex('chinese_idiom')),
              resultSet.getString(resultSet.getColumnIndex('chinese_knowledge')),
              resultSet.getString(resultSet.getColumnIndex('chinese_lyric')),
              resultSet.getString(resultSet.getColumnIndex('chinese_poetry')),
              resultSet.getString(resultSet.getColumnIndex('chinese_proverb')),
              resultSet.getString(resultSet.getColumnIndex('chinese_quote')),
              resultSet.getString(resultSet.getColumnIndex('chinese_riddle')),
              resultSet.getString(resultSet.getColumnIndex('chinese_wisecrack')),
              resultSet.getString(resultSet.getColumnIndex('classicalliterature_classicpoem_title')),
              resultSet.getString(resultSet.getColumnIndex('classicalliterature_classicpoem_author')),
              resultSet.getString(resultSet.getColumnIndex('classicalliterature_sentence')),
              resultSet.getString(resultSet.getColumnIndex('classicalliterature_writing_title')) ?
                JSON.parse(resultSet.getString(resultSet.getColumnIndex('classicalliterature_writing_title'))) as Clause :
                null,
              resultSet.getString(resultSet.getColumnIndex('classicalliterature_writing_author'))
            )
          )
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError;
        logger.error(`Query parse is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    })

  return objs;
}