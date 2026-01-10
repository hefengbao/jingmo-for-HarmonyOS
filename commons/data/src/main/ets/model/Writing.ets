export class Clause {
  Content: string;
  Comments: Comment[] | null;
  BreakAfter: number | null;

  constructor(Content: string, Comments: Comment[] | null, BreakAfter: number | null) {
    this.Content = Content;
    this.Comments = Comments;
    this.BreakAfter = BreakAfter;
  }
}

export class Comment {
  Category: string | null;
  Content: string;
  Type: string;
  Index: number;

  constructor(Category: string | null, Content: string, Type: string, Index: number) {
    this.Category = Category;
    this.Content = Content;
    this.Type = Type;
    this.Index = Index;
  }
}