import { FoodData } from './FoodData';
import { FOOD_TOTAL , getFoodById} from './FoodDataModel';
import { getRandomEmotion , getRandomSick, EmotionData, getRandomPositiveEmotion, getRandomNegativeEmotion} from './EmotionData';
import { getRandomNum } from '../../utils/DateUtil';
export enum WishType {
  'FoodData','Words','Emotion','Sick'
};

export class WishData{
  type:WishType
  index:number
  message:string
  classInfo:string
  constructor(type:WishType){
    this.type = type;
  }
}

const words = [
  '阿串商店里有好吃的！','垃圾分类从我做起！','饭前要记得洗手哦~','上次没洗手吃饭，闹肚子了。',
  '多吃青菜利于消化！','每天5杯水不容易生病！','我想画画~不好看也要画。','每顿饭都好好吃。',
  '‘举头望明月’，下一句是...','如果我大喊大叫，会让别人不舒服的。','爸爸的电话号码是...',
  '妈妈的电话号码是...','如果我和父母走散了，应该去找警察叔叔阿姨。','不认识的大人给我糖，我才不会吃呢。',
  '’谁知盘中餐，粒粒皆辛苦‘，什么意思啊？','不认识的大人找我帮忙，我会告诉ta找警察叔叔阿姨',
  '穿小衣服和小裤子的地方是我的隐私部位，谁都不能随便碰'
];

// 生成随机愿望 - 没有生病
export function getRandomWish():WishData{
  let wishIndex = getRandomNum(0,5);
  let data:WishData = new WishData(WishType.FoodData);
  console.info('wishIndex： '+wishIndex.toString());
  if (wishIndex == 0) { // Words
    data.type = WishType.Words;
    data.message = words[getRandomNum(0,words.length-1)];
    console.info('wordWish： '+JSON.stringify(data));
  } else if (wishIndex == 1) { // Emotion
    data.type = WishType.Emotion;
    let emotion_1:EmotionData = getRandomEmotion();
    data.classInfo = JSON.stringify(emotion_1);
    console.info('emotionWish： '+JSON.stringify(data));
  } else if (wishIndex == 2) { // Sick
    data.type = WishType.Sick;
    let emotion_2:EmotionData = getRandomSick();
    data.classInfo = JSON.stringify(emotion_2);
    console.info('sickWish： '+JSON.stringify(data));
  } else { // FoodData
    data.type = WishType.FoodData;
    let index = getRandomNum(0,FOOD_TOTAL-1)
    data.index = index;
    let food:FoodData = getFoodById(index);
    data.classInfo = JSON.stringify(food);
    data.message = '我想要'+ food.title;
    console.info('foodWish： '+JSON.stringify(data));
  }
  console.info('打印生成愿望信息：'+JSON.stringify(data));
  return data;
}

export function getRandomFoodWish():WishData{
  let data:WishData = new WishData(WishType.FoodData);
  let index = getRandomNum(0,FOOD_TOTAL-1)
  data.index = index;
  let food:FoodData = getFoodById(index);
  data.classInfo = JSON.stringify(food);
  data.message = '我想要'+ food.title;
  console.info('随机生成FoodWish: '+JSON.stringify(data));
  return data;
}

export function getRandomWordWish():WishData{
  let data:WishData = new WishData(WishType.Words);
  data.message = words[getRandomNum(0,words.length-1)];
  console.info('随机生成WordsWish: '+JSON.stringify(data));
  return data;
}

export function getRandomEmotionWish():WishData{
  let data:WishData = new WishData(WishType.Emotion);
  let emotion:EmotionData = getRandomEmotion();
  data.classInfo = JSON.stringify(emotion);
  console.info('随机生成EmotionWish: '+JSON.stringify(data));
  return data;
}

export function getRandomPositiveWish():WishData{
  let data:WishData = new WishData(WishType.Emotion);
  let emotion:EmotionData = getRandomPositiveEmotion();
  data.classInfo = JSON.stringify(emotion);
  console.info('随机生成EmotionWish: '+JSON.stringify(data));
  return data;
}

export function getRandomNegativeWish():WishData{
  let data:WishData = new WishData(WishType.Emotion);
  let emotion:EmotionData = getRandomNegativeEmotion();
  data.classInfo = JSON.stringify(emotion);
  console.info('随机生成EmotionWish: '+JSON.stringify(data));
  return data;
}

export function getRandomSickWish():WishData{
  let data:WishData = new WishData(WishType.Emotion);
  let emotion:EmotionData = getRandomSick();
  data.classInfo = JSON.stringify(emotion);
  console.info('随机生成SickWish: '+JSON.stringify(data));
  return data;
}