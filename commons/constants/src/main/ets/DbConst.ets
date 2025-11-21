import { relationalStore } from '@kit.ArkData';

export class DbConfigConst {
  private static readonly DB_NAME: string = 'jingmo.db';
  static readonly DB_VERSION: number = 1;
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: this.DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S1,
    tokenizer: relationalStore.Tokenizer.ICU_TOKENIZER
  };
}

export class DbTableConst {
  static readonly ClassicPoemTable: string = 'classicalliterature_classicpoem';
}

// 为了保证平稳升级，所有的修改、删除操作都通过 SQL 语句完成
export class DbMigrationConst {
  // Version 0
  static readonly CREATE_CLASSICALLITERATURE_CLASSICPOEM_TABLE: string =
    'create table if not exists ' + DbTableConst.ClassicPoemTable +
      ' ( id integer primary key autoincrement not null, dynasty text not null, writer text not null,' +
      ' writer_introduction text, title text not null, subtitle text, preface text, content text not null,' +
      ' annotation text, translation text, creative_background text, explain text, comment text, collection text,' +
      ' category text )';
}

export class DbCRUDConst {
  static readonly READ_RANDOM_CLASSICPOEM: string =
    'select * from ' + DbTableConst.ClassicPoemTable +
      ' where id = (select p.id from classicalliterature_classicpoem p order by random() limit 1) limit 1';
}