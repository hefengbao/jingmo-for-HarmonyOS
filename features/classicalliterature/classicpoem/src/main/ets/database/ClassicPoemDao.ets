import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { ClassicPoem } from '../model/ClassicPoem';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';

import DbUtil from 'utils/src/main/ets/data/DbUtil';

export class ClassicPoemDao {
  logger: Logger = new Logger('ClassicPoemDao')

  async createClassicPoem(classicPoem: ClassicPoem) {
    const valuesBucket: relationalStore.ValuesBucket = {
      'id': classicPoem.id,
      'dynasty': classicPoem.dynasty,
      'writer': classicPoem.writer,
      'writer_introduction': classicPoem.writer_introduction,
      'title': classicPoem.title,
      'subtitle': classicPoem.subtitle,
      'preface': classicPoem.preface,
      'content': classicPoem.content,
      'annotation': classicPoem.annotation,
      'translation': classicPoem.translation,
      'creative_background': classicPoem.creative_background,
      'explain': classicPoem.explain,
      'comment': classicPoem.comment,
      'collection': classicPoem.collection,
      'category': classicPoem.category,
    }

    DbUtil.objectiveRDB?.insert(
      DbTableConst.CLASSICALLITERATURE_CLASSICPOEM_TABLE,
      valuesBucket,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((rowId: number) => {
      this.logger.info(`Insert is successful, rowId = ${rowId}`)
    }).catch((err: BusinessError) => {
      this.logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
    })
  }

  async readRandomClassicPoem(): Promise<ClassicPoem | null> {
    let classicPoem: ClassicPoem | null = null

    await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CLASSICALLITERATURE_CLASSICPOEM)
      .then((resultSet: relationalStore.ResultSet) => {
        try {
          while (resultSet.goToNextRow()) {
            let temp: ClassicPoem = new ClassicPoem(
              resultSet.getLong(resultSet.getColumnIndex('id')),
              resultSet.getString(resultSet.getColumnIndex('dynasty')),
              resultSet.getString(resultSet.getColumnIndex('writer')),
              resultSet.getString(resultSet.getColumnIndex('writer_introduction')),
              resultSet.getString(resultSet.getColumnIndex('title')),
              resultSet.getString(resultSet.getColumnIndex('subtitle')),
              resultSet.getString(resultSet.getColumnIndex('preface')),
              resultSet.getString(resultSet.getColumnIndex('content')),
              resultSet.getString(resultSet.getColumnIndex('annotation')),
              resultSet.getString(resultSet.getColumnIndex('translation')),
              resultSet.getString(resultSet.getColumnIndex('creative_background')),
              resultSet.getString(resultSet.getColumnIndex('explain')),
              resultSet.getString(resultSet.getColumnIndex('comment')),
              resultSet.getString(resultSet.getColumnIndex('collection')),
              resultSet.getString(resultSet.getColumnIndex('category')),
            )

            classicPoem = temp
            return
          }
        } catch (error) {
          let err = error as BusinessError
          this.logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
        }

        return classicPoem;

      }).catch((err: BusinessError) => {
        this.logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      });

    return classicPoem;
  }
}

export default new ClassicPoemDao()