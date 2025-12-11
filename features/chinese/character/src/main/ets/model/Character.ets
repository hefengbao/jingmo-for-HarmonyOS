import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Character')

export class Character {
  id: number;
  character: string;
  character2: string | null;
  pinyin: string | null;
  radical: string | null;
  stroke: number | null;
  wubi: string | null;
  explanations: string[] | null;
  explanations2: ExplanationItem[] | null;

  constructor(
    id: number,
    character: string,
    character2: string | null,
    pinyin: string | null,
    radical: string | null,
    stroke: number | null,
    wubi: string | null,
    explanations: string[] | null,
    explanations2: ExplanationItem[] | null,
  ) {
    this.id = id;
    this.character = character;
    this.character2 = character2;
    this.pinyin = pinyin;
    this.radical = radical;
    this.stroke = stroke;
    this.wubi = wubi;
    this.explanations = explanations;
    this.explanations2 = explanations2;
  }
}

export class ExplanationItem {
  same: string | null = null;
  content: string | null = null;
  detail: Detail[] | null = null;
  words: Word[] | null = null;
  example: string | null = null;
  refer: string | null = null;
  modern: string | null = null;
  speech: string | null = null;
  pinyin: string | null = null;
  simplified: string | null = null;
  variant: string | null = null;
  typo: string | null = null;
}

export class Detail {
  text: string | null = null;
  book: string | null = null;
}

export class Word {
  word: string | null = null;
  text: string | null = null;
}

export async function insertCharacter(character: Character) {
  const valuesBucket: relationalStore.ValuesBucket = {
    'id': character.id,
    'character': character.character,
    'character2': character.character2,
    'pinyin': character.pinyin,
    'radical': character.radical,
    'stroke': character.stroke,
    'wubi': character.wubi,
    'explanations': JSON.stringify(character.explanations),
    'explanations2': JSON.stringify(character.explanations2),
  }

  await DbUtil.objectiveRDB?.insert(
    DbTableConst.CHINESE_CHARACTER_TABLE,
    valuesBucket,
    relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
  ).then((rowId: number) => {
    logger.info(`Insert is successful, rowId = ${rowId}`)
  }).catch((err: BusinessError) => {
    logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
  })
}

export async function getRandomCharacter(): Promise<Character | undefined> {
  let obj: Character | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_CHARACTER)
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

export async function getCharacter(id: number): Promise<Character | undefined> {
  let character: Character | undefined;
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_CHARACTER_TABLE);
  predicates.equalTo('id', id)

  await DbUtil.objectiveRDB?.query(predicates)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          character = parse(resultSet)
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      }
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return character;
}


export async function getBookmarks(): Promise<Character[]> {
  let objs: Character[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CHINESE_CHARACTER_BOOKMARKS)
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

export async function searchCharacterByChar(char: string): Promise<Character[]> {
  let list: Character[] = [];
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_CHARACTER_TABLE);
  predicates.equalTo('character', char)

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
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return list;
}

export async function searchCharacterByRadical(radical: string): Promise<Character[]> {
  let list: Character[] = [];
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_CHARACTER_TABLE);
  predicates.equalTo('radical', radical)

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
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return list;
}

export async function searchCharacterByTone(tone: string): Promise<Character[]> {
  let list: Character[] = [];
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_CHARACTER_TABLE);
  predicates.equalTo('pinyin', tone)

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
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return list;
}

export async function searchCharacterByStroke(stroke: number): Promise<Character[]> {
  let list: Character[] = [];
  let predicates = new relationalStore.RdbPredicates(DbTableConst.CHINESE_CHARACTER_TABLE);
  predicates.equalTo('stroke', stroke)

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
    }).catch((err: BusinessError) => {
      logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
    });

  return list;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): Character {
  return new Character(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('character')),
    resultSet.getString(resultSet.getColumnIndex('character2')),
    resultSet.getString(resultSet.getColumnIndex('pinyin')),
    resultSet.getString(resultSet.getColumnIndex('radical')),
    resultSet.getLong(resultSet.getColumnIndex('stroke')),
    resultSet.getString(resultSet.getColumnIndex('wubi')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('explanations'))),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('explanations2')))
  )
}