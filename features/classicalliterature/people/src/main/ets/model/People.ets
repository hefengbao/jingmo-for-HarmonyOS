import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { DbConfigConst, DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { JSON } from '@kit.ArkTS';

let logger: Logger = new Logger('People');

export class People {
  Id: number;
  Name: string;
  BirthYear: string | null;
  BirthDay: string | null;
  DeathYear: string | null;
  DeathDay: string | null;
  Dynasty: string;
  Aliases: Alias[] | null;
  Titles: string[] | null;
  Hometown: Hometown[] | null;
  Details: Detail[] | null;

  constructor(Id: number, Name: string, BirthYear: string | null, BirthDay: string | null, DeathYear: string | null,
    DeathDay: string | null, Dynasty: string, Aliases: Alias[] | null, Titles: string[] | null,
    Hometown: Hometown[] | null, Details: Detail[] | null) {
    this.Id = Id;
    this.Name = Name;
    this.BirthYear = BirthYear;
    this.BirthDay = BirthDay;
    this.DeathYear = DeathYear;
    this.DeathDay = DeathDay;
    this.Dynasty = Dynasty;
    this.Aliases = Aliases;
    this.Titles = Titles;
    this.Hometown = Hometown;
    this.Details = Details;
  }
}

export class Alias {
  Name: string;
  Type: string;

  constructor(Name: string, Type: string) {
    this.Name = Name;
    this.Type = Type;
  }
}

export class Detail {
  Book: string;
  Section: string | null;
  Content: string | null;
  IsReview: Boolean;
  ReferenceUrls: string[] | null;

  constructor(Book: string, Section: string | null, Content: string | null, IsReview: Boolean,
    ReferenceUrls: string[] | null) {
    this.Book = Book;
    this.Section = Section;
    this.Content = Content;
    this.IsReview = IsReview;
    this.ReferenceUrls = ReferenceUrls;
  }
}

export class Hometown {
  RegionId: string;
  Name: string;

  constructor(RegionId: string, Name: string) {
    this.RegionId = RegionId;
    this.Name = Name;
  }
}

@Concurrent
export async function batchInsertPeople(context: Context, objs: People[]): Promise<void> {
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
  let logger: Logger = new Logger('People#batchInsertPeople');

  let valuesBuckets: relationalStore.ValuesBucket[] = []

  objs.forEach((obj: People, index: number) => {
    valuesBuckets.push(
      {
        'id': obj.Id,
        'name': obj.Name,
        'birth_year': obj.BirthYear,
        'birthday': obj.BirthDay,
        'death_year': obj.DeathYear,
        'deathday': obj.DeathDay,
        'dynasty': obj.Dynasty,
        'aliases': JSON.stringify(obj.Aliases),
        'titles': JSON.stringify(obj.Titles),
        'hometown': JSON.stringify(obj.Hometown),
        'details': JSON.stringify(obj.Details),
      }
    )
  })

  try {
    await store.batchInsertWithConflictResolution(
      DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE,
      valuesBuckets,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((value: number) => {
      logger.info(`insert rows = ${value}`)
    }).catch((err: BusinessError) => {
      logger.error(`batchInsertWithConflictResolution failed, code is ${err.code}, message is ${err.message}`);
    })
  } catch (error) {
    const err = error as BusinessError;
    logger.error(`batchInsertPeople failed, code is ${err.code}, message is ${err.message}`);
  }
}

export async function getRandomPeople(): Promise<People | undefined> {
  let obj: People | undefined;

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CLASSICALLITERATURE_PEOPLE)
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

export async function getPeople(id: number): Promise<People | undefined> {
  let obj: People | undefined;

  let predicates = new relationalStore.RdbPredicates(DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE);
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

export async function search(query: string): Promise<People[]> {
  let objs: People[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.SEARCH_CLASSICALLITERATURE_PEOPLE, [`%${query}%`])
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

/*export async function getBookmarks(): Promise<People[]> {
  let objs: People[] = [];

  await DbUtil.objectiveRDB?.querySql(DbCRUDConst.CLASS)
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
}*/

/**
 * @throws
 */
function parse(resultSet: relationalStore.ResultSet): People {
  return new People(
    resultSet.getLong(resultSet.getColumnIndex('id')),
    resultSet.getString(resultSet.getColumnIndex('name')),
    resultSet.getString(resultSet.getColumnIndex('birth_year')),
    resultSet.getString(resultSet.getColumnIndex('birthday')),
    resultSet.getString(resultSet.getColumnIndex('death_year')),
    resultSet.getString(resultSet.getColumnIndex('deathday')),
    resultSet.getString(resultSet.getColumnIndex('dynasty')),
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('aliases'))) as Alias[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('titles'))) as string[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('hometown'))) as Hometown[],
    JSON.parse(resultSet.getString(resultSet.getColumnIndex('details'))) as Detail[],
  )
}