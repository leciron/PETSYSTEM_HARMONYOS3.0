export const heart = [
  $rawfile('icon_health_empty.png'),
  $rawfile('icon_health_orange.png')
]

export class HeartData{
  id:number;
  isOn:boolean;
  constructor(id:number, isOn:boolean){
    this.id = id;
    this.isOn = isOn;
  }
}

/**
 * 根据健康值获取要渲染的心列表
 * @param num
 */
let list:Array<HeartData> = [{id:1,isOn:false},{id:2,isOn:false}, {id:3,isOn:false},
                             {id:4,isOn:false},{id:5,isOn:false}];
export function getHeartList(num:number):Array<HeartData>{
  for (let i=0;i<list.length;i++){
    if (i<num) {
      list[i].isOn = true;
    }else{
      list[i].isOn = false;
    }
  }
  console.info('getHeartList打印结果'+JSON.stringify(list))
  return list;
}