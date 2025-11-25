import dao from '../database/ClassicPoemDao';
import { ClassicPoem } from '../model/ClassicPoem';
import { Icon, String, ThemeConst } from 'constants';
import { BoldTitle, Content } from 'uicomponents';

@Builder
export function ClassicPoemIndexBuilder() {
  ClassicPoemIndex();
}

@ComponentV2
export struct ClassicPoemIndex {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local classicPoem: ClassicPoem | null = null;

  aboutToAppear(): void {
    this.refresh()
  }

  refresh() {
    dao.readRandomClassicPoem().then((value: ClassicPoem | null) => {
      this.classicPoem = value
    })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          if (this.classicPoem) {
            Text(this.classicPoem.title)
              .padding(ThemeConst.P_X16_Y8)
            Text(`【${this.classicPoem.dynasty}】${this.classicPoem.writer}`)
              .padding(ThemeConst.P_X16_Y8)
              .fontSize(ThemeConst.FontSize_14)
            if (this.classicPoem.preface) {
              Text(this.classicPoem.preface)
                .fontSize(ThemeConst.FontSize_14)
                .fontStyle(FontStyle.Italic)
                .padding(ThemeConst.P_X16_Y8)
            }
            Text(this.classicPoem.content)
              .padding(ThemeConst.P_X16_Y8)
              .lineHeight(24)
            if (this.classicPoem.annotation) {
              BoldTitle({ text: '注释' })
              Content({ text: this.classicPoem.annotation })
            }
            if (this.classicPoem.translation) {
              BoldTitle({ text: '译文' })
              Content({ text: this.classicPoem.translation })
            }
            if (this.classicPoem.creative_background) {
              BoldTitle({ text: '创作背景' })
              Content({ text: this.classicPoem.creative_background })
            }
            if (this.classicPoem.explain) {
              BoldTitle({ text: '赏析' })
              Content({ text: this.classicPoem.explain })
            }
            if (this.classicPoem.comment) {
              BoldTitle({ text: '点评' })
              Content({ text: this.classicPoem.comment })
            }
          }
        }
        .padding(16)
      }
    }
    .title(String.classicalliterature_classicpoem)
    .toolbarConfiguration([
      {
        "value": String.refresh,
        "icon": Icon.ic_public_refresh,
        "action": () => {
          this.refresh()
        }
      }
    ], {
      "hideItemValue": true
    })
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack
    })
  }
}
