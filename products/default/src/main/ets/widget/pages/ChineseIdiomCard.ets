let localStorageIdiom = new LocalStorage();

@Entry(localStorageIdiom)
@Component
struct ChineseIdiomCard {
  /*
   * The title.
   */
  readonly title: string = '成语';
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
  @LocalStorageProp("word") word: string = "返躬内省";
  @LocalStorageProp("pinyin") pinyin: string = "fǎn gōng nèi xǐng";
  @LocalStorageProp("explanation") explanation: string = "躬：自身；省：检查，反省。回过头来检查自己的过失。";

  build() {
    Row() {
      Column({ space: 8 }) {
        Text(this.pinyin)
          .fontSize($r('app.float.title_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font'))
        Text(this.word)
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font'))
        Text(this.explanation)
          .fontSize($r('app.float.font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font'))
      }
      .width(this.fullWidthPercent)
      .padding(16)
      .alignItems(HorizontalAlign.Start)
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