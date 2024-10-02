import router from '@system.router';
import { FoodData } from '../model/FoodData';

@Component
export struct BagItem {
  private item:FoodData;

  build() {
    Row() {
      Stack() {
        Rect({ width: 80, height: 90 })
          .fill(Color.Pink).padding({ left: 5, right: 10 }).radius(8)
        Image(this.item.imgURL).width(80).height(80)
      }

      Column() {
        Text(this.item.title).fontSize(25).fontWeight(FontWeight.Bold)
        Row({ space: 20 }) {
          Row() {
            Text('饥饿补充：').fontSize(20)
            Text(this.item.hunger.toString()).fontSize(20)
          }

          Row() {
            Text('健康值：').fontSize(20)
            Text(this.item.health.toString()).fontSize(20)
          }
        }.padding({ top: 10 })
      }.width('70%').alignItems(HorizontalAlign.Start)
      Image($rawfile('icon_right_forward.png')).width(25).height(25)
        .objectFit(ImageFit.Contain).width(25).height(25)
    }
    .width('100%')
    .height(100)
    .borderRadius(10)
    .backgroundColor(0xFFFFFF)
  }
}