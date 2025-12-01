import { ThemeConst } from 'constants';
import { BoldTitle } from 'uicomponents';
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
        Text('拼音：' + this.character.pinyin)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.character.radical) {
        Text('部首：' + this.character.radical)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.character.stroke) {
        Text('笔画：' + this.character.stroke)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.character.wubi) {
        Text('五笔：' + this.character.wubi)
          .width('100%')
          .padding(ThemeConst.P_X16_Y8)
      }
      if (this.character.explanations) {
        BoldTitle({ text: '简要释义' })
        ForEach(this.character.explanations, ((item: string) => {
          Text(item)
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            .lineHeight(24)
        }))
      }
      if (this.character.explanations2 && this.character.explanations2.length) {
        BoldTitle({ text: '详细释义' })
        ForEach(this.character.explanations2, ((item: ExplanationItem, index: number) => {
          if (this.parseContent(item, index)) {
            Column() {
              Text(this.parseContent(item, index))
                .width('100%')
                .padding(ThemeConst.P_X16_Y8)
                .lineHeight(24)
              Column() {
                if (item.refer) {
                  Text(`<参考> ${item.refer}`)
                    .width('100%')
                    .padding(ThemeConst.P_X16_Y8)
                    .lineHeight(24)
                }
                if (item.detail) {
                  ForEach(item.detail, (itemDetail: Detail) => {
                    Text(`<引> ${this.parseDetail(itemDetail)} `)
                      .width('100%')
                      .padding(ThemeConst.P_X16_Y8)
                      .lineHeight(24)
                  })
                }
                if (item.words) {
                  ForEach(item.words, (word: Word) => {
                    Text(`<词> ${this.parseWord(word)} `)
                      .width('100%')
                      .padding(ThemeConst.P_X16_Y8)
                      .lineHeight(24)
                  })
                }
                if (item.simplified) {
                  Text(`<简体> ${item.simplified} `)
                    .width('100%')
                    .padding(ThemeConst.P_X16_Y8)
                    .lineHeight(24)
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
      txt += `——《${detail.book}}》`
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