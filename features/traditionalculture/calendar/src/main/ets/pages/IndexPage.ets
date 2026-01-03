import { AppStorageV2 } from '@kit.ArkUI';
import { AvoidAreaObserver, Icon, String, ThemeConst } from 'constants';
import { BoldTitle } from 'uicomponents';
import { RabByungYear, SolarDay, SolarYear, Taboo } from 'tyme4oh';
import { Logger } from 'utils/src/main/ets/log/Logger';

let logger = new Logger('Calendar')

@Builder
export function IndexPageBuilder() {
  IndexPage()
}

@ComponentV2
export struct IndexPage {
  @Consumer('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @Local avoidAreaObserver: AvoidAreaObserver =
    AppStorageV2.connect<AvoidAreaObserver>(AvoidAreaObserver, () => new AvoidAreaObserver())!;
  @Local now: Date = new Date();
  @Local solarDay: SolarDay = SolarDay.fromYmd(this.now.getFullYear(), this.now.getMonth() + 1, this.now.getDate());
  @Local solarYear: SolarYear = SolarYear.fromYear(this.now.getFullYear());
  @Local rabByungYear: RabByungYear = RabByungYear.fromYear(this.now.getFullYear())

  build() {
    NavDestination() {
      List() {
        ListItem() {
          BoldTitle({ text: "阳历" })
        }

        ListItem() {
          Row({ space: 16 }) {
            Text(`${this.now.getFullYear()}-${this.now.getMonth() + 1}-${this.now.getDate()}`)
            Text(`${this.solarDay.getConstellation().getName()}座`)
            Text(`星期${this.solarDay.getWeek().getName()}`)
            if (this.solarYear.isLeap()) {
              Text('闰年')
                .fontColor(Color.Orange)
            }
          }
          .padding(ThemeConst.P_X16_Y8)
        }

        ListItem() {
          if (this.solarDay.getFestival()) {
            Text(`节日：${this.solarDay.getFestival()?.getName()}}`)
              .padding(ThemeConst.P_X16_Y8)
          }
        }

        ListItem() {
          BoldTitle({ text: "阴历" })
        }

        ListItem() {
          Text(`${this.solarDay.getLunarDay()}`)
            .padding(ThemeConst.P_X16_Y8)
        }

        ListItem() {
          Row() {
            BoldTitle({ text: "宜", fontColor: Color.Green.toString() })
            ForEach(this.solarDay.getLunarDay().getRecommends(), (item: Taboo) => {
              Text(`${item.getName()}${item.getIndex()}${item.getSize()}`)
            })
            if (this.solarDay.getLunarDay().getRecommends()) {
              Text(`${this.solarDay.getLunarDay().getRecommends()}`)
            }
            Text(`${this.solarDay.getLunarDay()
              .getRecommends()
              .map((item: Taboo) => {
                return item.getIndex()
              })
              .join('')}}`)
          }
        }

        ListItem() {
          Row() {
            BoldTitle({ text: "忌", fontColor: Color.Red.toString() })
            Text(`${this.solarDay.getLunarDay()
              .getAvoids()
              .map((item: Taboo) => {
                return item.getName()
              })
              .join('')}}`)
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: this.avoidAreaObserver.navigation?.bottomRect.height
      })
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.TopStart)
    }
    .title(String.traditionalculture_calendar)
    .menus([
      {
        value: String.calendar,
        icon: Icon.ic_public_calendar,
        action: (() => {
          CalendarPickerDialog.show({
            selected: this.now,
            acceptButtonStyle: {
              fontColor: '#2787d9',
              fontSize: '16fp',
              borderRadius: 10
            },
            cancelButtonStyle: {
              fontColor: Color.Red,
              fontSize: '16fp',
              borderRadius: 10
            },
            onAccept: (date: Date) => {
              // 当弹出框再次弹出时显示选中的是上一次确定的日期
              this.now = date;
              this.solarDay = SolarDay.fromYmd(this.now.getFullYear(), this.now.getMonth() + 1, this.now.getDate());
              this.solarYear = SolarYear.fromYear(this.now.getFullYear());
            }
          })
        })
      }
    ])
    .onReady((ctx: NavDestinationContext) => {
      this.pageStack = ctx.pathStack;
    })
  }
}
