import vibrator from '@ohos.vibrator'

@CustomDialog
export struct TextDialog {
  private controller: CustomDialogController;
  private dialogText:string;

  build() {
    Column() {
      Text($r('app.string.alarm'))
        .fontSize(25)
        .fontWeight(20)
        .margin(10)
        .fontColor('#1a1919')
        .textAlign(TextAlign.Center)
      Text(this.dialogText)
        .fontSize(20)
      Row() {
        Button() {
          Text($r('app.string.yes'))
            .fontSize(30)
        }
        .backgroundColor(Color.White)
        .margin({ top: 20, right: 40, bottom: 20 })
        .onClick(() => {
          vibrator.stop(vibrator.VibratorStopMode.VIBRATOR_STOP_MODE_TIME, (error) => {
            this.controller.close()
          })
        })
      }
    }

  }
}