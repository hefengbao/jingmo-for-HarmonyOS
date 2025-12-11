import { BusinessError } from '@kit.BasicServicesKit';
import Dataset from '../model/Dataset';
import { DataWrapper, httpRequestGet, Logger, ResponseResult } from 'utils';
import { NetworkConst } from 'constants';
import { insertWorldCulturalHeritage, WorldCulturalHeritage } from 'china_worldcultureheritage';
import { AntitheticalCouplet, insertAntitheticalCouplet } from 'chinese_antitheticalcouplet';
import { Character, insertCharacter } from 'chinese_character';
import { insertExpression, Expression } from 'chinese_expression';
import { insertIdiom, Idiom } from 'chinese_idiom';
import { insertKnowledge, Knowledge } from 'chinese_knowledge';
import { insertQuote, Quote, } from 'chinese_quote';
import { ClassicPoem, insertClassicPoem } from 'classicalliterature_classicpoem';
import { insertSentence, Sentence } from 'classicalliterature_sentence';

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

  async batchInsertChineseExpressionToDb(objs: Expression[]) {
    await this.batchInsertChineseExpressionToDb(objs).catch((error: BusinessError) => {
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