export class Stroke {
  label: string;
  stroke: number;

  constructor(label: string, stroke: number) {
    this.label = label;
    this.stroke = stroke;
  }
}

export function getStokeList(): Stroke[] {
  let stokeList: Stroke[] = new Array<Stroke>(
    new Stroke("一画", 1),
    new Stroke("二画", 2),
    new Stroke("三画", 3),
    new Stroke("四画", 4),
    new Stroke("五画", 5),
    new Stroke("六画", 6),
    new Stroke("七画", 7),
    new Stroke("八画", 8),
    new Stroke("九画", 9),
    new Stroke("十画", 10),
    new Stroke("十一画", 11),
    new Stroke("十二画", 12),
    new Stroke("十三画", 13),
    new Stroke("十四画", 14),
    new Stroke("十五画", 15),
    new Stroke("十六画", 16),
    new Stroke("十七画", 17),
    new Stroke("十八画", 18),
    new Stroke("十九画", 19),
    new Stroke("二十画", 20),
    new Stroke("二十一画", 21),
    new Stroke("二十二画", 22),
    new Stroke("二十三画", 23),
    new Stroke("二十四画", 24),
    new Stroke("二十五画", 25),
    new Stroke("二十六画", 26),
    new Stroke("二十七画", 27),
    new Stroke("二十八画", 28),
    new Stroke("二十九画", 29),
    new Stroke("三十画", 30),
    new Stroke("三十一画", 31),
    new Stroke("三十二画", 32),
    new Stroke("三十三画", 33),
    new Stroke("三十四画", 34),
    new Stroke("三十五画", 35),
    new Stroke("三十六画", 36),
    new Stroke("三十九画", 39),
    new Stroke("五十一画", 51),
  )

  return stokeList;
}