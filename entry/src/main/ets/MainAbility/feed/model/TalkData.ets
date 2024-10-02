export class TalkData{
  name:string;
  avatar:Resource;
  message:string;
  constructor(name:string,avatar:Resource){
    this.name = name;
    this.avatar = avatar;
  }
}

const TalkDataComposition = [
  {
    name:'开心的保洁阿串',
    avatar:$rawfile('avatar_cleaner_happy.png'),
    message:'你真棒！谢谢你支持我的工作。我们一起让社区变得更干净整洁吧！'
  },
  {
    name:'难过的保洁阿串',
    avatar:$rawfile('avatar_cleaner_angry.png'),
    message:'ε=(´ο｀*)))唉，又要重新整理垃圾了，好累呀。'
  },
  {
    name:'神秘的阿毛',
    avatar: $rawfile('avatar_passby_pineapple.png'),
    message:'今天也是活力满满的运动健将！'
  },
  {
    name:'奖金-保洁阿串',
    avatar:$rawfile('avatar_cleaner_happy.png'),
    message:'你真棒！又分对了一个！'
  },
  {
    name:'夸夸群-保洁阿串',
    avatar:$rawfile('avatar_cleaner_happy.png'),
    message:'弄错了？没关系，我们再想想下一个！加油呀！'
  }
]

/**
 * 根据名称获取角色对话
 * @param str
 */
export function getTalkDataByName(str:string):any{
  let res:TalkData;
  for(let i=0;i<TalkDataComposition.length;i++){
    if (TalkDataComposition[i].name === str) {
      res = TalkDataComposition[i];
      return res;
    }
  }
  return '';
}