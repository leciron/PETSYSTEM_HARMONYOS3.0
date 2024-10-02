export class FoodItemDataModel{
  foodId:number;
  name: string;
  isVisible: boolean;

  constructor(foodId: number, name: string, isVisible: boolean) {
    this.foodId = foodId;
    this.name = name;
    this.isVisible = isVisible;
  }
}

export function transStrToFoodDataModelList(str: string):Array<FoodItemDataModel> {
  let foodList: Array<FoodItemDataModel> = []
  var foods = JSON.parse(str)
  console.info('[FoodData]notes.length = ' + foods.length)
  for (var food in foods) {
    foodList.push({ foodId: foods[food].foodId, name: foods[food].name, isVisible: foods[food].isVisible})
  }
  return foodList
}