let localStorageQuote = new LocalStorage();

@Entry(localStorageQuote)
@Component
struct ChineseQuoteCard {
  /*
   * The title.
   */
  readonly title: string = '句子';
  /*
   * The action type.
   */
  readonly actionType: string = 'router';
  /*
   * The ability name.
   */
  readonly abilityName: string = 'EntryAbility';
  /*
   * The message.
   */
  readonly message: string = 'add detail';
  /*
   * The width percentage setting.
   */
  readonly fullWidthPercent: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent: string = '100%';
  @LocalStorageProp("content") content: string =
    '他的泪水在他脸上纵横交错地流，就像雨水打在窗玻璃上，就像裂缝爬上快要破碎的碗，就像蓬勃生长出去的树枝，就像渠水流进了田地，就像街道布满了城镇，泪水在他脸上织成了一张网。';
  @LocalStorageProp("author") author: string = '余华';
  @LocalStorageProp("from") from: string = '《许三观卖血记》';

  build() {
    Row() {
      List() {
        ListItem(){
          Column({space:8}){
            Text(this.content)
              .fontSize($r('app.float.font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font'))
              .width('100%')
            Text(`——${this.author}·${this.from}`)
              .fontSize($r('app.float.title_font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font'))
              .width('100%')
          }
        }
      }
      .width(this.fullWidthPercent)
      .padding(16)
    }
    .height(this.fullHeightPercent)
    .backgroundColor($r('sys.color.comp_background_primary'))
    .onClick(() => {
      postCardAction(this, {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.message
        }
      });
    })
  }
}