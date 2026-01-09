import { ParamNumberId, String, ThemeConst } from 'constants';
import { Logger } from 'utils';
import { getList, TongueTwister } from '../model/TongueTwister';

let logger: Logger = new Logger('TongueTwisterIndexPage');

@Builder
export function IndexPageBuilder() {
  IndexPage();
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local tongueTwisterList: TongueTwister[] = [];

  aboutToAppear(): void {
    getList().then((value: TongueTwister[]) => {
      this.tongueTwisterList.push(...value);
    })
  }

  build() {
    NavDestination() {
      List() {
        ForEach(this.tongueTwisterList, (item: TongueTwister) => {
          ListItem() {
            Column() {
              Text(item.title)
                .padding(ThemeConst.P_X16_Y8)
                .width('100%')
            }
            .width('100%')
            .onClick(() => {
              logger.info(`${item.id} clicked.`)
              this.pageStack.pushPathByName('TongueTwisterShowPage', new ParamNumberId(item.id))
            })
          }
        }, (item: TongueTwister) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
      .divider(ThemeConst.ListDivider)
    }
    .title(String.chinese_tonguetwister)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}