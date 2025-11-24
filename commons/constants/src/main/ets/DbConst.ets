import { relationalStore } from '@kit.ArkData';

export class DbConfigConst {
  static readonly DB_VERSION: number = 1;
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'jingmo.db',
    securityLevel: relationalStore.SecurityLevel.S1,
    tokenizer: relationalStore.Tokenizer.ICU_TOKENIZER
  };
}

export class DbTableConst {
  static readonly BOOKMARKS_TABLE: string = 'bookmarks';
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
  static readonly CREATE_CHINA_WORLDCULTUREHERITAGE_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE +
      ' (id integer primary key autoincrement not null, type text not null, name text not null, year text not null, ' +
      'year2 text, level text not null, address text not null, image text not null, content text not null)';
  static readonly CREATE_CLASSICALLITERATURE_CLASSICPOEM_TABLE: string =
    'create table if not exists ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' (id integer primary key autoincrement not null, dynasty text not null, writer text not null,' +
      ' writer_introduction text, title text not null, subtitle text, preface text, content text not null,' +
      ' annotation text, translation text, creative_background text, explain text, comment text, collection text,' +
      ' category text )';
  static readonly CREATE_CLASSICALLITERATURE_SENTENCE_TABLE: string =
    'create table if not exists ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, from text not null, poem_id integer)';
  static readonly CREATE_CHINESE_ANTITHETICALCOUPLET_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE +
      ' (id integer primary key autoincrement not null, body text not null, description text, image text)';
  static readonly CREATE_CHINESE_CHARACTER_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_CHARACTER_TABLE +
      ' (id integer primary key autoincrement not null, character text not null, character2 text, pinyin text not null, ' +
      'radical text, stroke integer, wubi text, explanations text, explanations2 text)';
  static readonly CREATE_CHINESE_EXPRESSION_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_EXPRESSION_TABLE +
      ' (id integer not null primary key autoincrement, word text not null, pinyin text not null, explanation text, ' +
      'example text, source text, quote text, similar text, opposite text, usage varchar, story text, notice text, ' +
      'spelling text)';
  static readonly CREATE_CHINESE_IDIOM_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_IDIOM_TABLE +
      ' (id integer not null primary key autoincrement, word text not null, pinyin text not null, explanation text, ' +
      'example text, source text, quote text, similar text, opposite text, usage varchar, story text, notice text, ' +
      'spelling text)';
  static readonly CREATE_CHINESE_KNOWLEDGE_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, label text not null, url text)';
  static readonly CREATE_CHINESE_MODERNPOETRY_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE +
      ' (id integer primary key autoincrement not null, title text not null, author text not null, ' +
      'content text not null, zhu text, yi text, shang text, author_info text)';
  static readonly CREATE_CHINESE_QUOTE_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_QUOTE_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, author varchar, from varchar not null)';
  static readonly CREATE_BOOKMARKS_TABLE: string =
    'create table if not exists ' + DbTableConst.BOOKMARKS_TABLE +
      ' (id integer primary key autoincrement not null, bookmarkable_id integer, bookmarkable_model text)';
}

export class DbCRUDConst {
  static readonly READ_CHINA_WORLDCULTUREHERITAGE: string =
    'select * from ' + DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE +
      'where id = ? limit 1';
  static readonly READ_RANDOM_CLASSICALLITERATURE_CLASSICPOEM: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' where id = (select p.id from ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' p order by random() limit 1) limit 1';
  static readonly READ_RANDOM_CHINESE_CHARACTER: string =
    'select * from ' + DbTableConst.CHINESE_CHARACTER_TABLE +
      ' where id = (select p.id from ' + DbTableConst.CHINESE_CHARACTER_TABLE +
      ' p order by random() limit 1) limit 1';
}