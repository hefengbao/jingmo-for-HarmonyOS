import { relationalStore } from '@kit.ArkData';

export class DbConfigConst {
  static readonly DB_VERSION: number = 1;
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: this.DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S1,
    tokenizer: relationalStore.Tokenizer.ICU_TOKENIZER
  };
  private static readonly DB_NAME: string = 'jingmo.db';
}

export class DbTableConst {
  static readonly CLASSICALLITERATURE_CLASSICPOEM_TABLE: string = 'classicalliterature_classicpoem';
  static readonly CLASSICALLITERATURE_WRITING_TABLE: string = "classicalliterature_writing";
  static readonly CLASSICALLITERATURE_SENTENCE_TABLE: string = "classicalliterature_sentence";
  static readonly CLASSICALLITERATURE_PEOPLE_TABLE: string = "classicalliterature_people";
  static readonly CHINESE_CHARACTER_TABLE: string = "chinese_character";
  static readonly CHINESE_EXPRESSION_TABLE: string = "chinese_expression";
  static readonly CHINESE_IDIOM_TABLE: string = "chinese_idiom";
  static readonly CHINESE_WISECRACK_TABLE: string = "chinese_wisecrack";
  static readonly CHINESE_RIDDLE_TABLE: string = "chinese_riddle";
  static readonly CHINESE_PROVERB_TABLE: string = "chinese_proverb";
  static readonly CHINESE_TONGUETWISTER_TABLE: string = "chinese_tonguetwister";
  static readonly CHINESE_ANTITHETICALCOUPLET_TABLE: string = "chinese_antitheticalcouplet";
  static readonly CHINESE_LYRIC_TABLE: string = "chinese_lyric";
  static readonly CHINESE_KNOWLEDGE_TABLE: string = "chinese_knowledge";
  static readonly CHINESE_QUOTE_TABLE: string = "chinese_quote";
  static readonly CHINESE_MODERNPOETRY_TABLE: string = "chinese_modernpoetry";
  static readonly CHINA_WORLDCULTUREHERITAGE_TABLE: string = "china_worldcultureheritage";
}

// 为了保证平稳升级，所有的修改、删除操作都通过 SQL 语句完成,即不更改以前版本的 SQL 语句
export class DbMigrationConst {
  // Version 0
  static readonly CREATE_CLASSICALLITERATURE_CLASSICPOEM_TABLE: string =
    'create table if not exists ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' ( id integer primary key autoincrement not null, dynasty text not null, writer text not null,' +
      ' writer_introduction text, title text not null, subtitle text, preface text, content text not null,' +
      ' annotation text, translation text, creative_background text, explain text, comment text, collection text,' +
      ' category text )';
}

export class DbCRUDConst {
  static readonly READ_RANDOM_CLASSICPOEM: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' where id = (select p.id from classicalliterature_classicpoem p order by random() limit 1) limit 1';
}