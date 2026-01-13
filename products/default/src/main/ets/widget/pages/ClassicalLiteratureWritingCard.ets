let localStorageWriting = new LocalStorage();

@Entry(localStorageWriting)
@Component
struct ClassicalLiteratureWritingCard {
  /*
   * The title.
   */
  //readonly title: string = '诗文名句';
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
  @LocalStorageProp("title") title: string = '登幽州台歌';
  @LocalStorageProp("author") author: string = '陈子昂';
  @LocalStorageProp("content") content: string = '前不见古人，后不见来者。\n' +
    '念天地之悠悠，独怆然而涕下。';

  build() {
    Row() {
      List() {
        ListItem(){
          Column({space:8}){
            Text(this.title)
              .fontSize($r('app.float.font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font'))
            Text(this.author)
              .fontSize($r('app.float.title_font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font'))
            Text(this.content)
              .fontSize($r('app.float.font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font'))
          }
          .width('100%')
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