import { AppConst, Icon, ThemeConst } from 'constants';
import { ContentText } from 'uicomponents';
import { bundleManager } from '@kit.AbilityKit';

@Builder
export function AboutPageBuilder() {
  AboutPage()
}

@ComponentV2
export struct AboutPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local versionName: string = '';
  @Local desc: string = `
『京墨文库』开源的中华文化阅读 APP。献给喜欢中华文字、文学、文化的人。

本应用使用的数据来自网络（主要是 Github 开源的仓库），可在项目仓库查看 README.md 中的说明。

源码仓库：

https://github.com/hefengbao/jingmo-for-HarmonyOS

https://gitee.com/hefengbao/jingmo-for-HarmonyOS

关注公众号『NowInLife』获取更新消息。

如果在使用过程中，遇到内容错误，欢迎在公众号留言说明，我们共同改进。

如果有人想要♥赞助♥本项目，可在公众号文章中赞赏👍。
  `;

  aboutToAppear(): void {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).then((bundleInfo) => {
      this.versionName = bundleInfo.versionName; //应用版本名
      let versionNo = bundleInfo.versionCode; //应用版本号
    }).catch((error: BusinessError) => {
      console.error("get bundleInfo failed,error is " + error)
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Row() {
            Column() {
              Image(Icon.app_icon)
                .width(80)
                .height(80)
                .background(Color.White)
              Text(this.versionName)
                .margin({ top: 8 })
                .fontSize(14)
            }
          }
          .align(Alignment.Center)
          .margin({ bottom: 16 })

          ContentText({ text: '❤贺丰宝（hefengbao）设计和编码❤' })
          ContentText({ text: this.desc })
          ContentText({ text: '公众号：NowInLife' })
          Hyperlink('https://beian.miit.gov.cn', `备案号：${AppConst.ICP}`)
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            .color(Color.Gray)
        }
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