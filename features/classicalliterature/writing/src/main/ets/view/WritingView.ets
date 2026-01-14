import { ThemeConst } from 'constants';
import { Clause } from 'data';
import { BoldTitle, ContentText } from 'uicomponents';
import { Quote, Writing } from '../model/Writing';

@Extend(Text)
function basicText() {
  .padding(ThemeConst.P_X16_Y8)
  .lineHeight('150%')
}

@ComponentV2
export struct WritingView {
  @Param @Require writing: Writing;

  build() {
    Column({ space: 8 }) {
      Column() {
        Text(this.writing.Title.Content)
          .basicText()
        Text(this.writing.Author)
          .basicText()
          .fontSize(12)
        if (this.writing.Preface) {
          Text(this.writing.Preface)
            .basicText()
            .fontSize(12)
        }
        Text() {
          ForEach(this.writing.Clauses, (clause: Clause) => {
            if (this.writing.Type != '文') {
              Span(`${clause.Content}\n`)
            } else {
              Span(`${clause.Content}`)
            }
            if (clause.BreakAfter) {
              Span('\n')
            }
          }, (clause: Clause) => clause.Content)
        }
        .basicText()
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      if (this.writing.Note) {
        BoldTitle({ text: "按语、作者自注、跋" })
        ContentText({ text: this.writing.Note })
      }
      if (this.writing.Comments) {
        BoldTitle({ text: '赏析（评价）' })
        ForEach(this.writing.Comments, (comment: Quote) => {
          if (comment.Book) {
            ContentText({ text: `📖 ${comment.Book}` })
          }
          if (comment.Section) {
            ContentText({ text: comment.Section })
          }
          if (comment.Content) {
            ContentText({
              text: comment.Content.replace("<br />", "\n")
                .replace("</p>", "\n")
                .replace("</div>", "\n")
                .replace(/<[^>]*>/g, "")
            })
          }
        })
      }
    }
    .padding({ top: 16, bottom: 16 })
  }
}

@ComponentV2
export struct SnapshotView {
  @Param @Require writing: Writing;
  @Param @Require fontSize: number;
  @Param @Require fontColor: string;

  build() {
    Column() {
      Text(this.writing.Title.Content)
        .basicText()
        .fontColor(this.fontColor)
        .fontSize(this.fontSize)
      Text(this.writing.Author)
        .basicText()
        .fontSize(12)
        .fontColor(this.fontColor)
      if (this.writing.Preface) {
        Text(this.writing.Preface)
          .basicText()
          .fontSize(12)
          .fontColor(this.fontColor)
      }
      Text() {
        ForEach(this.writing.Clauses, (clause: Clause) => {
          if (this.writing.Type != '文') {
            Span(`${clause.Content}\n`)
          } else {
            Span(`${clause.Content}`)
          }
          if (clause.BreakAfter) {
            Span('\n')
          }
        }, (clause: Clause) => clause.Content)
      }
      .basicText()
      .fontColor(this.fontColor)
      .fontSize(this.fontSize)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}