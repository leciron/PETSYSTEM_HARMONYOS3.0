import { getRandomNum } from '../../utils/DateUtil';
export enum EmotionType{
'Positive','Negative'
}
export class EmotionData{
  id:number
  title:string
  img:Resource
  type:EmotionType
  constructor(img:Resource,type:EmotionType){
    this.img = img;
    this.type = type;
  }
}
const EmotionComposition:Array<EmotionData>=[
  {
    id:0,
    title:'',
    img:$rawfile('emotion_happy.png'),
    type:EmotionType.Positive
  },
  {
    id:1,
    title:'',
    img:$rawfile('emotion_happy2.png'),
    type:EmotionType.Positive
  },
  {
    id:2,
    title:'',
    img:$rawfile('emotion_like.png'),
    type:EmotionType.Positive
  },
  {
    id:3,
    title:'',
    img:$rawfile('emotion_like2_badlaugh.png'),
    type:EmotionType.Positive
  },
  {
    id:4,
    title:'',
    img:$rawfile('emotion_like3.png'),
    type:EmotionType.Positive
  },
  {
    id:5,
    title:'',
    img:$rawfile('emotion_notbad.png'),
    type:EmotionType.Positive
  },
  {
    id:6,
    title:'',
    img:$rawfile('emotion_dislike.png'),
    type:EmotionType.Negative
  },
  {
    id:7,
    title:'',
    img:$rawfile('emotion_dislike2.png'),
    type:EmotionType.Negative
  },
  {
    id:8,
    title:'',
    img:$rawfile('emotion_dislike3.png'),
    type:EmotionType.Negative
  },
  {
    id:9,
    title:'',
    img:$rawfile('emotion_hurt.png'),
    type:EmotionType.Negative
  },
  {
    id:10,
    title:'',
    img:$rawfile('emotion_unwilling.png'),
    type:EmotionType.Negative
  },
  {
    id:11,
    title:'',
    img:$rawfile('emotion_unwilling2.png'),
    type:EmotionType.Negative
  },
  {
    id:12,
    title:'',
    img:$rawfile('emotion_unwilling3.png'),
    type:EmotionType.Negative
  }
];


// 台词
const HappyWords = [
  '嘻嘻嘻','我好开心！','我喜欢这个','今天很感谢你哦！','今天真好！',
  '我真棒！','今天的光盘行动达成~','希望你今天开心！','哦，再去运动一下！',
  '多喜欢自己一点~','我的小肚子很好看！','哈哈哈哈哈哈'
];

const SadWords = [
  '啊我要零食！','啊我要饮料！','啊啊啊啊啊啊！','呜呜呜呜呜！','我不管我就要那个！',
];

const SickStomachWords = [
  '我肚子好疼啊呜呜...','拉肚子了，好难受','以后好好洗手才行'
];

const SickTeethWords = [
  '牙疼，吃不下饭。','牙好疼!','呜呜呜早知道就好好刷牙了。','又不能吃小蛋糕了。'
];

function getPositiveEmotion():Array<EmotionData>{
  let list:Array<EmotionData> = [];
  for (let i=0;i<EmotionComposition.length;i++) {
    if (EmotionType.Positive === EmotionComposition[i].type) {
      list.push(EmotionComposition[i]);
    }
  }
  console.info('打印积极情绪列表：'+JSON.stringify(list));
  return list;
}

function getNegativeEmotion():Array<EmotionData>{
  let list:Array<EmotionData> = [];
  for (let i=0;i<EmotionComposition.length;i++) {
    if (EmotionType.Negative === EmotionComposition[i].type) {
      list.push(EmotionComposition[i]);
    }
  }
  console.info('打印负面情绪列表：'+JSON.stringify(list));
  return list;
}

function getEmotionById(index:number):EmotionData{
  return EmotionComposition[index];
}

/**
 * 随机获取开心表情
 */
export function getRandomPositiveEmotion():EmotionData{
  let list = getPositiveEmotion();
  let dataIndex = getRandomNum(0,list.length-1);
  let wordIndex = getRandomNum(0,HappyWords.length-1);
  let data:EmotionData = list[dataIndex];
  let word = HappyWords[wordIndex];
  data.title = word;
  return data;
}
/**
 * 随机获取难过表情
 */
export function getRandomNegativeEmotion():EmotionData{
  let list = getNegativeEmotion();
  let dataIndex = getRandomNum(0,list.length-1);
  let wordIndex = getRandomNum(0,SadWords.length-1);
  let data:EmotionData = list[dataIndex];
  let word = SadWords[wordIndex];
  data.title = word;
  return data;
}
/**
 * 随机获取肚子痛表情
 */
export function getRandomStomachEmotion():EmotionData{
  let list = getNegativeEmotion();
  let dataIndex = getRandomNum(0,list.length-1);
  let wordIndex = getRandomNum(0,SickStomachWords.length-1);
  let data:EmotionData = list[dataIndex];
  let word = SickStomachWords[wordIndex];
  data.title = word;
  return data;
}
/**
 * 随机获取牙疼表情
 */
export function getRandomTeethEmotion():EmotionData{
  let list = getNegativeEmotion();
  let dataIndex = getRandomNum(0,list.length-1);
  let wordIndex = getRandomNum(0,SickTeethWords.length-1);
  let data:EmotionData = list[dataIndex];
  let word = SickTeethWords[wordIndex];
  data.title = word;
  return data;
}

/**
 * 获取喜怒情绪
 */
export function getRandomEmotion():EmotionData{
  let prop = getRandomNum(0,1);
  let data:EmotionData;
  if (prop == 0) { // positive
    data = getRandomPositiveEmotion();
  } else {
    data = getRandomNegativeEmotion();
  }
  return data;
}
/**
 * 获取生病情绪
 */
export function getRandomSick():EmotionData{
  let prop = getRandomNum(0,1);
  let data:EmotionData;
  if (prop == 0) { //
    data = getRandomStomachEmotion();
  } else {
    data = getRandomTeethEmotion();
  }
  return data;
}

export class VisibleItem{
  title:string
  imgURL:Resource
  isVisible:boolean
  content:string
  constructor(title:string,imgURL:Resource,isVisible:boolean,content:string){
    this.title = title;
    this.imgURL = imgURL;
    this.isVisible = isVisible;
    this.content = content;
  }
}

export function existVisibleItem(type:string,arr:Array<VisibleItem>):boolean{
  for(let i=0;i<arr.length;i++) {
    if (type === arr[i].title) {
      return true;
    }
  }
  return false;
}


