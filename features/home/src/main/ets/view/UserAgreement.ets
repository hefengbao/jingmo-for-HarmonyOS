import { AppConst } from 'constants';
import PrefUtils from 'utils/src/main/ets/data/PrefUtil';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { Logger } from 'utils';

let logger: Logger = new Logger('UserAgreement')

@ComponentV2
export struct UserAgreement {
  @Param @Require @Once pageStack: NavPathStack;

  build() {
    Column() {
      Text() {
        Span('欢迎使用『京墨文库』APP，为了更好的保护您的个人信息和隐私，在使用『京墨文库』服务之前，请仔细阅读')
        Span('《用户协议》')
          .fontColor(Color.Blue)
          .fontStyle(FontStyle.Italic)
          .decoration({ type: TextDecorationType.Underline, color: Color.Blue })
          .onClick(() => {
            this.pageStack.pushPathByName('TosPage', null)
          })
        Span('和')
        Span('《隐私政策》')
          .fontColor(Color.Blue)
          .decoration({ type: TextDecorationType.Underline, color: Color.Blue })
          .onClick(() => {
            this.pageStack.pushPathByName('PrivacyPage', null)
          })
        Span('。')
      }

      Row() {
        Blank()
        Text('不同意并退出')
          .decoration({ type: TextDecorationType.Underline, color: Color.Black })
          .margin({ right: 16 })
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            context?.terminateSelf().catch((err: BusinessError) => {
              logger.error(`terminateSelf failed. code=${err.code}, message=${err.message}`);
            });
          })
        Button('同意')
          .onClick(() => {
            PrefUtils.saveUserAgreementVersion(AppConst.USER_AGREEMENT_VERSION)
          })
      }
      .width('100%')
      .margin({ top: 32 })
      .align(Alignment.End)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(32)
    .justifyContent(FlexAlign.Center)
  }
}