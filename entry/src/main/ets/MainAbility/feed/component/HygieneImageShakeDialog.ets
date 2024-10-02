import prompt from '@ohos.prompt';
import matrix4 from '@ohos.matrix4';
import vibrator from '@system.vibrator';

@CustomDialog
export struct HygieneImageShakeDialog{
  controller: CustomDialogController
  private cancel=null;
  // duration表示持续总时长，用于渲染progress，以10为单位，每个单位表示1秒
  private duration:number;
  // timeIncrement表示可见渲染，用于更改interval，以10为单位，每个单位表示1表
  private timeIncrement:number;
  private imgURL:Resource;
  private angle:number;
  private title:string;
  @State time:number = 0;
  @State matrix1:any = '';

  aboutToAppear(){
    // 初始化matrix1
    this.matrix1 = matrix4.identity().rotate({x:1, y:1, z:2, angle:this.angle})
    // 每900毫秒（1s）对图片执行一次旋转
    setInterval(()=>{
      this.time = this.time+this.timeIncrement;
      this.angle = -this.angle;
      this.matrix1 = matrix4.identity().rotate({x:1, y:1, z:2, angle:this.angle})
    },450)
  }

  build() {
    Column() {
      Text().fontSize(50).fontWeight(FontWeight.Bold)
      Image(this.imgURL).width(300).height(300).transform(this.matrix1)
        .objectFit(ImageFit.Contain)
      Progress({total:this.duration,value:this.time,type: ProgressType.Capsule}).width(100).height(20)
    }.alignItems(HorizontalAlign.Center)
  }
}