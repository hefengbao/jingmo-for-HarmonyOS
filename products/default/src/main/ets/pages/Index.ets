@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Navigation(){
      Scroll(){
        Grid(){
          GridItem(){
            Text('古诗文')
          }
          .columnStart(0)
          .columnEnd(1)

          GridItem(){
            Text('经典诗文')
          }

          GridItem(){
            Text('诗文名句')
          }
        }
        .width('100%')
        .height('100%')
        .columnsGap(10)
        .rowsGap(15)
        .columnsTemplate('1fr 1fr')
      }
    }
  }
}

@Preview
@Component
struct Item{
  @State title: string = '古诗文'

  build() {
    Text(this.title)
      .width('100%')
      .fontFamily('HarmonyHeiTi')
      .fontSize(24)
      .fontColor(Color.White)
      .textAlign(TextAlign.Center)
      .padding(16)
      .backgroundColor(Color.Black)
  }
}