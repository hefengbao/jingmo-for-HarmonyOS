import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { relationalStore } from '@kit.ArkData';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';

let logger: Logger = new Logger('Writing');

export class Writing {
  Id: number;
  GroupIndex: number | null;
  Classes: string[] | null;
  Froms: string[] | null;
  Allusions: Allusion[] | null;
  Pictures: string[] | null;
  Dynasty: string;
  Author: string;
  AuthorId: number | null;
  AuthorDate: string | null;
  AuthorYears: string | null;
  AuthorPlace: string | null;
  Type: string;
  TypeDetail: string | null;
  Rhyme: string | null;
  FirstClauseRhyme: string | null;
  Title: Clause;
  SubTitle: Clause | null;
  TuneId: Tune | null;
  Preface: string | null;
  Clauses: Clause[];
  Note: string | null;
  Comments: Quote[] | null;

  constructor(Id: number, GroupIndex: number | null, Classes: string[] | null, Froms: string[] | null,
    Allusions: Allusion[] | null, Pictures: string[] | null, Dynasty: string, Author: string, AuthorId: number | null,
    AuthorDate: string | null, AuthorYears: string | null, AuthorPlace: string | null, Type: string,
    TypeDetail: string | null, Rhyme: string | null, FirstClauseRhyme: string | null, Title: Clause,
    SubTitle: Clause | null, TuneId: Tune | null, Preface: string | null, Clauses: Clause[], Note: string | null,
    Comments: Quote[] | null) {
    this.Id = Id;
    this.GroupIndex = GroupIndex;
    this.Classes = Classes;
    this.Froms = Froms;
    this.Allusions = Allusions;
    this.Pictures = Pictures;
    this.Dynasty = Dynasty;
    this.Author = Author;
    this.AuthorId = AuthorId;
    this.AuthorDate = AuthorDate;
    this.AuthorYears = AuthorYears;
    this.AuthorPlace = AuthorPlace;
    this.Type = Type;
    this.TypeDetail = TypeDetail;
    this.Rhyme = Rhyme;
    this.FirstClauseRhyme = FirstClauseRhyme;
    this.Title = Title;
    this.SubTitle = SubTitle;
    this.TuneId = TuneId;
    this.Preface = Preface;
    this.Clauses = Clauses;
    this.Note = Note;
    this.Comments = Comments;
  }
}

export class Allusion {
  AllusionIndex: number;
  AllusionKey: string;
  SentenceIndex: number;

  constructor(AllusionIndex: number, AllusionKey: string, SentenceIndex: number) {
    this.AllusionIndex = AllusionIndex;
    this.AllusionKey = AllusionKey;
    this.SentenceIndex = SentenceIndex;
  }
}

export class CharDict {
  OriginalChar: string;
  Comments: CharComment[];

  constructor(OriginalChar: string, Comments: CharComment[]) {
    this.OriginalChar = OriginalChar;
    this.Comments = Comments;
  }
}

export class CharComment {
  Character: string;
  Origin: string;
  Explains: Explain[];

  constructor(Character: string, Origin: string, Explains: Explain[]) {
    this.Character = Character;
    this.Origin = Origin;
    this.Explains = Explains;
  }
}

export class Explain {
  Type: string; // Example;Explain;Spell;KXSpell
  Content: string;

  constructor(Type: string, Content: string) {
    this.Type = Type;
    this.Content = Content;
  }
}

export class Clause {
  Content: string;
  Comments: Comment[] | null;
  BreakAfter: number | null;

  constructor(Content: string, Comments: Comment[] | null, BreakAfter: number | null) {
    this.Content = Content;
    this.Comments = Comments;
    this.BreakAfter = BreakAfter;
  }
}

export class Comment {
  Category: string | null;
  Content: string;
  Type: string;
  Index: number;

  constructor(Category: string | null, Content: string, Type: string, Index: number) {
    this.Category = Category;
    this.Content = Content;
    this.Type = Type;
    this.Index = Index;
  }
}

export class Quote {
  Book: string | null;
  Section: string | null;
  Content: string | null;
  IsComment: boolean = false;
  ReferrenceUrls: string[] | null;

  constructor(Book: string | null, Section: string | null, Content: string | null, IsComment: boolean,
    ReferrenceUrls: string[] | null) {
    this.Book = Book;
    this.Section = Section;
    this.Content = Content;
    this.IsComment = IsComment;
    this.ReferrenceUrls = ReferrenceUrls;
  }
}

export class Tune {
  Name: string | null;
  Id: number | null;

  constructor(Name: string | null, Id: number | null) {
    this.Name = Name;
    this.Id = Id;
  }
}

export class WordDict {
  Id: number;
  Text: string;
  CountInPoem: number;
  Traditional: string | null;
  Explains: string[];
  Categories: string[] | null;
  Spells: string | null;
  ContainsUnknownSpell: boolean;

  constructor(Id: number, Text: string, CountInPoem: number, Traditional: string | null, Explains: string[],
    Categories: string[] | null, Spells: string | null, ContainsUnknownSpell: boolean) {
    this.Id = Id;
    this.Text = Text;
    this.CountInPoem = CountInPoem;
    this.Traditional = Traditional;
    this.Explains = Explains;
    this.Categories = Categories;
    this.Spells = Spells;
    this.ContainsUnknownSpell = ContainsUnknownSpell;
  }
}

@Concurrent
export async function batchInsertWriting(context: Context, objs: Writing[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Writing#batchInsertWriting');

  let valueBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Writing) => {
    valueBuckets.push(
      {
        'id': obj.Id,
        'group_index': obj.GroupIndex,
        'classes': JSON.stringify(obj.Classes),
        'froms': JSON.stringify(obj.Froms),
        'allusions': JSON.stringify(obj.Allusions),
        'pictures': JSON.stringify(obj.Pictures),
        'dynasty': obj.Dynasty,
        'author': obj.Author,
        'author_id': obj.AuthorId,
        'author_date': obj.AuthorDate,
        'author_years': obj.AuthorYears,
        'author_place': obj.AuthorPlace,
        'type': obj.Type,
        'type_detail': obj.TypeDetail,
        'rhyme': obj.Rhyme,
        'first_clause_rhyme': obj.FirstClauseRhyme,
        'title': JSON.stringify(obj.Title),
        'subtitle': JSON.stringify(obj.SubTitle),
        'tune_id': JSON.stringify(obj.TuneId),
        'preface': obj.Preface,
        'clauses': JSON.stringify(obj.Clauses),
        'note': obj.Note,
        'comments': JSON.stringify(obj.Comments),
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CLASSICALLITERATURE_WRITING_TABLE,
      valueBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertCharacter failed, code is ${err.code}, message is ${err.message}`);
  }
}

@Concurrent
export async function batchInsertWritingFTS(context: Context, objs: Writing[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Writing#batchInsertWritingFTS');

  let valueBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: Writing) => {
    valueBuckets.push(
      {
        'id': obj.Id,
        'author': obj.Author,
        'title': obj.Title.Content,
        'content': obj.Clauses.map((item: Clause) => {
          return item.Content
        }).join(','),
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CLASSICALLITERATURE_WRITING_FTS_TABLE,
      valueBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertCharacter failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getWriting(id: number): Promise<Writing | undefined> {
  let obj: Writing | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CLASSICALLITERATURE_WRITING_TABLE)
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

export async function getBookmarks(): Promise<Writing[]> {
  let objs: Writing[] = [];
  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CLASSICALLITERATURE_WRITING_BOOKMARKS)
    .then((resultSet: relationalStore.ResultSet) => {
      try {
        while (resultSet.goToNextRow()) {
          objs.push(parse(resultSet))
        }
        resultSet.close()
      } catch (error) {
        let err = error as BusinessError
        logger.error(`getBookmarks parse is failed, code is ${err.code},message is ${err.message}`)
      }
    })
    .catch((err: BusinessError) => {
      logger.error(`getBookmarks is failed, code is ${err.code},message is ${err.message}`)
    })
  return objs;
}

/**
 * 参考：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/batch-database-operations-guide
 * @param context
 * @param query
 * @returns
 */
@Concurrent
export async function search(context: Context, query: string): Promise<Array<relationalStore.ValuesBucket>> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('Writing#search');

  // 查询所有数据
  let resultSet = await store.querySql(DbCRUDConst.SEARCH_CLASSICALLITERATURE_WRITING, [`${query}`]);
  console.info(`Query data successfully! row count:${resultSet.rowCount}`);
  let index = 0;
  let result = new Array<relationalStore.ValuesBucket>(resultSet.rowCount);
  resultSet.goToFirstRow();
  do {
    result[index++] = resultSet.getRow();
  } while (resultSet.goToNextRow());
  resultSet.close();
  return result;
}

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): Writing {
  return new Writing(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getLong(resultSet.getColumnIndex('group_index')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('classes'))) as string[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('froms'))) as string[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('allusions'))) as Allusion[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('pictures'))) as string[],
    resultSet.getString(resultSet.getColumnIndex('dynasty')),
    resultSet.getString(resultSet.getColumnIndex('author')),
    resultSet.getLong(resultSet.getColumnIndex('author_id')),
    resultSet.getString(resultSet.getColumnIndex('author_date')),
    resultSet.getString(resultSet.getColumnIndex('author_years')),
    resultSet.getString(resultSet.getColumnIndex('author_place')),
    resultSet.getString(resultSet.getColumnIndex('type')),
    resultSet.getString(resultSet.getColumnIndex('type_detail')),
    resultSet.getString(resultSet.getColumnIndex('rhyme')),
    resultSet.getString(resultSet.getColumnIndex('first_clause_rhyme')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('title'))) as Clause,
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('subtitle'))) as Clause,
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('tune_id'))) as Tune,
    resultSet.getString(resultSet.getColumnIndex('preface')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('clauses'))) as Clause[],
    resultSet.getString(resultSet.getColumnIndex('note')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('comments'))) as Quote[],
  )
}