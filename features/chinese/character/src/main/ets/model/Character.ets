export class Character {
  id: number = 0;
  character: string = '';
  character2: string | null = null;
  pinyin: string | null = null;
  radical: string | null = null;
  stroke: number | null = null;
  wubi: string | null = null;
  explanations: string[] | null = null;
  explanations2: ExplanationItem[] | null = null;
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