export class ClassicPoem {
  id: number;
  dynasty: string; // 朝代
  writer: string; // 作者
  writer_introduction: string | null; // 作者简介
  title: string; // 标题
  subtitle: string | null; // 副标题
  preface: string | null; // 序言
  content: string; // 内容
  annotation: string | null; // 注释
  translation: string | null; // 译文
  creative_background: string | null; // 创作背景
  explain: string | null; // 赏析
  comment: string | null; // 点评
  collection: string; // 合集
  category: string | null; // 分类

  constructor(
    id: number,
    dynasty: string,
    writer: string,
    writer_introduction: string,
    title: string,
    subtitle: string | null,
    preface: string | null,
    content: string,
    annotation: string | null,
    translation: string | null,
    creative_background: string | null,
    explain: string | null,
    comment: string | null,
    collection: string,
    category: string | null
  ) {
    this.id = id;
    this.dynasty = dynasty;
    this.writer = writer;
    this.writer_introduction = writer_introduction;
    this.title = title;
    this.subtitle = subtitle;
    this.preface = preface;
    this.content = content;
    this.annotation = annotation;
    this.translation = translation;
    this.creative_background = creative_background;
    this.explain = explain;
    this.comment = comment;
    this.collection = collection;
    this.category = category
  }
}