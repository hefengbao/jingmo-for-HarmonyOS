@ComponentV2
export struct BlockItem {
  @Param @Require title: string

  build() {
    Text(this.title)
      .width('100%')
      .fontFamily('HarmonyHeiTi')
      .textAlign(TextAlign.Center)
      .padding(16)
      .backgroundColor('#F1F3F5')
      .borderRadius(16)
  }
}

@ComponentV2
export struct BlockTitle {
  @Param @Require title: string

  build() {
    Text(this.title)
      .textAlign(TextAlign.Start)
      .fontColor(Color.Gray)
      .fontSize(14)
      .width('100%')
      .padding(8)
  }
}