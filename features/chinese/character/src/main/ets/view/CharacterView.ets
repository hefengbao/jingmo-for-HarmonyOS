import { ThemeConst } from 'constants';
import { BoldTitle, ContentText } from 'uicomponents';
import { Character, Detail, ExplanationItem, Word } from '../model/Character';

@ComponentV2
export struct CharacterView {
  @Param @Require character: Character;

  build() {
    Column() {
      Text(this.character.character)
        .width('100%')
        .padding(ThemeConst.P_X16_Y8)
        .fontWeight(FontWeight.Bold)
        .fontSize(24)
      if (this.character.pinyin) {
        ContentText({ text: '拼音：' + this.character.pinyin })
      }
      if (this.character.radical) {
        ContentText({ text: '部首：' + this.character.radical })
      }
      if (this.character.stroke) {
        ContentText({ text: '笔画：' + this.character.stroke })
      }
      if (this.character.wubi) {
        ContentText({ text: '五笔：' + this.character.wubi })
      }
      if (this.character.explanations) {
        BoldTitle({ text: '简要释义' })
        ForEach(this.character.explanations, ((item: string) => {
          ContentText({ text: item })
        }))
      }
      if (this.character.explanations2 && this.character.explanations2.length) {
        BoldTitle({ text: '详细释义' })
        ForEach(this.character.explanations2, ((item: ExplanationItem, index: number) => {
          if (this.parseContent(item, index)) {
            Column() {
              ContentText({ text: this.parseContent(item, index) })
              Column() {
                if (item.refer) {
                  ContentText({ text: `<参考> ${item.refer}` })
                }
                if (item.detail) {
                  ForEach(item.detail, (itemDetail: Detail) => {
                    ContentText({ text: `<引> ${this.parseDetail(itemDetail)}` })
                  })
                }
                if (item.words) {
                  ForEach(item.words, (word: Word) => {
                    ContentText({ text: `<词> ${this.parseWord(word)}` })
                  })
                }
                if (item.simplified) {
                  ContentText({ text: `<简体> ${item.simplified}` })
                }
              }
            }
            .width('100%')
          }
        }))
      }
    }
  }

  parseContent(item: ExplanationItem, index: number): string | null {
    if (!item.speech && !item.content) {
      return null;
    }

    let txt: string = `（${index + 1}）`;

    if (item.speech) {
      txt += `【${item.speech}】`
    }

    if (item.content) {
      txt += item.content
    }

    return txt;
  }

  parseDetail(detail: Detail): string {
    let txt = '';
    if ((detail.text)) {
      txt += detail.text;
    }
    if (detail.book) {
      txt += `—— ${detail.book}`
    }
    return txt;
  }

  parseWord(word: Word): string {
    let txt = '';
    if ((word.word)) {
      txt += word.word;
    }
    if (word.text) {
      txt += `：${word.text}`
    }
    return txt;
  }
}