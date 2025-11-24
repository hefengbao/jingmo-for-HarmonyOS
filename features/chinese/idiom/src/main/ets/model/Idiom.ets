export class Idiom {
  id: number = 0;
  word: string = '';
  pinyin: string = '';
  abbr: string = '';
  explanation: string | null = null;
  source: IdiomSource | null = null;
  quote: IdiomQuote | null = null;
  example: IdiomExample | null = null;
  similar: string[] | null = null;
  opposite: string[] | null = null;
  usage: string | null = null;
  story: string[] | null = null;
  notice: string | null = null;
}

export class IdiomSource {
  text: string | null = null;
  book: string | null = null;
}

export class IdiomQuote {
  text: string | null = null;
  book: string | null = null;
}

export class IdiomExample {
  text: string | null = null;
  book: string | null = null;
}