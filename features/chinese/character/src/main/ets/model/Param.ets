export class SearchParam {
  type: string;
  data: string;

  constructor(type: string, data: string) {
    this.type = type;
    this.data = data;
  }
}

export class ShowParam {
  id: number;

  constructor(id: number) {
    this.id = id;
  }
}