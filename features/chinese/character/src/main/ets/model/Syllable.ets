export class Syllable {
  alphabet: string;
  pronunciations: Pronunciation[];

  constructor(alphabet: string, pronunciations: Pronunciation[]) {
    this.alphabet = alphabet;
    this.pronunciations = pronunciations;
  }
}

export class Pronunciation {
  pinyin: string;
  tones: string[];

  constructor(pinyin: string, tones: string[]) {
    this.pinyin = pinyin;
    this.tones = tones;
  }
}