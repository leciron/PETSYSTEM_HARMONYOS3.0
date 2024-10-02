import { WasteData } from '../model/WasteData';
import { BinIntroduceData } from '../model/BinIntroduceData';

const binImgSize:number = 200
const wasteImgSize:number = 50

@CustomDialog
export struct BinIntroduceDialog {
  private bin:BinIntroduceData;
  controller:CustomDialogController

  build() {
    Column() {
      Text(this.bin.name).fontSize(30).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
        .width('50%').textAlign(TextAlign.Center).margin(5)
      Stack() {
        Rect({width:binImgSize,height:binImgSize})
          .fill(Color.Pink).radius(8)
        Image(this.bin.imgURL).width(binImgSize).height(binImgSize)
          .objectFit(ImageFit.Contain).width(binImgSize).height(binImgSize)
      }
      Column() {
        Grid(){
          ForEach(this.bin.wasteList,(item:WasteData,index:number)=>{
            GridItem(){
              Column({space:5}) {
                Stack() {
                  Rect({ width: wasteImgSize, height: wasteImgSize }).borderRadius(8)
                    .fill(Color.Yellow).radius(8)
                  Image(item.imgURL).width(wasteImgSize).height(wasteImgSize)
                    .objectFit(ImageFit.Contain).width(wasteImgSize).height(wasteImgSize)
                }
                Text(item.title)
              }
            }
          },(item:WasteData,index:number)=>index.toString())
        }
        .align(Alignment.Center)
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .columnsGap(2)
      }.width('90%').height('13%').margin(5)
      Text(this.bin.content).fontSize(16)
        .height('25%').width('80%')
      Button('确认').onClick(()=>{
        this.controller.close()
      }).margin({top:5})
    }.backgroundColor(Color.White).borderRadius(10)
    .width('45%').height('90%')
  }
}