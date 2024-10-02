import { FoodData } from '../../feed/model/FoodData';

@CustomDialog
export struct BuyDialog{
  controller: CustomDialogController;
  private food: FoodData = null;
  private buyAction = null;

  build(){
    Column({space: 5}) {
      Image(this.food.imgURL).width(100).height(100)
        .objectFit(ImageFit.Contain).width(100).height(100)
        .backgroundColor('#DFDFF5')
        .border({ width: 5, color: '#F5F5F5', radius: 10 })
      Text(this.food.title).fontSize(20).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)

      Row({space: 10}){
        Image($rawfile('icon_property_coin.png')).width(25).height(25)
          .objectFit(ImageFit.Contain).width(25).height(25)
        Text(this.food.price.toString()).fontSize(16)
      }
      Text(this.food.introduction).fontSize(16).width('80%')

      Row({space: 10}){
        Button('购买').onClick(()=>{
          this.controller.close();
          this.buyAction(this.food);
        })
        Button('取消').onClick(()=>{
          // 使用控制器关闭弹窗
          this.controller.close();
        })
      }
    }
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
    .padding(10)
  }
}