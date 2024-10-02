import { getFoodById } from '../../feed/model/FoodDataModel';
import { getRangeDate } from '../../utils/DateUtil';
export default interface FoodBagData {
  // 物品信息编号
  index: number;
  // 生产日期
  produceDate: string;
  // 数量：暂时用不到
  amount: number;
}

/**
 * 测试数据
 */
export let testFoodBagList:Array<FoodBagData> = [
  {index:3,produceDate:'2023-4-20',amount:0},{index:0,produceDate:'2023-4-20',amount:0},
  {index:1,produceDate:'2023-4-20',amount:0},{index:1,produceDate:'2023-4-20',amount:0},
  {index:2,produceDate:'2023-4-20',amount:0}]

export function transStrToFoodBagData(str: string):Array<FoodBagData> {
  let resList: Array<FoodBagData> = [];
  var items = JSON.parse(str);
  for(var item in items) {
    resList.push({index:items[item].index, produceDate:items[item].produceDate, amount:items[item].amount})
  }
  return resList;
}
/**
 * 删除背包中指定物品，整理背包物品编号
 * @param arr
 * @param index
 */
export function deleteBagListItem(arr:Array<FoodBagData>,index:number):Array<FoodBagData>{
  let list:Array<FoodBagData> = [];
  for (let i=0;i<arr.length;i++) {
    if(i !== index) {
      list.push(arr[i]);
    }
  }
  return list;
}

/**
 * 获取到期时间
 * @param item
 */
export function getExpirationDate(item:FoodBagData):string{
  const formatDate = ( time: any ) => {
    const Dates = new Date( time );
    const year: number = Dates.getFullYear();
    const month: number = Dates.getMonth() + 1;
    const day: number = Dates.getDate();
    return year + '-' + month + '-' + day;
  };
  // 获取保质期
  var str = getFoodById(item.index).reserve.split(' ',1);
  let range = Number(str);
  var date = new Date(item.produceDate);
  let expirationDate = formatDate(date.getTime() + ( 1000 * 3600 * 24 * range ));
  console.info('getExpirationDate 获取到期时间 '+expirationDate);
  return expirationDate;
}

/**
 * 判断该食物是否在保质期内
 * @param item
 */
export function isInEffectiveDate(item:FoodBagData):boolean{

  let flag:boolean = true;
  // 获取当前时间
  let nowDate = new Date(getRangeDate(0)).getTime();
  let expirationDate = new Date(getExpirationDate(item)).getTime();
  if (nowDate > expirationDate) {
    flag = false;
  }
  return flag;
}


