export class Radical {
  stroke: string;
  radicals: string[];

  constructor(stroke: string, radicals: string[]) {
    this.stroke = stroke;
    this.radicals = radicals;
  }
}

export function getRadicalList(): Radical[] {
  let list = new Array<Radical>(
    new Radical(
      "一画",
      new Array<string>("一", "丨", "丿", "丶", "乛", "㇕", "⺄", "乚", "亅")
    ),
    new Radical(
      "二画",
      new Array<string>(
        "㔾",
        "廴",
        "讠",
        "阝",
        "又",
        "厶",
        "厂",
        "卩",
        "卜",
        "十",
        "匚",
        "匕",
        "二",
        "勹",
        "力",
        "刂",
        "刀",
        "凵",
        "几",
        "冫",
        "冖",
        "冂",
        "八",
        "亻",
        "儿",
        "入",
        "亠",
        "人",
        "丷"
      )
    ),
    new Radical(
      "三画",
      new Array<string>(
        "扌",
        "马",
        "饣",
        "飞",
        "门",
        "辶",
        "艹",
        "犭",
        "纟",
        "氵",
        "忄",
        "川",
        "彳",
        "彡",
        "弓",
        "彐",
        "彑",
        "弋",
        "廾",
        "广",
        "幺",
        "干",
        "巾",
        "巳",
        "已",
        "己",
        "工",
        "巛",
        "屮",
        "山",
        "尸",
        "小",
        "兀",
        "尢",
        "宀",
        "寸",
        "子",
        "女",
        "大",
        "夕",
        "夂",
        "士",
        "口",
        "囗",
        "土",
        "丬"
      )
    ),
    new Radical(
      "四画",
      new Array<string>(
        "风",
        "韦",
        "车",
        "贝",
        "见",
        "肀",
        "罓",
        "耂",
        "礻",
        "瓦",
        "王",
        "犬",
        "牛",
        "牙",
        "片",
        "爿",
        "爻",
        "父",
        "爪",
        "爫",
        "灬",
        "厄",
        "火",
        "水",
        "气",
        "氏",
        "毛",
        "比",
        "毋",
        "殳",
        "歹",
        "止",
        "朩",
        "欠",
        "木",
        "月",
        "日",
        "旡",
        "方",
        "斤",
        "斗",
        "文",
        "攵",
        "攴",
        "支",
        "手",
        "户",
        "戈",
        "心",
        "尣",
        "⺼",
        "曰",
        "龵",
        "无"
      )
    ),
    new Radical(
      "五画",
      new Array<string>(
        "龙",
        "鸟",
        "钅",
        "衤",
        "罒",
        "立",
        "禾",
        "穴",
        "示",
        "石",
        "矢",
        "矛",
        "目",
        "皿",
        "皮",
        "白",
        "癶",
        "疒",
        "疋",
        "田",
        "用",
        "玄",
        "生",
        "四",
        "巨",
        "甘",
        "瓜",
        "玉",
        "氺",
        "母",
        "业",
        "歺",
        "⺻"
      )
    ),
    new Radical(
      "六画",
      new Array<string>(
        "齐",
        "页",
        "西",
        "衣",
        "血",
        "虫",
        "虍",
        "艸",
        "色",
        "艮",
        "舟",
        "舌",
        "臼",
        "至",
        "自",
        "臣",
        "耳",
        "耒",
        "而",
        "行",
        "羽",
        "羊",
        "缶",
        "糹",
        "糸",
        "网",
        "老",
        "竹",
        "米",
        "先",
        "覀",
        "舛"
      )
    ),
    new Radical(
      "七画",
      new Array<string>(
        "镸",
        "龟",
        "麦",
        "里",
        "釆",
        "酉",
        "邑",
        "辵",
        "辰",
        "辛",
        "車",
        "身",
        "足",
        "走",
        "赤",
        "貝",
        "豸",
        "豕",
        "豆",
        "谷",
        "言",
        "克",
        "角",
        "見",
        "卤"
      )
    ),
    new Radical(
      "八画",
      new Array<string>(
        "𨸏",
        "龺",
        "齿",
        "黾",
        "鱼",
        "飠",
        "靑",
        "青",
        "非",
        "雨",
        "隹",
        "采",
        "隶",
        "阜",
        "門",
        "長",
        "金",
        "釒"
      )
    ),
    new Radical(
      "九画",
      new Array<string>("鬼", "骨", "香", "首", "食", "風", "頁", "音", "韭", "韋", "革", "面", "飛")
    ),
    new Radical(
      "十画",
      new Array<string>("鬲", "鬥", "髟", "高", "馬")
    ),
    new Radical(
      "十一画",
      new Array<string>("黄", "麻", "麥", "鹿", "鹵", "鳥", "魚")
    ),
    new Radical(
      "十二画",
      new Array<string>("鼎", "黑", "黍", "黹")
    ),
    new Radical(
      "十三画",
      new Array<string>("鼠", "黽", "鼓")
    ),
    new Radical(
      "十四画",
      new Array<string>("齊", "鼻")
    ),
    new Radical(
      "十五画",
      new Array<string>("齒")
    ),
    new Radical(
      "十六画",
      new Array<string>("龜", "龍")
    ),
    new Radical(
      "十七画",
      new Array<string>("龠")
    )
  )

  return list;
}