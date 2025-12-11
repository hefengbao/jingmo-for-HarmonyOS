import { ParamNumberId, ThemeConst } from 'constants';
import { Logger } from 'utils';
import {
  Character,
  searchCharacterByChar,
  searchCharacterByRadical,
  searchCharacterByStroke,
  searchCharacterByTone
} from '../model/Character';
import { SearchParam } from '../model/Param';

@Builder
export function SearchListPageBuilder() {
  SearchListPage();
}

let logger: Logger = new Logger('SearchListPage')

@ComponentV2
export struct SearchListPage {
  @Consumer("NavPathStack") pageStack: NavPathStack = new NavPathStack();
  @Local characters: Character[] = [];
  @Local showLoading: boolean = false;

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          if (this.showLoading) {
            LoadingProgress()
              .width(80)
              .height(80)
              .color(Color.Black)
          }
          Grid() {
            ForEach(this.characters, (item: Character) => {
              GridItem() {
                Text(item.character)
                  .width('100%')
                  .padding(ThemeConst.P_16)
                  .textAlign(TextAlign.Center)
                  .stateStyles({
                    normal: {
                      .backgroundColor(ThemeConst.BackGroundColor_Normal)
                    },
                    clicked: {
                      .backgroundColor(ThemeConst.BackGroundColor_Pressed)
                    }
                  })
                  .onClick(() => {
                    this.pageStack.pushPathByName('CharacterShowPage', new ParamNumberId(item.id))
                  })
              }
            }, (item: Character) => item.id.toString(),)
          }
          .width('100%')
          .padding(ThemeConst.P_16)
          .columnsGap(12)
          .rowsGap(12)
          .columnsTemplate('1fr 1fr 1fr')
          .edgeEffect(EdgeEffect.None)
        }
      }
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title('查询结果列表')
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
      let param = ctx.pathInfo.param as SearchParam
      if (param) {
        this.search(param)
      }
    })
  }

  search(param: SearchParam) {
    logger.info(`search type = ${param.type}, data = ${param.data}`)
    this.showLoading = true;
    if (param.type == 'char') { // 汉字
      searchCharacterByChar(param.data).then((value: Character[]) => {
        this.characters = value;
        this.showLoading = false;
      })
    } else if (param.type == 'radical') { //部首
      searchCharacterByRadical(param.data).then((value: Character[]) => {
        this.characters = value;
        this.showLoading = false;
      })
    } else if (param.type == 'stroke') { // 笔画
      searchCharacterByStroke(Number(param.data)).then((value: Character[]) => {
        this.characters = value;
        this.showLoading = false;
      })
    } else if (param.type == 'tone') { //拼音
      searchCharacterByTone(param.data).then((value: Character[]) => {
        this.characters = value;
        this.showLoading = false;
      })
    }
  }
}