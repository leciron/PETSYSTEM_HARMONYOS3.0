const imgSize:number = 125;

@CustomDialog
export struct PhoneTalkDialog{
  private name:string;
  private avatar:Resource;
  private message:string;
  controller:CustomDialogController;
  build() {
    Stack() {
      Column() {
        Row().width('90%').height('11%')
        Rect({ width: '90%', height: '89%' })
          .fill(Color.White).radius(10)
      }.height('85%').width('100%')

      Column({ space: 5 }) {
        Image(this.avatar).width(imgSize).height(imgSize)
          .objectFit(ImageFit.Contain).width(imgSize).height(imgSize)
          .borderRadius(10)
        Text(this.name).width('100%')
          .fontSize(25).fontStyle(FontStyle.Italic).fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
        Column({space:10}) {
          Stack() {
            Rect({ width: '90%', height: '45%' })
              .fill(0xFAEEE0).radius(10)
              .opacity(0.8)
            Text(this.message).fontSize(30).width('90%').height('90%')
              .margin({ left: 10 })
              .textAlign(TextAlign.Center)
          }.alignContent(Alignment.Center)

          Button('好的！')
            .fontSize(20)
            .onClick(() => {
              this.controller.close();
            })
        }
      }.width('90%')
    }.alignContent(Alignment.Center)
    .height('80%').width('100%')
  }
}
