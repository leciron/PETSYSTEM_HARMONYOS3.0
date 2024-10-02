import { FoodData } from '../../feed/model/FoodData';


@Component
export struct SelectableFoodItem{
  private food:FoodData = null;
  private handleSelectFood = null;

  build() {
    Row() {
      Row() {
        Stack() {
          Rect({ width: 65, height: 65 })
            .fill(Color.Pink).padding({ left: 5, right: 10 }).radius(8)
          Image(this.food.imgURL).width(60).height(60)
            .objectFit(ImageFit.Contain).width(60).height(60)
        }

        Text(this.food.title).fontSize(20)
      }
      Toggle({ type: ToggleType.Checkbox, isOn: this.food.isVisible})
        .size({ width: 28, height: 28 })
        .selectedColor(0xed6f21)
        .onChange((isOn: boolean) => {
          console.info('Component status:' + isOn)
          let isVisible;
          if (isOn) {
            isVisible = true;
          } else {
            isVisible = false;
          }
          this.handleSelectFood(this.food.foodId,isVisible);
        })
    }.justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height(80)
    .backgroundColor('#DFDFF5')
    .border({ width: 5, color: '#F5F5F5', radius: 10 })
  }
}