import { WasteData , getWasteById} from './WasteData';
import {FoodData} from './FoodData'

const FoodComposition: any[] = [
  {
    "foodId": 0,
    "title": "色素饮料",
    "type": "drink",
    "hunger": 10,
    "health": -1,
    "introduction": "色素饮料有丰富的颜色，通常勾兑了添加剂、防腐剂、糖精，不能代替水。",
    "relativeContent": "",
    "imgURL": $rawfile('feed_drinkItems_Beverage.png'),
    "reserve": "4 D",
    "isVisible": true,
    "price": 10,
    "waste":'5'
  },
  {
    "foodId": 1,
    "title": "碳酸饮料",
    "type": "drink",
    "hunger": 10,
    "health": -1,
    "introduction": "碳酸饮料能补充运动能量，但容易引发骨质疏松，不利于儿童生长，不能代替水。雪碧、可乐都属于碳酸饮料。",
    "relativeContent": "https://s5.ttsmaker.com/file/2023-04-22-192316_145318.mp3",
    "imgURL": $rawfile('feed_drinkItems_Cola.png'),
    "reserve": "4 D",
    "isVisible": true,
    "price": 10,
    "waste": '0 5'
  },
  {
    "foodId": 2,
    "title": "鲜牛奶",
    "type": "drink",
    "hunger": 10,
    "health": 2,
    "introduction": "牛奶中含有蛋白质、钙质，能够促进儿童的骨骼发育，长高高就靠它！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_drinkItems_Milk.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 3,
    "title": "鲜榨果汁",
    "type": "drink",
    "hunger": 10,
    "health": 1,
    "introduction": "鲜榨果汁由新鲜水果、水和糖等构成，需要及时饮用，不能代替水。",
    "relativeContent": "", // "https://attachment.0sm.com/node0/2023/03/86420121A57FA5D0-77d4c578aa2f6294.mp3",
    "imgURL": $rawfile('feed_drinkItems_Orangejuice.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": ''
  },
  {
    "foodId": 4,
    "title": "酸奶",
    "type": "drink",
    "hunger": 1,
    "health": 1,
    "introduction": "酸奶由牛奶发酵成，有很多乳酸菌，可以促进消化，不能代替牛奶。",
    "relativeContent": "",
    "imgURL": $rawfile('feed_drinkItems_Yogurt.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 5,
    "title": "苹果",
    "type": "fruit",
    "hunger": 5,
    "health": 1,
    "introduction": "每天一个苹果，快乐生活！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_fruit_Apple.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 6,
    "title": "香蕉",
    "type": "fruit",
    "hunger": 5,
    "health": 1,
    "introduction": "香蕉提供丰富的钾元素，对排便很有帮助！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_fruit_Banana.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 7,
    "title": "橘子",
    "type": "fruit",
    "hunger": 5,
    "health": 1,
    "introduction": "剥开橘子皮，有一个方便分给所有朋友吃的酸甜橘子！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_fruit_Orange.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 8,
    "title": "梨",
    "type": "fruit",
    "hunger": 5,
    "health": 1,
    "introduction": "梨对于清肺化痰有很好的功效！咳嗽的时候吃梨超舒服！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_fruit_Pear.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 9,
    "title": "面条",
    "type": "mainfood",
    "hunger": 90,
    "health": 1,
    "introduction": "中国独特的吃食，长寿面牛肉面阳春面，快乐无极限！意大利有意大利面。",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_mainfood_Noodles.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 10,
    "title": "粥",
    "type": "mainfood",
    "hunger": 90,
    "health": 1,
    "introduction": "牙疼？生病？口淡？喝粥能更好为身体补充能量！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_mainfood_Porridge.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 11,
    "title": "米饭",
    "type": "mainfood",
    "hunger": 100,
    "health": 1,
    "introduction": "雨水丰沛的地方生产颗粒饱满的稻米，香喷喷的米饭，是家的味道诶！”锄禾日当午，汗滴禾下土，谁知盘中餐，粒粒皆辛苦“，要好好吃饭！",
    "relativeContent": "https://s5.ttsmaker.com/file/2023-04-22-191941_150619.mp3",
    "imgURL": $rawfile('feed_foodItems_mainfood_Rice.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 12,
    "title": "牛肉",
    "type": "meat",
    "hunger": 40,
    "health": 1,
    "introduction": "很多少数民族比如回族、维吾尔族、哈萨克族人主要吃牛肉，红烧、冷片都好好吃！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_meat_Beef.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 13,
    "title": "鸡肉",
    "type": "meat",
    "hunger": 40,
    "health": 1,
    "introduction": "宫保鸡丁、黄焖鸡、辣子鸡、白切鸡、参鸡汤，鸡肉好好吃！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_meat_Chicken.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 14,
    "title": "鱼",
    "type": "meat",
    "hunger": 40,
    "health": 1,
    "introduction": "草鱼煮汤、烤罗非鱼、香辣鲤鱼、清汤鲫鱼，每种鱼有不同的做饭和不同的口感，去尝尝看！藏族人不吃鱼，如果你有藏族朋友，请注意咯！",
    "relativeContent": "https://s5.ttsmaker.com/file/2023-04-22-192146_154398.mp3",
    "imgURL": $rawfile('feed_foodItems_meat_Fish.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 15,
    "title": "鸡蛋",
    "type": "meat",
    "hunger": 40,
    "health": 1,
    "introduction": "香香嫩嫩的蒸鸡蛋、煮鸡蛋、炒鸡蛋，鸡蛋为我们提供了丰富的蛋白质，长高变聪明、增强抵抗力靠它！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_meat_FriedEgg.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 16,
    "title": "猪肉",
    "type": "meat",
    "hunger": 40,
    "health": 1,
    "introduction": "猪排、排骨、回锅肉、猪肉白菜饺子，猪肉是大部分家庭常用肉类，又香又美味！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_meat_Pork.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 17,
    "title": "辣椒",
    "type": "vegetable",
    "hunger": 10,
    "health": 1,
    "introduction": "辣椒富含丰富的维生素C，有益于身体增强免疫力，悄悄告诉你，水果辣椒是甜的！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_vegetable_BellPepper.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 18,
    "title": "胡萝卜",
    "type": "vegetable",
    "hunger": 10,
    "health": 1,
    "introduction": "胡萝卜富含维生素A，对夜盲症有帮助，兔子也很喜欢吃胡萝卜呢。",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_vegetable_Carrot.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 19,
    "title": "玉米",
    "type": "vegetable",
    "hunger": 10,
    "health": 1,
    "introduction": "玉米在阿串的家乡又叫包谷哦，青绿色的叶子包裹着甜玉米、糯玉米，水煮后，一口要上去是幸福的味道！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_foodItems_vegetable_Corn.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 20,
    "title": "饼干",
    "type": "snack",
    "hunger": 50,
    "health": 0,
    "introduction": "曲奇饼干、夹心饼干、苏打饼干、压缩饼干，看你喜欢哪一种，这些馋嘴小零食，阿串这里全都有呢！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_snackItems_cake_Biscuit.png'),
    "reserve": "4 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 21,
    "title": "面包",
    "type": "snack",
    "hunger": 50,
    "health": 0,
    "introduction": "羊角面包、吐司、毛毛虫面包，可以当早餐，搭配牛奶使用最佳！",
    "relativeContent": "",
    "imgURL": $rawfile('feed_snackItems_cake_Bread.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 22,
    "title": "薯条",
    "type": "snack",
    "hunger": 50,
    "health": 0,
    "introduction": "快餐薯条是很多人的心头好，裹上番茄酱放到嘴里，酸甜脆面的味道，放纵大吃一顿吧。",
    "relativeContent": "",
    "imgURL": $rawfile('feed_fastfoodItems_FrenchFries.png'),
    "reserve": "2 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 23,
    "title": "薯片",
    "type": "snack",
    "hunger": 50,
    "health": -1,
    "introduction": "薯片属于膨化食品，很容易饱腹，容易引起消化不良，建议饭后再吃。如果肠胃不好，要少吃一点哦。",
    "relativeContent": "https://s5.ttsmaker.com/file/2023-04-22-192224_100791.mp3",
    "imgURL": $rawfile('feed_snackItems_fry_Chips.png'),
    "reserve": "4 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 24,
    "title": "糖果",
    "type": "snack",
    "hunger": 2,
    "health": 0,
    "introduction": "五颜六色的糖果又好看又好吃，陌生人给的糖一定不能随便吃哦，想吃糖一定要到阿串这里买！吃完要好好刷牙哦！包装纸别忘了要放进垃圾桶~",
    "relativeContent": "",
    "imgURL": $rawfile('feed_snackItems_sugar_Candy.png'),
    "reserve": "4 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 25,
    "title": "巧克力",
    "type": "snack",
    "hunger": 20,
    "health": 0,
    "introduction": "巧克力是高热量的食物，在做运动、低血糖时适当吃一点，能让人充满活力。吃完要好好刷牙哦！包装纸别忘了要放进垃圾桶~",
    "relativeContent": "",
    "imgURL": $rawfile('feed_snackItems_sugar_Chocolate.png'),
    "reserve": "3 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  },
  {
    "foodId": 26,
    "title": "棒棒糖",
    "type": "snack",
    "hunger": 2,
    "health": 0,
    "introduction": "五颜六色的棒棒糖又好看又好吃，陌生人给的糖一定不能随便吃哦，想吃糖一定要到阿串这里买！棒棒糖吃完要好好刷牙哦！包装纸别忘了要放进垃圾桶~",
    "relativeContent": "",
    "imgURL": $rawfile('feed_snackItems_sugar_Lollipop.png'),
    "reserve": "4 D",
    "isVisible": true,
    "price": 10,
    "waste": '3'
  }
]

export const FOOD_TOTAL = FoodComposition.length;

/**
 * 初始化FoodData的数组
 */
export function getFoodDatas(): Array<FoodData> {
  let foodDataArray: Array<FoodData> = []
  FoodComposition.forEach(item => {
    foodDataArray.push(new FoodData(item.foodId, item.title, item.type, item.hunger, item.health, item.introduction,
    item.relativeContent, item.imgURL, item.reserve, item.isVisible, item.price))
  })
  return foodDataArray;
}

/**
 * 获取默认食物（第一条食物数据）
 */
export function getDefaultFood(): FoodData {
  let item = FoodComposition[0]
  let foodData: FoodData = new FoodData(item.foodId, item.title, item.type, item.hunger, item.health, item.introduction,
  item.relativeContent, item.imgURL, item.reserve, item.isVisible, item.price)
  return foodData;
}

/**
 * 根据食物ID找到数据源中的食物项
 * @param index
 */
export function getFoodById(index: number): FoodData {
  let item = FoodComposition[index]
  let foodData: FoodData = new FoodData(item.foodId, item.title, item.type, item.hunger, item.health, item.introduction,
  item.relativeContent, item.imgURL, item.reserve, item.isVisible, item.price)
  return foodData;
}

/**
 * 根据食物ID找到食物对应的垃圾列表
 * @param index
 */
export function getWasteFromFood(index: number):Array<WasteData>{
  let wastes:Array<WasteData> = [];
  let wasteStr = FoodComposition[index];
  // 根据逗号拆开项数
  let list = wasteStr.splice(' ');
  for (let i=0;i<list.length;i++) {
    let index:number = Number(list[i]);
    wastes.push(getWasteById(index));
  }
  // 根据空格随机放入一项到wastes列表中
  return wastes;
}

/*        获取类型食物        */
export function getDrinkList(arr:Array<FoodData>):Array<FoodData>{
  let list:Array<FoodData> = [];
  for (let i=0;i<arr.length;i++) {
    if ('drink' === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export function getMainfoodList(arr:Array<FoodData>):Array<FoodData>{
  let list:Array<FoodData> = [];
  for (let i=0;i<arr.length;i++) {
    if ('fruit' === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export function getFruitList(arr:Array<FoodData>):Array<FoodData>{
  let list:Array<FoodData> = [];
  for (let i=0;i<arr.length;i++) {
    if ('fruit' === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export function getVegetableList(arr:Array<FoodData>):Array<FoodData>{
  let list:Array<FoodData> = [];
  for (let i=0;i<arr.length;i++) {
    if ('vegetable' === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export function getMeatList(arr:Array<FoodData>):Array<FoodData>{
  let list:Array<FoodData> = [];
  for (let i=0;i<arr.length;i++) {
    if ('meat' === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export function getSnackList(arr:Array<FoodData>):Array<FoodData>{
  let list:Array<FoodData> = [];
  for (let i=0;i<arr.length;i++) {
    if ('snack' === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export const defaultDrinkList = getDrinkList(FoodComposition);
export const defaultMainfoodList = getMainfoodList(FoodComposition);
export const defaultMeatList = getMeatList(FoodComposition);
export const defaultFruitList = getFruitList(FoodComposition);
export const defaultVegetableList = getVegetableList(FoodComposition);
export const defaultSnackList = getSnackList(FoodComposition);

