import matrix4 from '@ohos.matrix4';
import { TalkData } from '../model/TalkData';
import { TalkDialog } from './TalkDialog';
import { DeleteDialog } from './DeleteDialog';
import { hungerResponse } from '../../create/model/AnimalDataModel';
import { WishData , getRandomSickWish, WishType, getRandomPositiveWish, getRandomNegativeWish} from '../model/WishData';
import { VisibleItem , EmotionData, getRandomPositiveEmotion, getRandomNegativeEmotion} from '../model/EmotionData';
import { getDateStr , getRandomNum} from '../../utils/DateUtil';
import { HeartData , getHeartList} from '../model/HeartData';
import { audio_On_Play } from '../model/AudioPlayer';
import media from '@ohos.multimedia.media';
import { TextDialog } from './TextDialog';
import CharacterData from '../../create/model/CharacterData';
import prompt from '@ohos.prompt';
import { BagItem } from './BagItem';
import  FoodBagData , { transStrToFoodBagData, deleteBagListItem, isInEffectiveDate, testFoodBagList}  from '../../create/model/FoodBagData';
import LiteStoreConstants from '../../constants/LiteStoreConstants';
import { LiteStore } from '../../test_store/model/LiteStore';
import router from '@system.router';
import { getFoodById } from '../model/FoodDataModel';
import { FoodData } from '../model/FoodData';
import vibrator from '@ohos.vibrator'

let foodBag_LiteStore = new LiteStore(LiteStoreConstants.BAG_FOOD_KEY);
let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);

// virusList数据
let VIRUS:VisibleItem = new VisibleItem('virus',$rawfile('hygiene_virus.png'),true,"饭前没洗手，细菌入口了！");
let HEALTHY:VisibleItem = new VisibleItem('healthy',$rawfile('hygiene_healthy.png'),true,"你为我的健康身体补充了营养");
let TIMEOUT:VisibleItem = new VisibleItem('virus',$rawfile('hygiene_overtime.png'),true,"吃了过期食品");
let SANITIZER:VisibleItem = new VisibleItem('sanitizer',$rawfile('hygiene_soap.png'),true,"洗手时用了洗手液，冲走大部分细菌。");

let index = 0;
const angles = [-20,0,20,0];
const positions:Array<Position> = [
  {x:0,y:-80},{x:0,y:0},{x:0,y:-100},{x:0,y:0}
];

@Component
export struct BagList {
  // 需要渲染的物品列表
  private foodBag:Array<FoodBagData> = [];
  // 列表_选中物品在背包中的编号
  @State selectItemId: number = 0;
  // 是否显示默认页面-仓库无数据  '
  @State defaultBagList:boolean = true;
  // 是否显示说明书界面
  @State openDocument: boolean = false;
  @State itemInfo:FoodData = getFoodById(this.selectItemId);
  @State itemBagInfo: FoodBagData = {index:0,produceDate:'2022年2月22日',amount:2};
  // 交互数据
  @Link handClean:number;
  @Link character:CharacterData;
  @Link heartList:Array<HeartData>;
  @Link virusList:Array<VisibleItem>;
  @Link img:Resource;
  @Link handlePopup:boolean;
  @Link wish:WishData;
  // 动画
  @Link matrix1:any;
  // 对话框
  textDialogController = new CustomDialogController({
    builder:TextDialog({
      dialogText:"没有洗手吃东西，很容易肚子痛哦！"
    }),
    autoCancel:true
  })
  deleteDialogController:CustomDialogController;
  talkDialogController:CustomDialogController;

  async aboutToAppear(){
    // LiteStore读取数据
    let str = <string> await foodBag_LiteStore.getValue();
    // 无数据使用默认页面
    if (str === '') {
      this.defaultBagList = true;
    } else {
      this.defaultBagList = false;
    }
    console.log('购买' + str);
    this.foodBag = transStrToFoodBagData(str);
    // 界面测试 背包物品列表 + 说明书  【注释上面所有即可】
//    this.foodBag = testFoodBagList;
//    console.info('[aboutToAppear] 打印背包列表：'+JSON.stringify(this.foodBag));
//    this.selectItemId = 0;
//    this.defaultBagList = false;
  }

  /**
   * 自定义-获取保质期内容
   * @param reserve (string,e.g. 3 D)
   */
  getReserveString(reserve: string): string {
    let item:string = "";
    var splitItem = reserve.split(" ");
    item = item + splitItem[0];
    switch(splitItem[1]) {
      case "D": item += "天";break;
      case "M": item += "个月";break;
      case "Y": item += "年";break;
      default:break;
    }
    return item;
  }

  /**
   * 判断过期处理
   */
  expiredDeal = ()=>{
    console.info("[expiredDeal]判断为过期处理")
    console.info("[expiredDeal]目前背包："+JSON.stringify(this.foodBag));
    console.info("[expiredDeal]目前选中物品编号："+this.selectItemId.toString());
    console.info("[expiredDeal]目前商品信息："+JSON.stringify(this.itemBagInfo));
    console.info("[expiredDeal]目前商品是否过期： "+isInEffectiveDate(this.itemBagInfo));
    // 判断是否已过期
    if (!isInEffectiveDate(this.itemBagInfo)) { // 不在保质期内，判断正确
      this.foodBag = deleteBagListItem(this.foodBag, this.selectItemId);
      this.character.money = this.character.money + 10;
      character_LiteStore.setValue(JSON.stringify(this.character));
      foodBag_LiteStore.setValue(JSON.stringify(this.foodBag));
      // 关闭弹窗，关闭说明书页面
      this.openDocument = false;
      // 打开恭喜对话框
      let talk:TalkData = new TalkData('食品监管阿串',$rawfile('avatar_manager_white.png'));
      talk.message = "你真棒，食品过期往往意味着食品中有物质变质了，这个过程会产生新的化学物质，对我们的身体有害。你的判断很正确！"
      this.talkDialogController = new CustomDialogController({
        builder: TalkDialog({
          avatar: talk.avatar,
          name: talk.name,
          message: talk.message
        }),
        autoCancel:true,
        customStyle:true,
        offset:{dx:0, dy:-30},
        alignment: DialogAlignment.Bottom,
      })
      this.talkDialogController.open();
    } else {
      // 打开恭喜对话框
      let talk:TalkData = new TalkData('食品监管阿串',$rawfile('avatar_manager_white.png'));
      talk.message = "判断错啦，物品还没有过期！这确实有一点困难，但是我相信你会孰能生巧的，加油！"
      this.talkDialogController = new CustomDialogController({
        builder: TalkDialog({
          avatar: talk.avatar,
          name: talk.name,
          message: talk.message
        }),
        autoCancel:true,
        customStyle:true,
        offset:{dx:0, dy:-30},
        alignment: DialogAlignment.Bottom,
      })
      this.talkDialogController.open();
    }
    this.deleteDialogController.close();
  }
  /**
   * 直接丢弃
   */
  nonExpiredDeal = ()=> {
    console.info("[nonExpiredDeal]判断直接丢弃")
    console.info("[nonExpiredDeal]目前背包："+JSON.stringify(this.foodBag));
    console.info("[nonExpiredDeal]目前选中物品编号："+this.selectItemId.toString());
    this.foodBag = deleteBagListItem(this.foodBag, this.selectItemId);
    //        写入数据库
    foodBag_LiteStore.setValue(JSON.stringify(this.foodBag));
    this.deleteDialogController.close();
    this.openDocument = false;
    // 打开恭喜对话框
    let talk:TalkData = new TalkData('食品监管阿串',$rawfile('avatar_manager_white.png'));
    talk.message = "珍惜粮食很重要，定期清理不需要的物品也很重要！"
    this.talkDialogController = new CustomDialogController({
      builder: TalkDialog({
        avatar: talk.avatar,
        name: talk.name,
        message: talk.message
      }),
      autoCancel:true,
      customStyle:true,
      offset:{dx:0, dy:-30},
      alignment: DialogAlignment.Bottom,
    })
    this.talkDialogController.open();
  }

  /**
   * 动画调用
   */
  responseAnimation(){
    let random = getRandomNum(0,1);
    // 每1s对图片执行一次旋转
    let timeId = setInterval(()=>{
      // 随机动画
      if (random == 0) { // 摇摆
        let angle = angles[index++];
        this.matrix1 = matrix4.identity().rotate({x:1, y:1, z:2, angle:angle});
        if (index >= angles.length) {
          index = 0;
        }
      } else { // 跳跃
        let position = positions[index++];
        this.matrix1 = matrix4.identity().translate({x:Number(position.x), y:Number(position.y), z:2});
        if (index >= positions.length) {
          index = 0;
        }
      }
    },300)
    setTimeout(()=>{
      clearInterval(timeId);
    },1500)
  }
  build() {
    Column() {
      if (this.defaultBagList || this.foodBag.length == 0) {
        Column({space: 5}) {
          Text('粮仓里面空空的，去商店看看吧')
            .fontSize(25).fontStyle(FontStyle.Italic)
            .height('20%').width('70%')
          Button('阿串的商店')
            .onClick(()=>{
              router.push({
                uri: 'pages/store'
              })
            })
        }.height('50%').width('100%').alignItems(HorizontalAlign.Center)
      }else {
        if (this.openDocument) {
          // 说明书
          Column({space: 5}) {
            Row({space: 10}) {
              Image(this.itemInfo.imgURL)
                .objectFit(ImageFit.Contain).width(100).height(100)
              Column({space: 10}){
                Row() {
                  Row({space: 5}) {
                    Text(this.itemInfo.title).fontSize(30)
                    Image($rawfile('icon_voice_dark.png'))
                      .objectFit(ImageFit.Contain).width(30).height(30)
                      .onClick(()=>{
                        let audioPlayer = media.createAudioPlayer();
                        audio_On_Play(audioPlayer);
                        let audioHTTP = this.itemInfo.relativeContent;
                        if (audioHTTP != '') {
                          audioPlayer.src = audioHTTP;
                          console.info('【Leciron~~】正在播放 '+ audioHTTP)
                          prompt.showToast({
                            message: audioHTTP,
                            duration: 3000
                          })
                        }
                      })
                  }
                  Button('返回列表')
                    .onClick(()=>{
                      this.openDocument = false;
                    })
                }.width('70%').justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  Text('健康值：'+this.itemInfo.health).fontSize(25)
                  Text('饥饿值：'+this.itemInfo.hunger).fontSize(25)
                }.width('65%').justifyContent(FlexAlign.SpaceBetween)
              }.alignItems(HorizontalAlign.Start)
            }.width('100%').height('25%').padding({top:10})
            Column({space: 10}) {
              Text('【使用说明】').fontSize(25).fontWeight(FontWeight.Bold).padding({top:10})
              Text(this.itemInfo.introduction).fontSize(23).width('90%').height('45%').padding({left:20})
              Row({space: 10}) {
                Text('【生产日期】').fontSize(25).fontWeight(FontWeight.Bold)
                Text(getDateStr(this.itemBagInfo.produceDate)).fontSize(25)
              }
              Row({space: 10}) {
                Text('【保质期】').fontSize(25).fontWeight(FontWeight.Bold)
                Text(this.getReserveString(this.itemInfo.reserve)).fontSize(25)
              }
            }.width('90%').height('60%').borderRadius(16).backgroundColor(0xFAEEE0)
            .alignItems(HorizontalAlign.Start)
            Row() {
              Button('去喂食').fontSize(20).onClick(()=>{
                if (this.character.hunger > 80) {
                  this.wish = new WishData(WishType.Emotion);
                  let emotion:EmotionData = getRandomNegativeEmotion();
                  emotion.title = '我好撑，一点都吃不进去了！！';
                  this.wish.classInfo = JSON.stringify(emotion);
                  this.handlePopup = true;
                } else {
                  // 洗手值
                  if (this.handClean < 20) {
                    // 振动器
                    this.textDialogController.open()
                    let len = this.virusList.length;
                    if (len == 3) {
                      for (let i=0;i<len-1;i++) {
                        this.virusList[i]=this.virusList[i+1];
                      }
                    }
                    this.virusList.push(VIRUS);
                    this.wish = getRandomSickWish();
                    vibrator.vibrate(1000, (error) => {})
                  }
                  // 判断物品是否在保质期内
                  if (!isInEffectiveDate(this.itemBagInfo)){
                    let len = this.virusList.length;
                    if (len == 3) {
                      for (let i=0;i<len-1;i++) {
                        this.virusList[i]=this.virusList[i+1];
                      }
                    }
                    this.virusList.push(TIMEOUT);
                    prompt.showToast({
                      message:'糟糕，要拉肚肚了！！',
                      duration:2000
                    })
                    //                  数值修改
                    let health:number = 0;
                    let favor:number = 0;
                    let prob = getRandomNum(0,10);
                    if (prob>2) { // 随机可能影响健康情况
                      health = this.character.health - 2;
                      if (health<0) {
                        health = 0;
                        favor = this.character.favor - 5;
                      } else {
                        favor = this.character.favor - 2;
                      }
                      if (favor<0) {
                        favor = 0;
                      }
                      this.character.health = health;
                      this.character.favor = favor;
                    }
                  } else { // 物品在保质期内
                    this.responseAnimation();
                    // 和愿望符合，会增加好感度
                    if (this.wish.type == WishType.FoodData) {
                      let foodId = JSON.parse(this.wish.classInfo).foodId;
                      if (foodId == this.itemInfo.foodId) { // 愿望满足
                        let favor:number = 0;
                        let prob = getRandomNum(1,10);
                        if (prob > 5) {
                          this.wish = getRandomPositiveWish();
                        }
                        favor = this.character.favor + 10;
                        if (favor > 100) {
                          favor = 100;
                        }
                        this.character.favor = favor;
                      } else { // 愿望比满足
                        let prob = getRandomNum(1,10);
                        if (prob > 5) {
                          this.wish = getRandomNegativeWish();
                        }
                      }
                    }
                    //       修改保质期内：健康值
                    let curHealth = this.character.health+this.itemInfo.health;
                    if (curHealth>5){
                      this.character.health = 5;
                    }else {
                      this.character.health = curHealth;
                    }
                    //        给特定物品添加效果
                    if (this.handClean==100){
                      if (this.itemInfo.type == 'mainfood' || this.itemInfo.type == 'vegetable' ||
                      this.itemInfo.type == 'meat' || this.itemInfo.title == '鲜牛奶' || this.itemInfo.title == '酸奶') {
                        let len = this.virusList.length;
                        if (len == 3) {
                          for (let i=0;i<len-1;i++) {
                            this.virusList[i]=this.virusList[i+1];
                          }
                        }
                        this.virusList.push(HEALTHY);
                      }
                    }
                  }
                  // 修改宠物属性
                  // 删除物品 - 目前只有UI，还需要动画、数据库更新
                  //       修改饥饿值
                  let curHunger = this.character.hunger+this.itemInfo.hunger;
                  if (curHunger>100){
                    this.character.hunger = 100;
                  }else {
                    this.character.hunger = curHunger;
                  }
                  if (this.character.hunger > 80) {
                    this.img = hungerResponse[this.character.characterIndex].full;
                    this.wish = new WishData(WishType.Emotion);
                    let emotion:EmotionData = getRandomPositiveEmotion();
                    emotion.title = '吃得好饱呀，真开心！！！';
                    this.wish.classInfo = JSON.stringify(emotion);
                    this.handlePopup = true;
                  }
                  //        渲染健康值
                  this.heartList = getHeartList(this.character.health);
                  console.info('[Leciron~~] Print Health Value: '+this.character.health.toString())
                  this.foodBag = deleteBagListItem(this.foodBag, this.selectItemId);
                  //        写入数据库
                  character_LiteStore.setValue(JSON.stringify(this.character));
                  foodBag_LiteStore.setValue(JSON.stringify(this.foodBag));
                  this.openDocument = false; // 关闭说明书页面
                  if (this.foodBag.length == 0) {
                    this.defaultBagList = true;
                  }
                }
              })
              Button('扔垃圾').fontSize(20).onClick(()=>{
                // 添加弹窗，过期食品处理，不需要食品处理
                this.deleteDialogController = new CustomDialogController({
                  builder:DeleteDialog({
                    expiredDeal: this.expiredDeal,
                    nonExpiredDeal: this.nonExpiredDeal
                  }),
                  autoCancel:true,
                  customStyle:true
                })
                this.deleteDialogController.open();
              })
            }.width('100%').height('10%').justifyContent(FlexAlign.SpaceAround)
          }.width('90%').height('85%').borderRadius(10).backgroundColor(0xFFFFFF)
        }else {
          // 食物列表
          Column() {
            List({ space: 20, initialIndex: 0 }) {
              ForEach(this.foodBag, (item: any,listIndex:number) => {
                ListItem() {
                  BagItem({
                    item:getFoodById(item.index),
                  })
                }.onClick(() => {
                  // 打开说明书页面
//                  this.selectItemId = item.id;
                  this.selectItemId = listIndex;
                  this.itemInfo = getFoodById(item.index)
                  this.itemBagInfo = item;
                  this.openDocument = true;
                })
              }, (item:any,listIndex:number) => listIndex.toString())
            }.width('90%').height('85%')
          }.width('100%').padding({ top: 10 })
        }
      }
    }.height('100%').backgroundColor(0xDCDCDC)
  }
}