@Entry
@CustomDialog
export struct NullCharacterDialog{
  controller: CustomDialogController;
  private text:string;
  private cancel=null;
  @State timeCount:number = 5;
  @State timeStr:string = '0'+this.timeCount.toString();

  aboutToAppear(){
    setInterval(()=>{
      this.timeCount = this.timeCount-1;
      this.timeStr = '0'+this.timeCount.toString();
    },950)
  }
  build() {
    Column() {
      Image($rawfile('create_map.png')).width(100).height(100)
        .objectFit(ImageFit.Contain).width(100).height(100)
      Text(this.timeStr).fontSize(20)
      Text(this.text).fontSize(20).fontWeight(FontWeight.Bold).padding({top:20})
    }.margin(10).padding(10)
  }
}