import { fileIo } from '@kit.CoreFileKit';
import { Pronunciation, Syllable } from '../model/Syllable';
import { Logger } from 'utils';
import util from '@ohos.util';
import { ThemeConst } from 'constants';
import { SearchParam } from '../model/Param';

let logger: Logger = new Logger('SyllablePage');

@Builder
export function SyllablePageBuilder() {
  SyllablePage()
}

@ComponentV2
export struct SyllablePage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local syllables: Syllable[] = [];
  @Local currentAlphabetIndex: number = 0;
  private alphabetScroller: Scroller = new Scroller();
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    try {
      let context = this.getUIContext().getHostContext();
      context?.resourceManager.getRawFileContent('syllables.json', (_err, value) => {
        if (_err) {
          logger.error('Failed to get raw file:' + _err);
          return;
        }
        let fileBuffer: ArrayBufferLike = value.buffer;
        // Obtain the application sandbox path for storing temporary files, and perform null checking
        let filePath = context!.filesDir + '/syllables.json';
        logger.info('testTag-filePath:' + filePath);
        let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
        let writeLen = fileIo.writeSync(file.fd, fileBuffer);
        logger.info('testTag-write data to file succeed and size is:' + writeLen);
        let text = util.TextDecoder.create('utf-8').decodeToString(new Uint8Array(fileBuffer))
        this.syllables = JSON.parse(text) as Syllable[]
        fileIo.closeSync(file);
      });
    } catch (error) {
      logger.error('Failed to get raw file:', error);
    }
  }

  alphabetChangeAction(index: number, isAlphabet: boolean): void {
    if (this.currentAlphabetIndex !== index) {
      //左侧点击
      this.currentAlphabetIndex = index;
      if (isAlphabet) {
        // 右侧联动
        this.scroller.scrollToIndex(index, true);
      } else {
        this.alphabetScroller.scrollToIndex(index, true);
      }
    }
  }

  build() {
    NavDestination() {
      Row() {
        List({ scroller: this.alphabetScroller }) {
          ForEach(this.syllables, (item: Syllable, index: number) => {
            ListItem() {
              Text(item.alphabet)
                .width('100%')
                .padding(ThemeConst.P_16)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .backgroundColor(this.currentAlphabetIndex == index ? ThemeConst.BackGroundColor_Normal : '')
                .onClick(() => {
                  this.alphabetChangeAction(index, true)
                })
            }
          }, (item: Syllable) => item.alphabet + this.currentAlphabetIndex)
        }
        .width(80)
        .height('100%')
        .backgroundColor(ThemeConst.CardBackGroundColor_Normal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.None)

        List({ scroller: this.scroller }) {
          ForEach(this.syllables, (item: Syllable) => {
            ListItemGroup() {
              ForEach(item.pronunciations, (pronunciation: Pronunciation) => {
                ListItem() {
                  Column() {
                    Text(pronunciation.pinyin)
                      .padding({
                        left: 32,
                        top: 8,
                        right: 32,
                        bottom: 8
                      })
                      .fontWeight(FontWeight.Bold)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                    Grid() {
                      ForEach(pronunciation.tones, (tone: string) => {
                        GridItem() {
                          Text(tone)
                            .padding(16)
                            .stateStyles({
                              normal: {
                                .backgroundColor(ThemeConst.BackGroundColor_Normal)
                              },
                              clicked: {
                                .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                              }
                            })
                            .onClick(() => {
                              this.pageStack.pushPathByName('CharacterSearchListPage', new SearchParam('tone', tone))
                            })
                        }
                      })
                    }
                    .padding(ThemeConst.P_16)
                    .columnsGap(12)
                    .rowsGap(12)
                    .columnsTemplate('1fr 1fr 1fr')
                  }
                }
              }, (pronunciation: Pronunciation) => pronunciation.pinyin)
            }
          }, (item: Syllable) => item.alphabet)
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.Spring)
        .onScrollIndex((start: number) => this.alphabetChangeAction(start, false))
      }
    }
    .title('拼音查询')
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}