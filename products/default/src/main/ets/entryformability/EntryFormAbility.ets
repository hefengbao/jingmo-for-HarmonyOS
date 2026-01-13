import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { getRandomNumber, Logger } from 'utils';
import { getRandomAntitheticalCouplet, AntitheticalCouplet } from 'chinese_antitheticalcouplet';
import { getRandomIdiom, Idiom } from 'chinese_idiom';
import { getRandomQuote, Quote } from 'chinese_quote';
import { getRandomSentence, Sentence } from 'classicalliterature_sentence';
import { getWriting as getRandomWriting, Writing } from 'classicalliterature_writing';
import DbUtil from 'utils/src/main/ets/data/DbUtil';
import { Clause, deleteFormInfo, FormInfo, getFormInfo, insertFormInfo } from 'data';
import { it } from '@ohos/hypium';


let logger: Logger = new Logger('EntryFormAbility');

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    let parameters = want.parameters
    if (parameters) {
      const formId = parameters['ohos.extra.param.key.form_identity'] as string;
      const formName = parameters['ohos.extra.param.key.form_name'] as string;
      const formDimension = parameters['ohos.extra.param.key.form_dimension'] as string;
      logger.info(`onAddForm:formId = ${formId}, formName = ${formName}, formDimension = ${formDimension}`)

      saveFormInfo(this.context, new FormInfo(formId, formName, formDimension, null))

      updateForm(this.context, formName, formId)
    }

    return formBindingData.createFormBindingData('');
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    // Called to notify the form provider to update a specified form.
    logger.info(`onUpdateForm = ${formId}`);

    getFormInfo(formId).then((value: FormInfo | undefined) => {
      if (value) {
        updateForm(this.context, value.name, value.id)
      }
    })
  }

  onFormEvent(formId: string, message: string) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
    logger.info(`onRemoveForm:${formId}`)
    delFormInfo(this.context, formId)
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}

function updateForm(context: Context, formName: string, formId: string) {
  switch (formName) {
    case 'chinese_antitheticalcouple':
      getAntitheticalCouplet(context).then((value: AntitheticalCouplet | undefined) => {
        formProvider.updateForm(formId, formBindingData.createFormBindingData(value))
          .then(() => {
            logger.info(`更新卡片 chinese_antitheticalcouple 成功`)
          })
          .catch((err: BusinessError) => {
            logger.error(`更新卡片 chinese_antitheticalcouple 失败： code = ${err.code}, message = ${err.message}`)
          })
      });
      break;
    case 'chinese_idiom':
      getIdiom(context).then((value: Idiom | undefined) => {
        if (value) {
          formProvider.updateForm(formId, formBindingData.createFormBindingData(value))
            .then(() => {
              logger.info(`更新卡片 chinese_idiom 成功`)
            })
            .catch((err: BusinessError) => {
              logger.error(`更新卡片 chinese_idiom 失败： code = ${err.code}, message = ${err.message}`)
            })
        }
      });
      break;
    case 'chinese_quote':
      getQuote(context).then((value: Quote | undefined) => {
        if (value) {
          formProvider.updateForm(formId, formBindingData.createFormBindingData(value))
            .then(() => {
              logger.info(`更新卡片 chinese_quote 成功`)
            })
            .catch((err: BusinessError) => {
              logger.error(`更新卡片 chinese_quote 失败： code = ${err.code}, message = ${err.message}`)
            })
        }
      });
      break;
    case 'classicalliterature_sentence':
      getSentence(context).then((value: Sentence | undefined) => {
        if (value) {
          formProvider.updateForm(formId, formBindingData.createFormBindingData(value))
            .then(() => {
              logger.info(`更新卡片 classicalliterature_sentence 成功`)
            })
            .catch((err: BusinessError) => {
              logger.error(`更新卡片 classicalliterature_sentence 失败： code = ${err.code}, message = ${err.message}`)
            })
        }
      });
      break;
    case 'classicalliterature_writing':
      getWriting(context).then((value: Writing | undefined) => {
        if (value) {
          formProvider.updateForm(formId, formBindingData.createFormBindingData({
            'title': value.Title.Content,
            'author': value.Author,
            'content': value.Clauses.map((item: Clause) => {
              let str = '';
              if (value.Type != '文') {
                str += `${item.Content}\n`;
              }else {
                str += `${item.Content}`;
              }

              if (item.BreakAfter) {
                str += '\n';
              }

              return str;
            }).join('')
          }))
            .then(() => {
              logger.info(`更新卡片 classicalliterature_writing 成功`)
            })
            .catch((err: BusinessError) => {
              logger.error(`更新卡片 classicalliterature_writing 失败： code = ${err.code}, message = ${err.message}`)
            })
        }
      });
      break;
  }
}

async function getAntitheticalCouplet(context: Context) {

  await DbUtil.getObjectiveRDB(context)

  return await getRandomAntitheticalCouplet();
}

async function getIdiom(context: Context) {

  await DbUtil.getObjectiveRDB(context)

  return await getRandomIdiom();
}

async function getQuote(context: Context) {
  await DbUtil.getObjectiveRDB(context)

  return await getRandomQuote();
}

async function getSentence(context: Context) {
  await DbUtil.getObjectiveRDB(context)

  return await getRandomSentence();
}

async function getWriting(context: Context) {
  await DbUtil.getObjectiveRDB(context)
  let randomId = getRandomNumber(1, 1000000);
  return await getRandomWriting(randomId);
}

async function saveFormInfo(context: Context, formInfo: FormInfo) {
  await DbUtil.getObjectiveRDB(context)

  return await insertFormInfo(formInfo)
}

async function delFormInfo(context: Context, id: string) {
  await DbUtil.getObjectiveRDB(context)

  return await deleteFormInfo(id)
}

