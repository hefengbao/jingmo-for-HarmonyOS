import { AppConst, ThemeConst } from 'constants';

@Builder
export function AboutPageBuilder() {
  AboutPage()
}

@ComponentV2
export struct AboutPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local desc: string = `
『京墨』开源的中华文化阅读 APP。献给喜欢中华文字、文学、文化的人。

本应用使用的数据来自网络（主要是 Github 开源的仓库），可在项目仓库查看 README.md 中的说明。

源码仓库：

https://github.com/hefengbao/jingmo-for-HarmonyOS

https://gitee.com/hefengbao/jingmo-for-HarmonyOS

关注公众号『NowInLife』获取更新消息。

如果在使用过程中，遇到内容错误，欢迎在公众号留言说明，我们共同改进。

如果有人想要♥赞助♥本项目，可在公众号文章中赞赏👍。
  `;

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Text('❤贺丰宝（hefengbao）设计和编码❤')
            .width('100%')
            .padding(ThemeConst.PY_16)
          Text(this.desc)
            .width('100%')
            .padding(ThemeConst.PY_16)
            .copyOption(CopyOptions.InApp)
            .lineHeight(24)
          Text('公众号：NowInLife')
            .width('100%')
            .padding(ThemeConst.PY_16)
            .copyOption(CopyOptions.InApp)

          Hyperlink('https://beian.miit.gov.cn', `备案号：${AppConst.ICP}`)
            .width('100%')
            .padding(ThemeConst.PY_16)
            .color(Color.Gray)
        }
        .padding(ThemeConst.P_16)
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title($r('app.string.about'))
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}