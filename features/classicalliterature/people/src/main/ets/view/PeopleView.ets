import { BoldTitle, ContentText } from 'uicomponents';
import { Alias, Detail, Hometown, People } from '../model/People';

@ComponentV2
export struct PeopleView {
  @Param @Require people: People;

  build() {
    Column() {
      ContentText({ text: this.people.Name })
      BoldTitle({ text: '生卒年月' })
      ContentText({ text: parseBirthDeath(this.people) })
      BoldTitle({ text: '主要生活朝代' })
      ContentText({ text: this.people.Dynasty })
      if (this.people.Aliases) {
        BoldTitle({ text: '别称' })
        ContentText({ text: parseAliases(this.people.Aliases) })
      }
      if (this.people.Titles) {
        BoldTitle({ text: '标签' })
        ContentText({ text: this.people.Titles.join('、') })
      }
      if (this.people.Hometown) {
        BoldTitle({ text: '家乡' })
        ContentText({
          text: this.people.Hometown.map((hometown: Hometown) => {
            return hometown.Name
          }).join('、')
        })
      }
      if (this.people.Details) {
        BoldTitle({ text: '人物资料' })
        ForEach(this.people.Details, (detail: Detail) => {
          ContentText({ text: `📖 ${detail.Book}` })
          if (detail.Content) {
            ContentText({
              text: detail.Content.replace("<br />", "\n")
                .replace("</p>", "\n")
                .replace(new RegExp("<[^>]+>"), "")
            })
          }
        })
      }
    }
    .width('100%')
    .align(Alignment.TopStart)
  }
}

function parseBirthDeath(people: People): string {
  let str = '';

  if (people.BirthYear) {
    if (Number(people.BirthYear) < 0) {
      str += `公元前${Math.abs(Number(people.BirthYear))}年`
    } else {
      str += `公元${people.BirthYear}年`
    }
    if (people.BirthDay) {
      if (people.BirthDay.search('月')) {
        str += people.BirthDay;
      } else {
        let arr = people.BirthDay.split("/")
        if (arr.length == 2) {
          str += `${arr[0]}月${arr[1]}日`
        }
      }
    }
  } else {
    str += '?'
  }

  str += ' - '

  if (people.DeathYear) {
    if (Number(people.DeathYear) < 0) {
      str += `公元前${Math.abs(Number(people.DeathYear))}年`
    } else {
      str += `公元${people.DeathYear}年`
    }
    if (people.DeathDay) {
      if (people.DeathDay.search('月')) {
        str += people.DeathDay;
      } else {
        let arr = people.DeathDay.split("/")
        if (arr.length == 2) {
          str += `${arr[0]}月${arr[1]}日`
        }
      }
    }
  } else {
    str += '?'
  }

  return str;
}

function parseAliases(aliases: Alias[]): string {
  return aliases.map((alias: Alias) => {
    let type = '其他';
    switch (alias.Type) {
      case "BieCheng":
        type = "别称"
        break;
      case "Xing":
        type = "姓";
        break;
      case "Zi":
        type = "字";
        break;
      case "Hao":
        type = "号";
        break;
      case "Ming":
        type = "名";
        break;
      case "ShiHao":
        type = "谥号";
        break;
      case "FengJue":
        type = "封号";
        break;
      case "FamousName":
        type = "世称";
        break;
      case "PreUsedName":
        type = "曾用名";
        break;
      case "XingMing":
        type = "姓名";
        break;
    }

    return `${type}：${alias.Name}`
  }).join(' ')
}