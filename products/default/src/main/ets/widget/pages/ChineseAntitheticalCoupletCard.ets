let localStorageAntitheticalCouplet = new LocalStorage();

@Entry(localStorageAntitheticalCouplet)
@Component
struct ChineseAntitheticalCoupletCard {
  /*
   * The title.
   */
  readonly title: string = '对联';
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
  @LocalStorageProp("body") body: string = '升官发财 请走别路\n贪生怕死 莫入此门';

  build() {
    Row() {
      List() {
        ListItem(){
          Column({space:8}){
            Text(this.body)
              .fontSize($r('app.float.font_size'))
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