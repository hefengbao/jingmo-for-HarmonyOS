import { Icon } from 'constants';
import { promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { Logger } from 'utils/src/main/ets/log/Logger';

let logger = new Logger('Snapshot')

@ComponentV2
export struct SnapshotToolbar {
  build() {
    Row({
      space: 24,
    }) {
      Stack({ alignContent: Alignment.Center }) {
        Image(Icon.ic_public_settings)
          .width($r('sys.float.titlebar_icon_width'))
          .height($r('sys.float.titlebar_icon_height'))
          .fillColor($r('sys.color.icon'))
      }
      .padding(8)
      .margin({ right: $r('sys.float.titlebar_menu_margin_right') })
      .onClick(() => {

      })
      .stateStyles({
        normal: {
          .backgroundColor($r('sys.color.titlebar_icon_background_color'))
          .borderRadius(18)
        },
        pressed: {
          .backgroundColor($r('sys.color.titlebar_icon_background_pressed_color'))
          .borderRadius(18)
        }
      })

      SaveButton({
        icon: SaveIconStyle.FULL_FILLED,
        text: SaveDescription.SAVE_IMAGE,
        buttonType: ButtonType.Capsule
      })
        .onClick(() => {
          let context = this.getUIContext().getHostContext()
          this.getUIContext().getComponentSnapshot().get("image", async (error: Error, pixmap: image.PixelMap) => {
            if (error) {
              console.error("error: " + JSON.stringify(error))
              return;
            }

            const helper = photoAccessHelper.getPhotoAccessHelper(context);
            const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
            const file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
            const imagePackerApi: image.ImagePacker = image.createImagePacker();
            const packOpts: image.PackingOption = {
              format: 'image/png',
              quality: 100,
            };
            imagePackerApi.packing(pixmap, packOpts).then((data) => {
              fileIo.writeSync(file.fd, data);
              fileIo.closeSync(file.fd);
              logger.info(`Succeeded in packToFile`);
              try {
                promptAction.showToast({
                  message: '保存成功',
                  duration: 1800
                })
              } catch (error) {
                // TODO: Implement error handling.
              }
            }).catch((error: BusinessError) => {
              logger.error(`Failed to packToFile. Error code is ${error.code}, message is ${error.message}`);
            });
          }, { scale: 2, waitUntilRenderFinished: true })
        })
    }
    .margin({ top: 24 })
    .padding({ left: 16, right: 16 })
    .width('100%')
  }
}

@ComponentV2
export struct CopyrightView {
  build() {
    Text("©京墨文库App")
  }
}