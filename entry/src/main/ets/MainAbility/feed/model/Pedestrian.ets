import { getRandomNum } from '../../utils/DateUtil';
export class Pedestrian{
  id:number
  img:Resource
  content:string
  imgSize:number
  constructor(id:number, img:Resource, content:string){
    this.id = id;
    this.img = img;
    this.content = content;
  }
}

const CAR_SIZE:number = 200;
const LARGE_PEDESTRIAN:number = 150;
const SMALL_PEDESTRIAN:number = 125;

/*               3个资源列表                 */
// 左侧威胁、右侧威胁、右侧路人
// 左侧威胁
const leftImgList:Array<Pedestrian> = [
  {
    id:0,
    img:$rawfile('traffic_r_car_redPrivate.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:CAR_SIZE
  },
  {
    id:1,
    img:$rawfile('traffic_r_car_blue.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:CAR_SIZE
  },
  {
    id:2,
    img:$rawfile('traffic_r_car_grey.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:CAR_SIZE
  },
  {
    id:3,
    img:$rawfile('traffic_r_car_orange.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:CAR_SIZE
  },
  {
    id:4,
    img:$rawfile('traffic_r_car_yellow.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:CAR_SIZE
  },
  {
    id:5,
    img:$rawfile('traffic_r_car_yellowPickup.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:CAR_SIZE
  },
  {
    id:6,
    img:$rawfile('traffic_r_pedestrian_bicycleMan.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:150
  },
  {
    id:7,
    img:$rawfile('traffic_r_pedestrian_singleWheelGirl.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:150
  },
  {
    id:8,
    img:$rawfile('traffic_r_pedestrian_twoWheelGirl.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:150
  },
  {
    id:9,
    img:$rawfile('traffic_r_pedestrian_wheelBoy.png'),
    content:'哎呀，我就逆行一次。',
    imgSize:150
  }
];

// 右侧威胁
const rightImgList:Array<Pedestrian> = [
  {
    id:0,
    img:$rawfile('traffic_pedestrian_bicycleMan.png'),
    content:'我赶时间！',
    imgSize:150
  },
  {
    id:1,
    img:$rawfile('traffic_pedestrian_right_electricMan.png'),
    content:'我赶时间！',
    imgSize:150
  },
  {
    id:2,
    img:$rawfile('traffic_car_yellowPickup.png'),
    content:'我赶时间！',
    imgSize:CAR_SIZE
  },
  {
    id:3,
    img:$rawfile('traffic_pedestrian_twoWheelGirl.png'),
    content:'我赶时间！',
    imgSize:150
  },
  {
    id:4,
    img:$rawfile('traffic_car_blue.png'),
    content:'我赶时间！',
    imgSize:CAR_SIZE
  },
  {
    id:5,
    img:$rawfile('traffic_car_grey.png'),
    content:'我赶时间！',
    imgSize:CAR_SIZE
  },
  {
    id:6,
    img:$rawfile('traffic_car_redPrivate.png'),
    content:'我赶时间！',
    imgSize:CAR_SIZE
  },
  {
    id:7,
    img:$rawfile('traffic_car_orange.png'),
    content:'我赶时间！',
    imgSize:CAR_SIZE
  },
  {
    id:5,
    img:$rawfile('traffic_car_yellow.png'),
    content:'我赶时间！',
    imgSize:CAR_SIZE
  },
];

// 右侧路人
const rightPedestrianList:Array<Pedestrian> = [
  {
    id:0,
    img:$rawfile('traffic_pedestrian_twoWheelGirl.png'),
    content:'道路旁边的人行道上走慢一点，慌慌张张撞到别人可不好。',
    imgSize:150
  },
  {
    id:1,
    img:$rawfile('traffic_pedestrian_wheelGirl.png'),
    content:'下次我要投进三分篮，还要跟队友们打好配合，加油我可以！',
    imgSize:125
  },
  {
    id:2,
    img:$rawfile('traffic_pedestrian_dogman.png'),
    content:'我是好公民，遛狗狗可得牵好绳子，也要清理粪便垃圾。',
    imgSize:150
  },
  {
    id:3,
    img:$rawfile('traffic_pedestrian_mom.png'),
    content:'今天也是开心的一天，路上风景真好。',
    imgSize:150
  },
  {
    id:4,
    img:$rawfile('traffic_pedestrian_singleWheelGirl.png'),
    content:'道路旁边的人行道上走慢一点，慌慌张张撞到别人可不好。',
    imgSize:150
  },
  {
    id:5,
    img:$rawfile('traffic_pedestrian_shootBoy.png'),
    content:'希望今天能稳定发挥，我想赢！',
    imgSize:125
  }
]

/**
 * 随机获取一个左侧危机
 */
export function getRandomLeft():Pedestrian {
  let index = getRandomNum(0,leftImgList.length-1);
  console.info('getRandomLeft输出 '+JSON.stringify(leftImgList[index]))
  return leftImgList[index];
}
/**
 * 随机获取一个右侧危机
 */
export function getRandomRight():Pedestrian {
  let index = getRandomNum(0,rightImgList.length-1);
  console.info('getRandomRight输出 '+JSON.stringify(rightImgList[index]))
  return rightImgList[index];
}
/**
 * 随机获取一个右侧路人
 */
export function getRandomRightPedestrian():Pedestrian {
  let index = getRandomNum(0,rightPedestrianList.length-1);
  console.info('getRandomRightPedestrian输出 '+JSON.stringify(rightPedestrianList[index]))
  return rightPedestrianList[index];
}