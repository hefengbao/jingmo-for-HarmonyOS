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
  static readonly CHINA_WORLDCULTUREHERITAGE_TABLE: string = "china_worldcultureheritage";
  static readonly CHINESE_ANTITHETICALCOUPLET_TABLE: string = "chinese_antitheticalcouplet";
  static readonly CHINESE_CHARACTER_TABLE: string = "chinese_character";
  static readonly CHINESE_EXPRESSION_TABLE: string = "chinese_expression";
  static readonly CHINESE_IDIOM_TABLE: string = "chinese_idiom";
  static readonly CHINESE_KNOWLEDGE_TABLE: string = "chinese_knowledge";
  //static readonly CHINESE_KNOWLEDGE_FTS_TABLE: string = "chinese_knowledge_fts";
  static readonly CHINESE_LYRIC_TABLE: string = "chinese_lyric";
  static readonly CHINESE_LYRIC_FTS_TABLE: string = "chinese_lyric_fts";
  static readonly CHINESE_MODERNPOETRY_TABLE: string = "chinese_modernpoetry";
  static readonly CHINESE_MODERNPOETRY_FTS_TABLE: string = "chinese_modernpoetry_fts";
  static readonly CHINESE_PROVERB_TABLE: string = "chinese_proverb";
  static readonly CHINESE_QUOTE_TABLE: string = "chinese_quote";
  //static readonly CHINESE_QUOTE_FTS_TABLE: string = "chinese_quote_fts";
  static readonly CHINESE_RIDDLE_TABLE: string = "chinese_riddle";
  static readonly CHINESE_TONGUETWISTER_TABLE: string = "chinese_tonguetwister";
  static readonly CHINESE_WISECRACK_TABLE: string = "chinese_wisecrack";
  static readonly CLASSICALLITERATURE_CLASSICPOEM_TABLE: string = 'classicalliterature_classicpoem';
  static readonly CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE: string = 'classicalliterature_classicpoem_fts';
  static readonly CLASSICALLITERATURE_PEOPLE_TABLE: string = "classicalliterature_people";
  static readonly CLASSICALLITERATURE_SENTENCE_TABLE: string = "classicalliterature_sentence";
  //static readonly CLASSICALLITERATURE_SENTENCE_FTS_TABLE: string = "classicalliterature_sentence_fts";
  static readonly CLASSICALLITERATURE_WRITING_TABLE: string = "classicalliterature_writing";
  static readonly CLASSICALLITERATURE_WRITING_FTS_TABLE: string = "classicalliterature_writing_fts";
  static readonly FORM_INFO_TABLE: string = "form_info";
}

// 为了保证平稳升级，所有的修改、删除操作都通过 SQL 语句完成,即不更改以前版本的 SQL 语句
export class DbMigrationConst {
  // Version 1
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
  // Version 2
  static readonly CREATE_CHINESE_LYRIC_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_LYRIC_TABLE +
      ' (id integer primary key autoincrement not null, title text not null, writer text, ' +
      'singer text, content text not null)';
  static readonly CREATE_CHINESE_LYRIC_FTS_TABLE =
    'CREATE VIRTUAL TABLE IF NOT EXISTS ' + DbTableConst.CHINESE_LYRIC_FTS_TABLE +
      ' USING fts4(id, title, content, tokenize=icu zh_CN)';
  static readonly CREATE_CHINESE_MODERNPOETRY_FTS_TABLE: string =
    'CREATE VIRTUAL TABLE IF NOT EXISTS ' + DbTableConst.CHINESE_MODERNPOETRY_FTS_TABLE +
      ' USING fts4(id, author, title, content, tokenize=icu zh_CN)';
  static readonly CREATE_CHINESE_PROVERB_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_PROVERB_TABLE +
      ' (id integer primary key autoincrement not null, content text not null, tags text)';
  static readonly CREATE_CHINESE_RIDDLE_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_RIDDLE_TABLE +
      ' (id integer primary key autoincrement not null, puzzle text, answer text)';
  static readonly CREATE_CHINESE_TONGUETWISTER_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_TONGUETWISTER_TABLE +
      ' (id integer primary key autoincrement not null, title text not null, content text not null, content2 text)';
  static readonly CREATE_CHINESE_WISECRACK_TABLE: string =
    'create table if not exists ' + DbTableConst.CHINESE_WISECRACK_TABLE +
      ' (id integer primary key autoincrement not null, riddle text not null, answer text not null, ' +
      'first_letter text, first_word text)';
  static readonly CREATE_CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE =
    'CREATE VIRTUAL TABLE IF NOT EXISTS ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE +
      ' USING fts4(id, writer, title, content, tokenize=icu zh_CN)';
  static readonly CREATE_CLASSICALLITERATURE_PEOPLE_TABLE: string =
    'create table if not exists ' + DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE +
      ' (id integer primary key autoincrement not null, name text not null, birth_year text, ' +
      'birthday text, death_year text, deathday text, dynasty text, aliases text, titles text, ' +
      'hometown text, details text)';
  static readonly CREATE_CLASSICALLITERATURE_WRITING_TABLE =
    'create table if not exists ' + DbTableConst.CLASSICALLITERATURE_WRITING_TABLE + '' +
      ' (id integer primary key autoincrement not null, group_index integer, classes text, froms text, ' +
      'allusions text, pictures text, dynasty text, author text, author_id integer, author_date text, ' +
      'author_years text, author_place text, type text, type_detail text, rhyme text, rank integer, ' +
      'first_clause_rhyme text, title text, subtitle text, tune_id text, preface text, ' +
      'clauses text not null, note text, comments text)';
  static readonly CREATE_CLASSICALLITERATURE_WRITING_FTS_TABLE =
    'CREATE VIRTUAL TABLE IF NOT EXISTS ' + DbTableConst.CLASSICALLITERATURE_WRITING_FTS_TABLE +
      ' USING fts4(id, author, title, content, tokenize=icu zh_CN)';
  // Version3
  static readonly CREATE_FORM_INFO_TABLE =
    'create table if not exists ' + DbTableConst.FORM_INFO_TABLE +
      ' (id text primary key not null, name text not null, dimension text not null, ability text)';
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
  static readonly READ_RANDOM_CHINESE_LYRIC: string =
    'select * from ' + DbTableConst.CHINESE_LYRIC_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_LYRIC_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_LYRIC: string =
    'select tbl.* from ' + DbTableConst.CHINESE_LYRIC_TABLE + ' as tbl' +
      ' join ' + DbTableConst.CHINESE_LYRIC_FTS_TABLE + ' as v' +
      ' on tbl.id = v.id where ' + DbTableConst.CHINESE_LYRIC_FTS_TABLE + ' match ?';
  static readonly CHINESE_LYRIC_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_LYRIC_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_LYRIC + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_MODERNPOETRY: string =
    'select * from ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_MODERNPOETRY: string =
    'select tbl.* from ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE + ' as tbl' +
      ' join ' + DbTableConst.CHINESE_MODERNPOETRY_FTS_TABLE + ' as v' +
      ' on tbl.id = v.id where ' + DbTableConst.CHINESE_MODERNPOETRY_FTS_TABLE + ' match ?';
  static readonly CHINESE_MODERNPOETRY_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_MODERNPOETRY + '\'' +
      ' order by b.id desc';
  static readonly READ_RANDOM_CHINESE_PROVERB: string =
    'select * from ' + DbTableConst.CHINESE_PROVERB_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_PROVERB_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_PROVERB: string =
    'select * from ' + DbTableConst.CHINESE_PROVERB_TABLE +
      ' where content like ?';
  static readonly CHINESE_PROVERB_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_PROVERB_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_PROVERB + '\'' +
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
  static readonly READ_RANDOM_CHINESE_RIDDLE: string =
    'select * from ' + DbTableConst.CHINESE_RIDDLE_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_RIDDLE_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_RIDDLE: string =
    'select * from ' + DbTableConst.CHINESE_RIDDLE_TABLE +
      ' where puzzle like ?';
  static readonly CHINESE_RIDDLE_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_RIDDLE_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_RIDDLE + '\'' +
      ' order by b.id desc';
  static readonly CHINESE_TONGUETWISTER_LIST: string =
    'select * from ' + DbTableConst.CHINESE_TONGUETWISTER_TABLE;
  static readonly READ_RANDOM_CHINESE_WISECRACK: string =
    'select * from ' + DbTableConst.CHINESE_WISECRACK_TABLE +
      ' where id = (select id from ' + DbTableConst.CHINESE_WISECRACK_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CHINESE_WISECRACK: string =
    'select * from ' + DbTableConst.CHINESE_WISECRACK_TABLE +
      ' where riddle like ?';
  static readonly CHINESE_WISECRACK_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CHINESE_WISECRACK_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_WISECRACK + '\'' +
      ' order by b.id desc';
  static readonly INSERT_CLASSICALLITERATURE_CLASSICPOEM_FTS: string =
    'INSERT INTO ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE +
      ' (id, writer, title, content) SELECT id, writer, title, content FROM ' +
    DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE;
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
  static readonly READ_RANDOM_CLASSICALLITERATURE_PEOPLE: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE +
      ' where id = (select id from ' + DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE +
      ' order by random() limit 1) limit 1';
  static readonly SEARCH_CLASSICALLITERATURE_PEOPLE: string =
    'select * from ' + DbTableConst.CLASSICALLITERATURE_PEOPLE_TABLE +
      ' where name like ?';
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
  static readonly SEARCH_CLASSICALLITERATURE_WRITING: string =
    'select tbl.* from ' + DbTableConst.CLASSICALLITERATURE_WRITING_TABLE + ' as tbl' +
      ' join ' + DbTableConst.CLASSICALLITERATURE_WRITING_FTS_TABLE + ' as v' +
      ' on tbl.id = v.id where ' + DbTableConst.CLASSICALLITERATURE_WRITING_FTS_TABLE + ' match ? limit 100';
  static readonly CLASSICALLITERATURE_WRITING_BOOKMARKS: string =
    'select tbl.* from ' + DbTableConst.BOOKMARKS_TABLE + ' as b' +
      ' join ' + DbTableConst.CLASSICALLITERATURE_WRITING_TABLE + ' as tbl' +
      ' on b.bookmarkable_id = tbl.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_WRITING + '\'' +
      ' order by b.id desc';
  static readonly BOOKMARKS: string =
    'select b.*, tbl1.body as chinese_antitheticalcouplet,' +
      ' tbl2.character as chinese_character,' +
      ' tbl3.word as chinese_expression,' +
      ' tbl4.word as chinese_idiom,' +
      ' tbl5.content as chinese_knowledge,' +
      ' tbl6.title as chinese_lyric,' +
      ' tbl7.title as chinese_poetry,' +
      ' tbl8.content as chinese_proverb,' +
      ' tbl9.content as chinese_quote,' +
      ' tbl10.puzzle as chinese_riddle,' +
      ' tbl11.riddle as chinese_wisecrack,' +
      ' tbl12.title as classicalliterature_classicpoem_title,' +
      ' tbl12.writer as classicalliterature_classicpoem_author,' +
      ' tbl13.content as classicalliterature_sentence,' +
      ' tbl14.title as classicalliterature_writing_title,' +
      ' tbl14.author as classicalliterature_writing_author' +
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
      ' left join ' + DbTableConst.CHINESE_LYRIC_TABLE + ' as tbl6' +
      ' on b.bookmarkable_id = tbl6.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_LYRIC + '\'' +
      ' left join ' + DbTableConst.CHINESE_MODERNPOETRY_TABLE + ' as tbl7' +
      ' on b.bookmarkable_id = tbl7.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_MODERNPOETRY + '\'' +
      ' left join ' + DbTableConst.CHINESE_PROVERB_TABLE + ' as tbl8' +
      ' on b.bookmarkable_id = tbl8.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_PROVERB + '\'' +
      ' left join ' + DbTableConst.CHINESE_QUOTE_TABLE + ' as tbl9' +
      ' on b.bookmarkable_id = tbl9.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_QUOTE + '\'' +
      ' left join ' + DbTableConst.CHINESE_RIDDLE_TABLE + ' as tbl10' +
      ' on b.bookmarkable_id = tbl10.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_RIDDLE + '\'' +
      ' left join ' + DbTableConst.CHINESE_WISECRACK_TABLE + ' as tbl11' +
      ' on b.bookmarkable_id = tbl11.id and b.bookmarkable_model = \'' + PrefConst.CHINESE_WISECRACK + '\'' +
      ' left join ' + DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE + ' as tbl12' +
      ' on b.bookmarkable_id = tbl12.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_CLASSICPOEM +
      '\'' +
      ' left join ' + DbTableConst.CLASSICALLITERATURE_SENTENCE_TABLE + ' as tbl13' +
      ' on b.bookmarkable_id = tbl13.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_SENTENCE + '\'' +
      ' left join ' + DbTableConst.CLASSICALLITERATURE_WRITING_TABLE + ' as tbl14' +
      ' on b.bookmarkable_id = tbl14.id and b.bookmarkable_model = \'' + PrefConst.CLASSICALLITERATURE_WRITING + '\'' +
      ' order by b.id desc';
}