import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../log/Logger';
import { AppConst, DbConfigConst, DbCRUDConst, DbMigrationConst } from 'constants';

/**
 * 官方文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/data-persistence-by-rdb-store
 *
 * 在 products/default/src/main/ets/entryability/EntryAbility.ets 的 onWindowStageCreate() 初始化
 */
export class DbUtil {
  objectiveRDB?: relationalStore.RdbStore;
  private logger: Logger = new Logger('RDBStoreUtil')

  init(context: Context) {
    relationalStore.getRdbStore(context, DbConfigConst.STORE_CONFIG,
      async (error: BusinessError, rdbStore: relationalStore.RdbStore) => {
        this.objectiveRDB = rdbStore
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

        this.create_fts(rdbStore)

        rdbStore.version = storeVersion
      })
  }

  private async create_fts(rdbStore: relationalStore.RdbStore) {

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
}

export default new DbUtil();