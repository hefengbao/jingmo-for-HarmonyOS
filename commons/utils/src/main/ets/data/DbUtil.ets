import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../log/Logger';
import { DbConfigConst, DbMigrationConst } from 'constants';

/**
 * 官方文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/data-persistence-by-rdb-store
 */
export class DbUtil {
  objectiveRDB?: relationalStore.RdbStore;
  logger: Logger = new Logger('RDBStoreUtil')

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

        // 数据表迁移
        if (storeVersion == 0) {
          try {
            await rdbStore.execute(DbMigrationConst.CREATE_CLASSICALLITERATURE_CLASSICPOEM_TABLE)
          } catch (e) {
            const err = e as BusinessError;
            this.logger.error(`Failed to execute sql. Code:${err.code}, message:${err.message}`);
          }
        }
      })
  }
}

export default new DbUtil();