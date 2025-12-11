import { ThemeConst } from 'constants';
import { Link } from '../model/Link';
import { common, Want } from '@kit.AbilityKit';
import { Logger } from 'utils';

let logger: Logger = new Logger('LinkIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local links: Link[] = new Array(
    new Link(
      "智慧中小学",
      "国家中小学智慧教育平台",
      "https://basic.smartedu.cn/"
    ),
    new Link(
      "鲁迅博物馆",
      "鲁迅说过这话吗？",
      "http://www.luxunmuseum.com.cn/cx/"
    ),
    new Link(
      "中国大百科全书",
      "第三版网络版",
      "https://www.zgbk.com"
    ),
  )

  build() {
    NavDestination() {
      Grid() {
        ForEach(this.links, (item: Link) => {
          GridItem() {
            Card({ link: item })
          }
        }, (item: Link) => item.title)
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .columnsTemplate('1fr 1fr')
      .rowsGap(16)
      .columnsGap(16)
    }
    .title('链接')
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}

@ComponentV2
struct Card {
  @Param @Require link: Link;

  build() {
    Column() {
      Text(this.link.title)
        .width('100%')
      Text(this.link.title)
        .width('100%')
        .margin({ top: 16 })
        .fontSize(12)
        .fontColor($r('sys.color.ohos_fa_text_secondary'))
    }
    .width('100%')
    .padding(16)
    .borderRadius(12)
    .stateStyles({
      normal: {
        .backgroundColor(ThemeConst.CardBackGroundColor_Normal)
      },
      clicked: {
        .backgroundColor(ThemeConst.CardBackGroundColor_Pressed)
      }
    })
    .onClick(() => {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let wantInfo: Want = {
        "action": 'ohos.want.action.viewData',
        "entities": ['entity.system.browsable'],
        "uri": this.link.url,
      }
      context.startAbility(wantInfo).then(() => {
        logger.info('打开链接成功');
      }).catch((err: BusinessError) => {
        logger.error(`打开链接失败：code = ${err.code}, message = ${err.message}`);
      })
    })
  }
}
