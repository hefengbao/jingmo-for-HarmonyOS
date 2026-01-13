let localStorageSentence = new LocalStorage();

@Entry(localStorageSentence)
@Component
struct ClassicalLiteratureSentenceCard {
  /*
   * The title.
   */
  readonly title: string = '诗文名句';
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
  @LocalStorageProp("content") content: string = '荆溪白石出\n天寒红叶稀';
  @LocalStorageProp("from") from: string = '王维《山中》';

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
            Text(`——${this.from}`)
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