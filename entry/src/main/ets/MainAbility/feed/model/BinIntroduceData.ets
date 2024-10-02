import { WasteData , defaultRecycableWasteList, defaultHouseholdWasteList, defaultHarmfulWasteList} from './WasteData';
export class BinIntroduceData{
  name:string
  imgURL:Resource
  content:string
  wasteList:Array<WasteData>
}
const BinComposition = [
  {
    name: '可回收垃圾',
    imgURL: $rawfile('waste_bin_recyclable.png'),
    content: '适宜回收可循环利用的生活废弃物。主要包括酱油瓶、玻璃瓶、平板玻璃、易拉罐、饮料瓶、洗发水瓶、塑料玩具、书本、报纸、广告单、' +
    '纸板箱、衣服、床上用品等。请注意轻投轻放；清洁干燥，避免污染；废纸尽量平整；立体包装请清空内容物，清洁后压扁投放；有尖锐边角的，应包裹后投放。',
    wasteList: defaultRecycableWasteList
  },
  {
    name: '厨余垃圾',
    imgURL: $rawfile('waste_bin_household_food.png'),
    content: '湿垃圾，即易腐垃圾，易腐的生物质生活废弃物，如剩菜剩饭、瓜皮、果核、花卉绿植、过期食品等。湿垃圾应从产生时就与' +
    '其他品种垃圾分开收集。纯流质的食物垃圾，如牛奶等，应直接倒进下水口；有包装物的湿垃圾应将包装物取出后分类投放。',
    wasteList: defaultHouseholdWasteList
  },
  {
    name: '有害垃圾',
    imgURL: $rawfile('waste_bin_harmful.png'),
    content: '投放充电电池、纽扣电池、蓄电池时，请注意轻放；投放油漆桶、杀虫剂时，如果容器中有残留物，请密闭后投放；投放荧光灯、节能灯等易破碎物' +
    '时，请连带包装或包裹后轻放；投放废药品时请连带包装一并投放，避免保洁阿串的好朋友黑猫小灰误食。',
    wasteList: defaultHarmfulWasteList
  }
];

export function getBinIntroById(index:number):BinIntroduceData{
  return BinComposition[index];
}