import { HomePage } from 'home';

@Entry
@ComponentV2
struct Index {
  @Local startLaunch: boolean = true;

  aboutToAppear(): void {
    setTimeout(() => {
      this.startLaunch = false
    }, 2000)
  }

  build() {
    if (this.startLaunch) {
      Start()
    } else {
      HomePage()
    }
  }
}

@ComponentV2
struct Start {
  build() {
    Text('献给\n\n喜欢中华文字、文学、文化的人')
      .width('100%')
      .height('100%')
      .fontSize(20)
      .textAlign(TextAlign.Center)
  }
}