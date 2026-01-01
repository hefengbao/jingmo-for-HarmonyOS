import { Icon, PrefConst, ThemeConst } from 'constants';
import { promptAction } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { Logger } from 'utils/src/main/ets/log/Logger';
import { BoldTitle } from './ContentComponent';
import { ChineseColor, getChineseColorList } from 'data';
import PrefUtil from 'utils/src/main/ets/data/PrefUtil';

let logger = new Logger('Snapshot')

@ComponentV2
export struct SnapshotToolbar {
  @Local isShowSheet: boolean = false;
  @Local paddingX: number = PrefUtil.getSnapshotPaddingX();
  @Local paddingY: number = PrefUtil.getSnapshotPaddingY();
  @Local fontSize: number = PrefUtil.getSnapshotFontSize();
  @Local fontColor: string = PrefUtil.getSnapshotFontColor();
  @Local bgColor: string = PrefUtil.getSnapshotBackgroundColor();
  @Local chineseColors: ChineseColor[] = getChineseColorList();
  @Event change:(paddingX: number, paddingY: number, fontSize: number, fontColor: string, bgColor: string) => void = (paddingX: number, paddingY: number, fontSize: number, fontColor: string, bgColor: string) => {}

  observer = (key: string) => {
    if (key == PrefConst.SNAPSHOT_PADDING_X) {
      this.paddingX = PrefUtil.getSnapshotPaddingX();
    } else if (key == PrefConst.SNAPSHOT_PADDING_Y) {
      this.paddingY = PrefUtil.getSnapshotPaddingY()
    } else if (key == PrefConst.SNAPSHOT_FONT_SIZE) {
      this.fontSize = PrefUtil.getSnapshotFontSize()
    } else if (key == PrefConst.SNAPSHOT_FONT_COLOR) {
      this.fontColor = PrefUtil.getSnapshotFontColor()
    } else if (key == PrefConst.SNAPSHOT_BACKGROUND_COLOR) {
      this.bgColor = PrefUtil.getSnapshotBackgroundColor()
    }
    this.change(this.paddingX, this.paddingY, this.fontSize, this.fontColor, this.bgColor)
  }

  aboutToAppear(): void {
    try {
      PrefUtil.preference?.on('change', this.observer)
    } catch (error) {
      logger.error(`preference add change observer error = ${error}`);
    }
  }

  aboutToRecycle(): void {
    try {
      PrefUtil.preference?.off('change', this.observer)
    } catch (error) {
      logger.error(`preference off change observer error = ${error}`);
    }
  }

  @Builder
  SheetBuilder() {
    Column() {
      // 第一步：自定义滚动容器
      List({ space: '10vp' }) {
        ListItem() {
          BoldTitle({text:"边距"})
        }
        ListItem() {
          Column(){
            Row({ space: 16 }){
              Text("左右边距：")
              Button("-")
                .onClick(() => {
                  if (this.paddingX) {
                    PrefUtil.saveSnapshotPaddingX(this.paddingX - 1)
                  }
                })
              Text(`${this.paddingX}`)
              Button("+")
                .onClick(() => {
                  if (this.paddingX) {
                    PrefUtil.saveSnapshotPaddingX(this.paddingX + 1)
                  }
                })
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .padding(ThemeConst.P_X16_Y8)
            Row({ space: 16 }){
              Text("上下边距：")
              Button("-")
                .onClick(() => {
                  if (this.paddingY) {
                    PrefUtil.saveSnapshotPaddingY(this.paddingY - 1)
                  }
                })
              Text(`${this.paddingY}`)
              Button("+")
                .onClick(() => {
                  if (this.paddingY) {
                    PrefUtil.saveSnapshotPaddingY(this.paddingY + 1)
                  }
                })
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .padding(16)
          }
        }
        ListItem() {
          BoldTitle({text:"字体大小"})
        }
        ListItem() {
          Row({ space: 16 }){
            Button("-")
              .onClick(() => {
                if (this.fontSize) {
                  PrefUtil.saveSnapshotFontSize(this.fontSize - 1)
                }
              })
            Text(`${this.fontSize}`)
            Button("+")
              .onClick(() => {
                if (this.fontSize) {
                  PrefUtil.saveSnapshotFontSize(this.fontSize + 1)
                }
              })
          }
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .padding(16)
        }
        ListItem() {
          BoldTitle({text:"文字颜色"})
        }
        ListItem(){
          Row({ space: 16 }){
            Stack(){
              Image(Icon.ic_public_text_black)
                .width(32)
                .height(32)
                .onClick(() => {
                  PrefUtil.saveSnapshotFontColor('#000000')
                })
            }
            .width(40)
            .height(40)
            .background(this.bgColor)
            .align(Alignment.Center)
            Stack(){
              Image(Icon.ic_public_text_white)
                .width(32)
                .height(32)
                .onClick(() => {
                  PrefUtil.saveSnapshotFontColor('#ffffff')
                })
            }
            .width(40)
            .height(40)
            .background(this.bgColor)
            .align(Alignment.Center)
          }
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .padding(16)
        }
        ListItem() {
          BoldTitle({text:"背景颜色"})
        }
        ListItem(){
          Grid() {
            ForEach(this.chineseColors, (color: ChineseColor, index) => {
              GridItem() {
                Text(color.name)
                  .backgroundColor(color.hex)
                  .fontColor(color.is_bright ? Color.Black : Color.White)
                  .width('100%')
                  .padding(16)
                  .onClick(() => {
                    PrefUtil.saveSnapshotBackgroundColor(color.hex)
                  })
              }
              .width(100)
            }, (color:ChineseColor):string => color.id)
          }
          .rowsTemplate('1fr 1fr 1fr') // 只设置rowsTemplate属性，当内容超出Grid区域时，可水平滚动。
          .rowsGap(16)
          .columnsGap(16)
          .padding(16)
          .height(200)
        }
      }
      .alignListItem(ListItemAlign.Center)
      .margin({ top: '10vp' })
      .width('100%')
      .height('100%')
      // 第二步：设置滚动组件的嵌套滚动属性
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST,
      })
    }
    .width('100%')
    .height('100%')
  }

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
        this.isShowSheet = !this.isShowSheet
      })
      .bindSheet(this.isShowSheet, this.SheetBuilder(), {
        detents: [SheetSize.MEDIUM, SheetSize.LARGE, 0],
        preferType: SheetType.BOTTOM,
        onDisappear: () => {
          this.isShowSheet = false;
        }
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
            imagePackerApi.packToData(pixmap, packOpts).then((data) => {
              fileIo.writeSync(file.fd, data);
              fileIo.closeSync(file.fd);
              logger.info(`Succeeded in packToFile`);
              try {
                this.getUIContext().getPromptAction().showToast({
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
  @Param @Require fontColor: string;

  build() {
    Text("©京墨文库App")
      .fontColor(this.fontColor)
  }
}