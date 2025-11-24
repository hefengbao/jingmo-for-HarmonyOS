import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { Character, ExplanationItem } from '../model/Character';
import { DbCRUDConst, DbTableConst } from 'constants';
import { Logger } from 'utils';

import DbUtil from 'utils/src/main/ets/data/DbUtil';

export class CharacterDao {
  logger: Logger = new Logger('CharacterDao')

  async createCharacter(character: Character) {
    const valuesBucket: relationalStore.ValuesBucket = {
      'id': character.id,
      'character': character.character,
      'character2': character.character2,
      'pinyin': character.pinyin,
      'radical': character.radical,
      'stroke': character.stroke,
      'wubi': character.wubi,
      'explanations': JSON.stringify(character.explanations),
      'explanations2': JSON.stringify(character.explanations2),
    }

    DbUtil.objectiveRDB?.insert(
      DbTableConst.CHINESE_CHARACTER_TABLE,
      valuesBucket,
      relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
    ).then((rowId: number) => {
      this.logger.info(`Insert is successful, rowId = ${rowId}`)
    }).catch((err: BusinessError) => {
      this.logger.error(`Insert is failed, code is ${err.code},message is ${err.message}`)
    })
  }

  async readRandomCharacter(): Promise<Character | null> {
    let character: Character | null = new Character()

    await DbUtil.objectiveRDB?.querySql(DbCRUDConst.READ_RANDOM_CHINESE_CHARACTER)
      .then((resultSet: relationalStore.ResultSet) => {
        try {
          while (resultSet.goToNextRow()) {
            let temp: Character = new Character()
            temp.id = resultSet.getLong(resultSet.getColumnIndex('id'));
            temp.character = resultSet.getString(resultSet.getColumnIndex('character'));
            temp.character2 = resultSet.getString(resultSet.getColumnIndex('character2'));
            temp.pinyin = resultSet.getString(resultSet.getColumnIndex('pinyin'));
            temp.radical = resultSet.getString(resultSet.getColumnIndex('radical'));
            temp.stroke = resultSet.getLong(resultSet.getColumnIndex('stroke'));
            temp.wubi = resultSet.getString(resultSet.getColumnIndex('wubi'));
            temp.explanations = JSON.parse(resultSet.getString(resultSet.getColumnIndex('explanations'))) as string[];
            temp.explanations2 =
              JSON.parse(resultSet.getString(resultSet.getColumnIndex('explanations2'))) as ExplanationItem[];
            character = temp
            return
          }
        } catch (error) {
          let err = error as BusinessError
          this.logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
        }

        return character;

      }).catch((err: BusinessError) => {
        this.logger.error(`Query is failed, code is ${err.code},message is ${err.message}`)
      });

    return character;
  }
}

export default new CharacterDao()