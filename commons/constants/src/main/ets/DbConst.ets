import { relationalStore } from '@kit.ArkData';
import { PrefConst } from './PrefConst';

export class DbConfigConst {
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'jingmo.db',
    securityLevel: relationalStore.SecurityLevel.S1,
    tokenizer: relationalStore.Tokenizer.ICU_TOKENIZER
  };
}

export class DbTableConst {
  static readonly BOOKMARKS_TABLE: string = 'bookmarks';
  static readonly CLASSICALLITERATURE_CLASSICPOEM_TABLE: string = 'classicalliterature_classicpoem';
  static readonly CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE: string = 'classicalliterature_classicpoem_fts';
  static readonly CLASSICALLITERATURE_WRITING_TABLE: string = "classicalliterature_writing";
  static readonly CLASSICALLITERATURE_SENTENCE_TABLE: string = "classicalliterature_sentence";
  static readonly CLASSICALLITERATURE_SENTENCE_FTS_TABLE: string = "classicalliterature_sentence_fts";
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
  static readonly CHINESE_KNOWLEDGE_FTS_TABLE: string = "chinese_knowledge_fts";
  static readonly CHINESE_QUOTE_TABLE: string = "chinese_quote";
  static readonly CHINESE_QUOTE_FTS_TABLE: string = "chinese_quote_fts";
  static readonly CHINESE_MODERNPOETRY_TABLE: string = "chinese_modernpoetry";
  static readonly CHINESE_MODERNPOETRY_FTS_TABLE: string = "chinese_modernpoetry_fts";
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
  static readonly CREATE_CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE =
    'CREATE VIRTUAL TABLE IF NOT EXISTS ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE +
      ' USING fts4(id, writer, title, content, tokenize=icu zh_CN)';
  static readonly CREATE_CLASSICALLITERATURE_SENTENCE_TABLE: string =
    'create table if not exists ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, from_txt text not null, poem_id integer)';
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
      'example text, source text, quote text, similar text, opposite text, usage text, story text, notice text, ' +
      'spelling text)';
  static readonly CREATE_CHINESE_IDIOM_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_IDIOM_TABLE +
      ' (id integer not null primary key autoincrement, word text not null, pinyin text not null, abbr text not null,  ' +
      'explanation text, example text, source text, quote text, similar text, opposite text, usage text, story text, ' +
      'notice text, spelling text)';
  static readonly CREATE_CHINESE_KNOWLEDGE_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, label text not null, url text)';
  static readonly CREATE_CHINESE_MODERNPOETRY_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE +
      ' (id integer primary key autoincrement not null, title text not null, author text not null, ' +
      'content text not null, zhu text, yi text, shang text, author_info text)';
  static readonly CREATE_CHINESE_QUOTE_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_QUOTE_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, author text, from_txt text not null)';
  static readonly CREATE_BOOKMARKS_TABLE: string =
    'create table if not exists ' + DbTableConst.BOOKMARKS_TABLE +
      ' (id integer primary key autoincrement not null, bookmarkable_id integer, bookmarkable_model text)';
}

export class DbCRUDConst {
  static readonly READ_CHINA_WORLDCULTUREHERITAGE: string =
    'select * from ' + DbTableConst.CHINA_WORLDCULTUREHERITAGE_TABLE +
      'where id = ? limit 1';
  static readonly READ_RANDOM_CHINESE_ANTITHETICALCOUPLET: string =
    'select * from ' + DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_ANTITHETICALCOUPLET: string =
    'select * from ' + DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE +
      ' where body like ?';
  static readonly CHINESE_ANTITHETICALCOUPLETI_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_ANTITHETICALCOUPLET + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_CHARACTER: string =
    'select * from ' + DbTableConst.CHINESE_CHARACTER_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_CHARACTER_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly CHINESE_CHARACTER_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_CHARACTER_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_CHARACTER + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_EXPRESSION: string =
    'select * from ' + DbTableConst.CHINESE_EXPRESSION_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_EXPRESSION_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_EXPRESSION: string =
    'select * from ' + DbTableConst.CHINESE_EXPRESSION_TABLE +
      ' where word like ?';
  static readonly CHINESE_EXPRESSION_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_EXPRESSION_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_EXPRESSION + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_IDIOM: string =
    'select * from ' + DbTableConst.CHINESE_IDIOM_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_IDIOM_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_IDIOM: string =
    'select * from ' + DbTableConst.CHINESE_IDIOM_TABLE +
      ' where word like ?';
  static readonly CHINESE_IDIOM_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_IDIOM_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_IDIOM + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_KNOWLEDGE: string =
    'select * from ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_KNOWLEDGE: string =
    'select * from ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE +
      ' where content like ?';
  static readonly CHINESE_KNOWLEDGE_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_KNOWLEDGE + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_QUOTE: string =
    'select * from ' + DbTableConst.CHINESE_QUOTE_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_QUOTE_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_QUOTE: string =
    'select * from ' + DbTableConst.CHINESE_QUOTE_TABLE +
      ' where content like ?';
  static readonly CHINESE_QUOTE_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_QUOTE_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_QUOTE + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CLASSICALLITERATURE_CLASSICPOEM: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' where id = (select id from ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CLASSICALLITERATURE_CLASSICPOEM: string =
    'select tbl.* from ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE + ' as tbl' +
      ' join ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE + ' as v' +
      ' on tbl.id = v.id where ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE + ' match ?';
  static readonly CLASSICALLITERATURE_CLASSICPOEM_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_CLASSICPOEM +
      '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CLASSICALLITERATURE_SENTENCE: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE +
      ' where id = (select id from ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CLASSICALLITERATURE_SENTENCE: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE +
      ' where content like ?';
  static readonly CLASSICALLITERATURE_SENTENCE_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_SENTENCE + '\'' +
      ' order by b.id desc';
  static readonly BOOKMARKS: string =
    'select b.*, tbl1.body as chinese_antitheticalcouplet,' +
      ' tbl2.character as chinese_character,' +
      ' tbl3.word as chinese_expression,' +
      ' tbl4.word as chinese_idiom,' +
      ' tbl5.content as chinese_knowledge,' +
      ' tbl6.content as chinese_quote,' +
      ' tbl7.title as classicalliterature_classicpoem,' +
      ' tbl8.content as classicalliterature_sentence' +
      ' from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' left join ' + DbTableConst.CHINESE_ANTITHETICALCOUPLET_TABLE + ' as tbl1' +
      ' on b.bookmarkable_id = tbl1.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_ANTITHETICALCOUPLET + '\'' +
      ' left join ' + DbTableConst.CHINESE_CHARACTER_TABLE + ' as tbl2' +
      ' on b.bookmarkable_id = tbl2.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_CHARACTER + '\'' +
      ' left join ' + DbTableConst.CHINESE_EXPRESSION_TABLE + ' as tbl3' +
      ' on b.bookmarkable_id = tbl3.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_EXPRESSION + '\'' +
      ' left join ' + DbTableConst.CHINESE_IDIOM_TABLE + ' as tbl4' +
      ' on b.bookmarkable_id = tbl4.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_IDIOM + '\'' +
      ' left join ' + DbTableConst.CHINESE_KNOWLEDGE_TABLE + ' as tbl5' +
      ' on b.bookmarkable_id = tbl5.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_KNOWLEDGE + '\'' +
      ' left join ' + DbTableConst.CHINESE_QUOTE_TABLE + ' as tbl6' +
      ' on b.bookmarkable_id = tbl6.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_QUOTE + '\'' +
      ' left join ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE + ' as tbl7' +
      ' on b.bookmarkable_id = tbl7.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_CLASSICPOEM +
      '\'' +
      ' left join ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE + ' as tbl8' +
      ' on b.bookmarkable_id = tbl8.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_SENTENCE + '\'' +
      ' order by b.id desc';
}