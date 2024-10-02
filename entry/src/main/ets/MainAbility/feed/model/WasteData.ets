import { getRandomNum } from '../../utils/DateUtil';
export enum WasteType {
  'Recycable',
  'Other',
  'Harmful',
  'Household'
}

export class WasteData{
  id:number
  title:string;
  type:WasteType;
  imgURL:Resource;
  imgSize:number;
  constructor(title:string,type:WasteType,imgURL:Resource){
    this.id = WasteCompositionCount + 1;
    this.title = title;
    this.type = type;
    this,imgURL = imgURL;
  }
}

const WasteComposition:Array<WasteData> = [
  {
    id:0,
    title:'易拉罐',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_can.png'),
    imgSize:100
  },
  {
    id:1,
    title:'鸡蛋壳',
    type:WasteType.Household,
    imgURL: $rawfile('waste_item_eggShell.png'),
    imgSize:50
  },
  {
    id:2,
    title:'鱼骨',
    type:WasteType.Household,
    imgURL: $rawfile('waste_item_fishBone.png'),
    imgSize:100
  },
  {
    id:3,
    title:'牛奶盒',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_milkBox.png'),
    imgSize:50
  },
  {
    id:4,
    title:'橘子皮',
    type:WasteType.Household,
    imgURL: $rawfile('waste_item_orangePeel.png'),
    imgSize:50
  },
  {
    id:5,
    title:'塑料瓶',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_plasticBottle.png'),
    imgSize:100
  },
  {
    id:6,
    title:'塑料袋',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_plasticBag.png'),
    imgSize: 100
  },
  {
    id:7,
    title:'电池',
    type:WasteType.Harmful,
    imgURL: $rawfile('waste_item_battery.png'),
    imgSize: 100
  },
  {
    id:8,
    title:'塑料玩具鸭',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_duck.png'),
    imgSize: 100
  },
  {
    id:9,
    title:'过期胶囊',
    type:WasteType.Harmful,
    imgURL: $rawfile('waste_item_expiredCapsule.png'),
    imgSize: 100
  },
  {
    id:10,
    title:'荧光棒',
    type:WasteType.Harmful,
    imgURL: $rawfile('waste_item_lightStick.png'),
    imgSize:100
  },
  {
    id:11,
    title: '报纸',
    type:WasteType.Recycable,
    imgURL:$rawfile('waste_item_newspaper.png'),
    imgSize:100
  },
  {
    id:12,
    title: '花生壳',
    type: WasteType.Household,
    imgURL:$rawfile('waste_item_peanutShell.png'),
    imgSize: 100
  },
  {
    id:13,
    title: '过期药片',
    type: WasteType.Harmful,
    imgURL:$rawfile('waste_item_expiredPill.png'),
    imgSize: 100
  }
]

export let WasteCompositionCount = WasteComposition.length;

export function getAllWasteList():Array<WasteData> {
  return WasteComposition;
}

/**
 * 根据垃圾ID获取对应物品项
 * @param index
 */
export function getWasteById(index:number):WasteData{
  return WasteComposition[index];
}
/**
 * 随机生成垃圾列表
 * @param range：非必填。列表长度。
 * @param type:非必填。与range一起作用，'assigned'指定长度(默认)，'random'在1~range内随机长度
 */
export function getRandomWastes(range?:number,type?:string):Array<WasteData>{
  let len;
  if (range) {
    if (type) {
      if ('assigned'===type) {
        len = range;
      } else {
        len = getRandomNum(1,range);
      }
    } else {
      len = range;
    }
  } else {
    // 随机获取长度
    len = getRandomNum(1,WasteCompositionCount);
  }
  let list:Array<WasteData> = [];
  for (let i=0;i<len;i++) {
    // 获取随机下标
    let index = getRandomNum(0,WasteCompositionCount-1);
    let waste:WasteData = getWasteById(index);
    list.push(waste);
  }
  return list;
}
/*        获取类型垃圾         */
/**
 * 获取 【可回收】 垃圾列表
 * @param arr
 */
export function getRecycableWasteList(arr:Array<WasteData>):Array<WasteData>{
  let list:Array<WasteData> = [];
  for (let i=0;i<arr.length;i++) {
    if (WasteType.Recycable === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}
/**
 * 获取 【厨余】 垃圾列表
 * @param arr
 */
export function getHouseholdWasteList(arr:Array<WasteData>):Array<WasteData>{
  let list:Array<WasteData> = [];
  for (let i=0;i<arr.length;i++) {
    if (WasteType.Household === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}
/**
 * 获取 【有害】 垃圾列表
 * @param arr
 */
export function getHarmfulWasteList(arr:Array<WasteData>):Array<WasteData>{
  let list:Array<WasteData> = [];
  for (let i=0;i<arr.length;i++) {
    if (WasteType.Harmful === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}
/**
 * 获取 【其他】 垃圾列表
 * @param arr
 */
export function getOtherWasteList(arr:Array<WasteData>):Array<WasteData>{
  let list:Array<WasteData> = [];
  for (let i=0;i<arr.length;i++) {
    if (WasteType.Other === arr[i].type) {
      list.push(arr[i]);
    }
  }
  return list;
}

export const defaultRecycableWasteList:Array<WasteData> = getRecycableWasteList(WasteComposition);
export const defaultHouseholdWasteList:Array<WasteData> = getHouseholdWasteList(WasteComposition);
export const defaultHarmfulWasteList:Array<WasteData> = getHarmfulWasteList(WasteComposition);
export const defaultOtherWasteList:Array<WasteData> = getOtherWasteList(WasteComposition);

export let testWasteData:Array<WasteData> = [
  {
    id:0,
    title:'易拉罐',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_can.png'),
    imgSize: 100
  },
  {
    id:1,
    title:'鸡蛋壳',
    type:WasteType.Household,
    imgURL: $rawfile('waste_item_eggShell.png'),
    imgSize:50
  },
  {
    id:6,
    title:'塑料袋',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_plasticBag.png'),
    imgSize: 100
  }]

