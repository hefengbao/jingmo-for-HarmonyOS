import { ParamNumberId, String, ThemeConst } from 'constants';
import { readWorldCulturalHeritage, WorldCulturalHeritage } from '../model/WorldCulturalHeritage';
import { BoldTitle, ContentText } from 'uicomponents';
import { webview } from '@kit.ArkWeb';
import { HtmlStringParse } from '../model/HtmlStringParse';
import { Logger } from 'utils';

let logger: Logger = new Logger('WorldCulturalHeritageShowPage');

@Builder
export function ShowPageBuilder() {
  ShowPage();
}

@ComponentV2
export struct ShowPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local worldCulturalHeritage: WorldCulturalHeritage | null = null;
  @Local webviewController: webview.WebviewController = new webview.WebviewController

  build() {
    NavDestination() {
      Scroll() {
        if (this.worldCulturalHeritage) {
          Column() {
            Text(this.worldCulturalHeritage.name)
              .padding(ThemeConst.P_X16_Y8)
              .fontSize(24)
            Text(`#${this.worldCulturalHeritage.type}`)
              .padding(ThemeConst.P_X16_Y8)
              .fontColor(Color.Gray)
              .fontSize(ThemeConst.FontSize_14)

            BoldTitle({ text: '遗产分布' })
            ContentText({ text: this.worldCulturalHeritage.address })

            BoldTitle({ text: '列入标准' })
            ContentText({ text: this.worldCulturalHeritage.level })

            BoldTitle({ text: '列入时间' })
            ContentText({ text: this.worldCulturalHeritage.year })

            if (this.worldCulturalHeritage.year2) {
              BoldTitle({ text: '扩展时间' })
              ContentText({ text: this.worldCulturalHeritage.year2 })
            }

            BoldTitle({ text: '遗产介绍' })
            ForEach(this.parseHtmlString(this.worldCulturalHeritage.content),
              (item: HtmlStringParse) => {
                if (item.type == 'p') {
                  ContentText({ text: item.text })
                } else if (item.type == 'em') {
                  Text(item.text)
                    .padding(ThemeConst.PX_16)
                    .fontSize(12)
                    .fontColor(Color.Gray)
                    .fontStyle(FontStyle.Italic)
                } else if (item.type == 'img') {
                  Image(item.text)
                    .padding(ThemeConst.P_X16_Y8)
                }
              }, (index: number) => `${index}`)
          }
          .width('100%')
          .padding(ThemeConst.P_16)
          .alignItems(HorizontalAlign.Start)
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.china_worldcultureheritage)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as ParamNumberId;
      if (param) {
        readWorldCulturalHeritage(param.id).then((value: WorldCulturalHeritage | null) => {
          this.worldCulturalHeritage = value
        })
      }
    })
  }

  parseHtmlString(htmlString: string): HtmlStringParse[] {
    let regex = /<p>(.*?)<\/p>/g;
    let matches: RegExpExecArray | null = null;
    let paragraphs: HtmlStringParse[] = [];

    while ((matches = regex.exec(htmlString)) !== null) {
      // 将匹配到的文本内容添加到paragraphs数组中
      let temp = matches[1];
      logger.info(`parseHtmlString:${temp}`)
      if (temp.startsWith('<img')) {
        let temp2 = temp.split('"');
        paragraphs.push(
          new HtmlStringParse('img', temp2[1])
        );
        logger.info(`parseHtmlString img:${temp2[1]}`)
      } else if (temp.startsWith('<em>')) {
        paragraphs.push(
          new HtmlStringParse('em', temp.substring(4, temp.length - 5))
        );
        logger.info(`parseHtmlString em:${temp.substring(4, temp.length - 5)}`)
      } else {
        paragraphs.push(
          new HtmlStringParse('p', temp)
        );
        logger.info(`parseHtmlString p:${temp}`)
      }
    }
    logger.info(`parseHtmlString count:${paragraphs.length}`)
    return paragraphs;
  }
}
