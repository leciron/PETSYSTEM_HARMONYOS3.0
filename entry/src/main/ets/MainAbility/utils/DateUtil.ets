/**
 * 拆分日期，输入2000-1-1，获得 2000年1月1日的标准格式
 */
export function getDateStr(str:string):string{
  let temp;
  let strArr = str.split('-');
  temp = strArr[0]+'年'+strArr[1]+'月'+strArr[2]+'日';
  console.info('[Leciron~~]getDateStr（DateUtil.ets）输出 '+temp);
  return temp;
}

/**
 * 获取一个时间 2000-1-1
 * @param range 正负皆可，表示当前系统时间之后之前的天数，0表示当前系统时间
 * @param type assigned指定，random随机
 */
export function getRangeDate(range:number,type?:string){
  const formatDate = ( time: any ) => {
      const Dates = new Date( time );
      const year: number = Dates.getFullYear();
      const month: number = Dates.getMonth() + 1;
      const day: number = Dates.getDate();
      return year + '-' + month + '-' + day;
  };

  const now = formatDate( new Date().getTime() ); // 当前时间
  const resultArr: Array<any> = [];
  let changeDate: string;
  if ( type ) {
    if ( type === 'assigned' ) {
      changeDate = formatDate( new Date().getTime() + ( 1000 * 3600 * 24 * range ) );
      console.log( changeDate );
    }
    if ( type === 'random' ) {
      let Min = 0;
      let Max:number;
      let randomIndex:number;
      if ( range < 0 ) {
        for ( let i = Math.abs( range ); i >= 0; i-- ) {
          resultArr.push( formatDate( new Date().getTime() + ( -1000 * 3600 * 24 * i ) ) );
          console.log(JSON.stringify(resultArr));
        }
        // 随机抽取时间返回
        Max = Math.abs( range )-1;
      } else {
        for ( let i = 1; i <= range; i++ ) {
          resultArr.push( formatDate( new Date().getTime() + ( 1000 * 3600 * 24 * i ) ) );
          console.log(JSON.stringify(resultArr));
        }
        // 随机抽取时间返回
        Max = range - 1;
      }
      // 生成随机下标，返回该项
      var Range = Max - Min;
      var Rand = Math.random();
      randomIndex = Min + Math.round(Rand * Range);
      changeDate = resultArr[randomIndex];
    }
  } else {
    changeDate = formatDate( new Date().getTime() + ( 1000 * 3600 * 24 * range ) );
    console.log( '生成时间： '+ changeDate );
  }
  return changeDate;
}

/**
 * 获取随机数
 * @param Min
 * @param Max
 */
export function getRandomNum(Min:number, Max:number):number {
  let randomIndex:number;
  var Range = Max - Min;
  var Rand = Math.random();
  randomIndex = Min + Math.round(Rand * Range);
  return randomIndex;
}