export class FoodData{
  // 食物编号
  foodId: number;
  // 食物名称
  title: string;
  // 食物类型：蔬菜、水果、零食、主食、肉类、饮品
  type: string;
  // 补充饥饿值
  hunger: number;
  // 补充健康值
  health: number;
  // 介绍内容
  introduction: string;
  // 关联内容：《十万个为什么》、视频
  relativeContent: string;
  // 图片路径
  imgURL: Resource;
  // 保质期
  reserve: string;
  // 是否可视
  isVisible: boolean;
  // 价格
  price: number;
  // 垃圾
  waste: string;

  constructor(foodId: number, title: string, type: string, hunger: number, health: number,
  introduction: string, relativeContent: string, imgURL: Resource, reserve: string, isVisible: boolean,
  price: number) {
    this.foodId = foodId;
    this.title = title;
    this.type = type;
    this.hunger = hunger;
    this.health = health;
    this.introduction = introduction;
    this.relativeContent = relativeContent;
    this.imgURL = imgURL;
    this.reserve = reserve;
    this.isVisible = isVisible;
    this.price = price;
  }
}

export function transStrToFoodData(str: string): Array<FoodData> {
  let foodList: Array<FoodData> = []
  var foods = JSON.parse(str)
  console.info('[FoodData]notes.length = ' + foods.length)
  for (var food in foods) {
    foodList.push({ foodId: foods[food].foodId, title: foods[food].title, type: foods[food].type,
      hunger: foods[food].hunger, health: foods[food].health, introduction: foods[food].introduction,
      relativeContent: foods[food].relativeContent, imgURL: foods[food].imgURL, reserve: foods[food].reserve,
      isVisible: foods[food].isVisible, price: foods[food].price, waste: foods[food].waste})
  }
  return foodList
}