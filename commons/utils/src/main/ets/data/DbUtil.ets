import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../log/Logger';
import { AppConst, DbConfigConst, DbCRUDConst, DbMigrationConst } from 'constants';

/**
 * 官方文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/data-persistence-by-rdb-store
 *
 */
export class DbUtil {
  objectiveRDB?: relationalStore.RdbStore;
  private logger: Logger = new Logger('RDBStoreUtil')

  init(context: Context) {
    this.getObjectiveRDB(context).then((rdbStore: relationalStore.RdbStore) => {
      let storeVersion: number = rdbStore.version;

      this.logger.info(`dbStore.version = ${storeVersion}`)

      // 数据表迁移(使用循环，确保可以跨版本升级)
      while (storeVersion < AppConst.DB_VERSION) {
        if (storeVersion == 0) {
          this.migration_0_1(rdbStore)
          storeVersion = 1
        }
        if (storeVersion == 1) {
          this.migration_1_2(rdbStore)
          storeVersion = 2
        }
        if (storeVersion == 2) {
          this.migration_2_3(rdbStore)
          storeVersion = 3
        }
      }

      rdbStore.version = storeVersion
    })
  }

  /*init(context: Context) {
    relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG,
      (error: BusinessError, rdbStore: relationalStore.RdbStore) => {
        //this.objectiveRDB = rdbStore
        if (!this.objectiveRDB) {
          this.objectiveRDB = rdbStore;
        }
        let storeVersion: number = rdbStore.version;
        if (error) {
          this.logger.error(`Get RdbStore failed, code is ${error.code},message is ${error.message}`)
          return;
        }
        this.logger.info('Get RdbStore successfully.')

        // 数据表迁移(使用循环，确保可以跨版本升级)
        while (storeVersion < AppConst.DB_VERSION) {
          if (storeVersion == 0) {
            this.migration_0_1(rdbStore)
            storeVersion = 1
          }
          if (storeVersion == 1) {
            this.migration_1_2(rdbStore)
            storeVersion = 2
          }
        }

        rdbStore.version = storeVersion
      })
  }*/

  async getObjectiveRDB(context: Context): Promise<relationalStore.RdbStore>{
    let dmImpl: relationalStore.RdbStore | undefined = undefined

    try {
      dmImpl = await relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG);
      if (!this.objectiveRDB) {
        this.objectiveRDB = dmImpl;
      }
      this.logger.info(`getObjectiveRDB success`);
    } catch (e) {
      // db 打开失败
      const err = e as BusinessError;
      this.logger.error(`Failed to getObjectiveRDB,code:${err.code}, message:${err.message}`);
    }

    return Promise.resolve(dmImpl!)
  }

  private async migration_0_1(rdbStore: relationalStore.RdbStore) {
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINA_WORLDCULTUREHERITAGE_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINA_WORLDCULTUREHERITAGE_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_CLASSICPOEM_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CLASSICALLITERATURE_CLASSICPOEM_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_SENTENCE_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CLASSICALLITERATURE_SENTENCE_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_ANTITHETICALCOUPLET_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_ANTITHETICALCOUPLET_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_CHARACTER_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_CHARACTER_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_EXPRESSION_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_EXPRESSION_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_IDIOM_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_IDIOM_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_KNOWLEDGE_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_KNOWLEDGE_TABLE Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_MODERNPOETRY_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_MODERNPOETRY_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_QUOTE_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_QUOTE_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_BOOKMARKS_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_BOOKMARKS_TABLE. Code:${err.code}, message:${err.message}`);
    }
  }

  private async migration_1_2(rdbStore: relationalStore.RdbStore) {
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_LYRIC_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_LYRIC_TABLE. Code:${err.code}, message:${err.message}`);
    }

    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_LYRIC_FTS_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_LYRIC_FTS_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_MODERNPOETRY_FTS_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_MODERNPOETRY_FTS_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_PROVERB_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_PROVERB_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_RIDDLE_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_RIDDLE_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_TONGUETWISTER_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_TONGUETWISTER_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CHINESE_WISECRACK_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CHINESE_WISECRACK_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CLASSICALLITERATURE_CLASSICPOEM_FTS_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbCRUDConst.INSERT_CLASSICALLITERATURE_CLASSICPOEM_FTS)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to INSERT_CLASSICALLITERATURE_CLASSICPOEM_FTS. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_PEOPLE_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CLASSICALLITERATURE_PEOPLE_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_WRITING_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CLASSICALLITERATURE_WRITING_TABLE. Code:${err.code}, message:${err.message}`);
    }
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_WRITING_FTS_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_CLASSICALLITERATURE_WRITING_FTS_TABLE. Code:${err.code}, message:${err.message}`);
    }
  }

  private async migration_2_3(rdbStore: relationalStore.RdbStore) {
    try {
      await rdbStore.execute(DbMigrationConst.CREATE_FORM_INFO_TABLE)
    } catch (e) {
      const err = e as BusinessError;
      this.logger.error(`Failed to CREATE_FORM_INFO_TABLE. Code:${err.code}, message:${err.message}`);
    }
  }
}

export default new DbUtil();