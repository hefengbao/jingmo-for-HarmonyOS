import { ParamNumberId, String, ThemeConst } from 'constants';
import { Lyric } from '../model/Lyric';
import LyricViewModel from '../viewmodel/LyricViewModel';

@Builder
export function SearchPageBuilder() {
  SearchPage();
}

@ComponentV2
export struct SearchPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local lyrics: Lyric[] = [];

  build() {
    NavDestination() {
      List(){
        ListItem(){
          Column(){
            Search()
              .onSubmit((query) => {
                LyricViewModel.search(query).then((value: Lyric[]) => {
                  this.lyrics.length = 0;
                  this.lyrics.push(...value);
                })
              });
          }
          .padding(ThemeConst.P_X16_Y8)
        }
        ForEach(this.lyrics, (item: Lyric) => {
          ListItem(){
            Column({space: 16}){
              Text(item.title)
              Text(item.content)
                .maxLines(3)
                .textOverflow({overflow:TextOverflow.Ellipsis})
            }
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            .onClick(() => {
              this.pageStack.pushPathByName('LyricShowPage', new ParamNumberId(item.id))
            })
          }
        }, (item: Lyric) => item.id.toString())
      }
      .width('100%')
      .height('100%')
      .divider(ThemeConst.ListDivider)
      .edgeEffect(EdgeEffect.Spring)
    }
    .title(String.search)
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}