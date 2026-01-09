import { BusinessError } from '@kit.BasicServicesKit';
import Dataset from '../model/Dataset';
import { DataWrapper, httpRequestGet, Logger, ResponseResult } from 'utils';
import { NetworkConst } from 'constants';
import { insertWorldCulturalHeritage, WorldCulturalHeritage } from 'china_worldcultureheritage';
import { AntitheticalCouplet, insertAntitheticalCouplet } from 'chinese_antitheticalcouplet';
import { Character, insertCharacter } from 'chinese_character';
import { Expression, insertExpression } from 'chinese_expression';
import { Idiom, insertIdiom } from 'chinese_idiom';
import { insertKnowledge, Knowledge } from 'chinese_knowledge';
import { insertQuote, Quote, } from 'chinese_quote';
import { ClassicPoem, insertClassicPoem } from 'classicalliterature_classicpoem';
import { insertSentence, Sentence } from 'classicalliterature_sentence';
import { People } from 'classicalliterature_people';
import { Writing } from 'classicalliterature_writing';
import { Lyric } from 'chinese_lyric';
import { ModernPoetry } from 'chinese_poetry';
import { Proverb } from 'chinese_proverb';
import { Riddle } from 'chinese_riddle';
import { Wisecrack } from 'chinese_wisecrack';
import { TongueTwister } from 'chinese_tonguetwister';

class DatasetViewModel {
  private logger: Logger = new Logger('DatasetViewModel');

  getDatasetList(): Promise<Dataset[]> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.DATASET}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          resolve(JSON.parse(result.data as string) as Dataset[])
        } else {
          this.logger.error(result.msg)
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(error)
        reject(error)
      })
    })
  }

  getClassicalLiteratureClassicPoemList(version: number, page: number): Promise<DataWrapper<ClassicPoem>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CLASSICALLITERATURE_CLASSICPOEM}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<ClassicPoem> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getClassicalLiteratureClassicPoemList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertClassicalLiteratureClassicPoemToDb(obj: ClassicPoem) {
    await insertClassicPoem(obj).catch((error: BusinessError) => {
      this.logger.error(`insertClassicalLiteratureClassicPoemToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getClassicalLiteraturePeopleList(version: number, page: number): Promise<DataWrapper<People>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CLASSICALLITERATURE_PEOPLE}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg == null) {
          let wrapper: DataWrapper<People> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getClassicalLiteraturePeopleList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getClassicalLiteratureSentenceList(version: number, page: number): Promise<DataWrapper<Sentence>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CLASSICALLITERATURE_SENTENCE}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Sentence> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getClassicalLiteratureSentenceList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertClassicalLiteratureSentenceToDb(obj: Sentence) {
    await insertSentence(obj).catch((error: BusinessError) => {
      this.logger.error(`insertClassicalLiteratureSentenceToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getClassicalLiteratureWritingList(version: number, page: number): Promise<DataWrapper<Writing>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL3}${NetworkConst.CLASSICALLITERATURE_WRITING}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg == null) {
          let wrapper: DataWrapper<Writing> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getClassicalLiteraturePeopleList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChineseAntitheticalCoupletList(version: number, page: number): Promise<DataWrapper<AntitheticalCouplet>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_ANTITHETICALCOUPLET}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<AntitheticalCouplet> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseAntitheticalCoupletList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChineseAntitheticalCoupletToDb(obj: AntitheticalCouplet) {
    await insertAntitheticalCouplet(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChineseAntitheticalCoupletToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseCharacterList(version: number, page: number): Promise<DataWrapper<Character>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_CHARACTER}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Character> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseCharacterList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChineseCharacterToDb(obj: Character) {
    await insertCharacter(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChineseCharacterToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseExpressionList(version: number, page: number): Promise<DataWrapper<Expression>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_EXPRESSION}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Expression> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseExpressionList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChineseExpressionToDb(obj: Expression) {
    await insertExpression(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChineseExpressionToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseIdiomList(version: number, page: number): Promise<DataWrapper<Idiom>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_IDIOM}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Idiom> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseIdiomList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChineseIdiomToDb(obj: Idiom) {
    await insertIdiom(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChineseIdiomToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseKnowledgeList(version: number, page: number): Promise<DataWrapper<Knowledge>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_KNOWLEDGE}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Knowledge> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseKnowledgeList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChineseKnowledgeToDb(obj: Knowledge) {
    await insertKnowledge(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChineseKnowledgeToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseLyricList(version: number, page: number): Promise<DataWrapper<Lyric>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_LYRIC}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Lyric> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseLyricList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChineseModernPoetryList(version: number, page: number): Promise<DataWrapper<ModernPoetry>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_MODERNPOETRY}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<ModernPoetry> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseModernPoetryList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChineseProverbList(version: number, page: number): Promise<DataWrapper<Proverb>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_PROVERB}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Proverb> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseProverbList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChineseQuoteList(version: number, page: number): Promise<DataWrapper<Quote>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_QUOTE}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Quote> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseQuoteList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChineseQuoteToDb(obj: Quote) {
    await insertQuote(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChineseQuoteToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }

  getChineseRiddleList(version: number, page: number): Promise<DataWrapper<Riddle>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_RIDDLE}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Riddle> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseRiddleList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChineseRTongueTwisterList(version: number, page: number): Promise<DataWrapper<TongueTwister>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_TONGUETWISTER}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<TongueTwister> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseRTongueTwisterList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChineseWisecrackList(version: number, page: number): Promise<DataWrapper<Wisecrack>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINESE_WISECRACK}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<Wisecrack> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChineseWisecrackList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  getChinaWorldCulturalHeritageList(version: number, page: number): Promise<DataWrapper<WorldCulturalHeritage>> {
    return new Promise((resolve: Function, reject: Function) => {
      let url = `${NetworkConst.BASE_URL1}${NetworkConst.CHINA_WORLDCULTUREHERITAGE}_v${version}_${page}.json`;
      httpRequestGet(url).then((result: ResponseResult) => {
        if (result.msg === null) {
          let wrapper: DataWrapper<WorldCulturalHeritage> = JSON.parse(result.data as string)
          resolve(wrapper)
        } else {
          reject(result.msg)
        }
      }).catch((error: string) => {
        this.logger.error(`getChinaWorldCulturalHeritageList failed, error = ${error}`)
        reject(error)
      })
    })
  }

  async insertChinaWorldCulturalHeritageToDb(obj: WorldCulturalHeritage) {
    await insertWorldCulturalHeritage(obj).catch((error: BusinessError) => {
      this.logger.error(`insertChinaWorldCulturalHeritageToDb error, code = :${error.code}, message = ${error.message}`)
    })
  }
}


let datasetViewModel = new DatasetViewModel()

export default datasetViewModel as DatasetViewModel