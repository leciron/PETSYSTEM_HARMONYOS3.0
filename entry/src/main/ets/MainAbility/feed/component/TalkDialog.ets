const imgSize:number = 154;

@CustomDialog
export struct TalkDialog{
  private name:string;
  private avatar:Resource;
  private message:string;
  controller:CustomDialogController;
  build() {
    Stack() {
      Rect({ width: '80%', height: 165 })
        .fill(Color.White).radius(10)
        .opacity(0.7)
      Row({ space: 5 }) {
        Column({ space: 10 }) {
          Image(this.avatar).width(imgSize).height(imgSize)
            .objectFit(ImageFit.Contain).width(imgSize).height(imgSize)
            .borderRadius(10)
        }

        Column() {
          Text(this.name).width(650)
            .fontSize(30).fontStyle(FontStyle.Italic).fontWeight(FontWeight.Bold)
          Stack() {
            Rect({ width: 650, height: 120 })
              .fill(0xFAEEE0).radius(10)
              .opacity(0.8)
            Column() {
              Stack() {
                Text(this.message).fontSize(25).width(640).height(100)
                  .offset({x:10,y:0})
                Button('好的！')
                  .margin({ bottom: 10 })
                  .fontSize(20)
                  .offset({ x: '40%', y: 40 })
                  .onClick(() => {
                    this.controller.close();
                  })
              }
            }.borderRadius(10)
          }.alignContent(Alignment.Start)
        }
      }.width('80%')
      .offset({x: 5, y:0})
    }.alignContent(Alignment.Start)
  }
}
