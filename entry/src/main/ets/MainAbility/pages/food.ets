import matrix4 from '@ohos.matrix4';
import { EmotionType , EmotionData, VisibleItem, getRandomNegativeEmotion} from '../feed/model/EmotionData';
import { WishData , getRandomWish, WishType, getRandomFoodWish, getRandomEmotionWish} from '../feed/model/WishData';
import { getRandomNum } from '../utils/DateUtil';
import { HeartData , getHeartList, heart} from '../feed/model/HeartData';
import { HealthHeartList } from '../feed/component/HealthHeartList';
import { AnimalData } from '../create/model/AnimalData';
import { getAnimalById , hungerResponse} from '../create/model/AnimalDataModel';
import CharacterData from '../create/model/CharacterData';
import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import { HygieneImageShakeDialog } from '../feed/component/HygieneImageShakeDialog';
import prompt from '@ohos.prompt';
import router from '@system.router';
import { BagList } from '../feed/component/BagList';

let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);
const subHungerSecond:number = 5;

let TIME_ID;

const favorWords = [
  '我会很大声告诉你，我也很喜欢你！','无论你是什么样子，我都超级喜欢你！',
  '如果我有做的不好的地方，我下次会注意，谢谢你的谅解啦。',
  '我也想知道，你对我是怎么想的呀？','虽然我还有很多不知道的事，但世界那么大，还有你在呀！'
];

// virusList数据
let VIRUS:VisibleItem = new VisibleItem('virus',$rawfile('hygiene_virus.png'),true,"饭前没洗手，细菌入口了！");
let HEALTHY:VisibleItem = new VisibleItem('healthy',$rawfile('hygiene_healthy.png'),true,"你为我的健康身体补充了营养");
let TIMEOUT:VisibleItem = new VisibleItem('virus',$rawfile('hygiene_overtime.png'),true,"吃了过期食品");
let SANITIZER:VisibleItem = new VisibleItem('sanitizer',$rawfile('hygiene_soap.png'),true,"洗手时用了洗手液，冲走大部分细菌。");

@Entry
@Component
struct Food {
  @State message: string = 'Hello World'
  // 表情名称
  @State emotion: string = 'emotion_unwilling.png'
  // 宠物
  @State character: CharacterData = {characterName:'测试阿串',characterIndex:3,
    hunger: 10, health: 3, money: 60, favor: 100, experience: 100,isOnUse: 'true'};
  @State animalInfo: AnimalData = getAnimalById(this.character.characterIndex);
  @State img:Resource = this.animalInfo.imgURL;
  @State clickHunger: boolean = false; // 是否点击饱腹感
  @State clickFavor: boolean = false; // 是否点击好感度
  @State favorTime: number = 0;
  // 交互数据
  @State handClean:number = 0;
  @State teethClean:number = 100;
  @State heartList:Array<HeartData>=getHeartList(this.character.health);
  @State virusList:Array<VisibleItem> = [];
  // 动画 - 宠物动作
  @State angle:number = 0;
  @State yChange:number = 0;
  @State matrix1:any = '';
  // 随机
  @State handlePopup:boolean = false;
  @State wish:WishData = getRandomWish();
  washHandDialogController: CustomDialogController = new CustomDialogController({
    builder: HygieneImageShakeDialog({
      // 在创建弹窗时执行
      cancel: this.autoCancelWashDialog('真棒！',3),
      duration: 90,
      timeIncrement:15,
      imgURL:$rawfile('hygiene_washhand.png'),
      angle:30,
      title:'',
    }),
    autoCancel:false,
    customStyle:true
  })
  brushTeethDialogController: CustomDialogController = new CustomDialogController({
    builder: HygieneImageShakeDialog({
      // 在创建弹窗时执行
      cancel: this.autoCancelBrushDialog('真棒！',3),
      duration: 90,
      timeIncrement:15,
      imgURL:$rawfile('hygiene_brush.png'),
      angle:30,
      title:'',
    }),
    autoCancel:false,
    customStyle:true
  })

  // 随机愿望
  @Builder popupBuilder(){
    if (this.wish.type === WishType.Words) {
      Row() {
        Text(this.wish.message).fontSize(25)
          .width(270).height(90).padding({left:10,right:10})
      }.width(300).height(100)
    } else if (this.wish.type === WishType.Emotion) {
      Row() {
        Image(JSON.parse(this.wish.classInfo).img).width(90).height(90)
          .objectFit(ImageFit.Contain).width(90).height(90)
          .padding({left:5,right:5})
        Text(JSON.parse(this.wish.classInfo).title).fontSize(20)
          .width(200).height(90)
      }.width(300).height(100)
    } else if (this.wish.type === WishType.FoodData ) {
      Column({ space: 2 }) {
        Image(JSON.parse(this.wish.classInfo).imgURL).width(50).height(50)
          .objectFit(ImageFit.Contain).width(50).height(50)
          .padding({top:10})
        Text(this.wish.message).fontSize(20)
      }.width(200).height(100)
    } else { // WishType.Sick
      Column({ space: 2 }) {
        Row({space:5}) {
          Image(JSON.parse(this.wish.classInfo).img).width(50).height(50)
            .objectFit(ImageFit.Contain).width(50).height(50)
          Text('(生病了)').fontSize(20)
        }
        Text(JSON.parse(this.wish.classInfo).title).fontSize(20)
      }.width(200).height(100)
    }
  }

  async aboutToAppear(){
    console.info('[aboutToAppear]打印wish： '+JSON.stringify(this.wish));
    // 获取角色信息
    let str = <string> await character_LiteStore.getValue();
    console.info('获取数据' + str);
    this.character = JSON.parse(str);
    this.animalInfo = getAnimalById(this.character.characterIndex);
    // 初始化交互数据
    this.heartList = getHeartList(this.character.health);
    if (this.character.hunger <= 5) {
      this.img = hungerResponse[this.animalInfo.animalId].hungry;
      this.wish = new WishData(WishType.Emotion);
      let emotion:EmotionData = getRandomNegativeEmotion();
      emotion.title = '我快饿扁啦！好饿啊！！！';
      this.wish.classInfo = JSON.stringify(emotion);
      this.handlePopup = true;
      console.info('饿扁了')
    } else if (this.character.hunger >= 90) {
      this.img = hungerResponse[this.animalInfo.animalId].full;
      console.info('超饱的')
    } else {
      this.img = this.animalInfo.imgURL;
      this.wish = getRandomWish();
      console.info('还能玩')
    }
    // 每次进入页面，刷新饥饿值减少量
    let subHunger = getRandomNum(0,5);
    let temp = this.character.hunger - subHunger;
    if (temp <0) {
      temp = 0;
    }
    this.character.hunger = temp;

    TIME_ID = setInterval(()=>{
      if (this.character.hunger != 0) {
        this.character.hunger = this.character.hunger - 1;
        if (this.character.hunger <= 5) {
          this.img = hungerResponse[this.animalInfo.animalId].hungry;
          this.wish = new WishData(WishType.Emotion);
          let emotion:EmotionData = getRandomNegativeEmotion();
          emotion.title = '我快饿扁啦！好饿啊！！！';
          this.wish.classInfo = JSON.stringify(emotion);
          this.handlePopup = true;
          console.info('饿扁了')
        } else if (this.character.hunger <= 90 && this.character.hunger > 5) {
          this.img = this.animalInfo.imgURL;
        }

        if (this.character.hunger == 87) {
          this.wish = getRandomWish();
        }
      }
      console.info('饥饿值减少了1，目前还有'+this.character.hunger.toString());
    },subHungerSecond*1000)
  }

  async writeInStore(){
    await character_LiteStore.setValue(this.character);
  }

  onPageHide(){
    this.writeInStore();
    clearInterval(TIME_ID);
    console.info('离开喂食页面');
  }

  /**
   * 设置动画播放时长以及动画结束后的toast内容
   * @param finishText
   * @param showTime
   */
  autoCancelWashDialog(finishText:string,showTime:number) {
    setTimeout(()=>{
      this.washHandDialogController.close();
      this.handClean = 100;
      prompt.showToast({
        message: finishText,
        duration: 1000
      })
    },showTime*1000)
  }

  /**
   * 设置动画播放时长以及动画结束后的toast内容
   * @param finishText
   * @param showTime
   */
  autoCancelBrushDialog(finishText:string,showTime:number) {
    setTimeout(()=>{
      this.brushTeethDialogController.close()
      prompt.showToast({
        message: finishText,
        duration: 1000
      })
    },showTime*1000)
  }
  /**
   * 删除病毒
   */
  deleteVirus():Array<VisibleItem>{
    let list:Array<VisibleItem> = [];
    for (let i=0;i<this.virusList.length;i++) {
      if ('virus' != this.virusList[i].title) {
        list.push(this.virusList[i]);
      }
    }
    return list;
  }

  build() {
    Row() {
      Column({space: 5}) {
        Row({ space: 20 }) {
          Column({space: 10}) {
            // 进度条
            Stack() {
              Image($rawfile('icon_process_hand.png')).width(50).height(50)
                .objectFit(ImageFit.Contain).width(50).height(50)
              if (this.handClean < 20) {
                Image($rawfile('hygiene_virus.png')).width(30).height(30)
                  .objectFit(ImageFit.Contain).width(30).height(30)
              }
              Progress({ value: this.handClean, total: 100, type: ProgressType.Ring})
                .color(Color.Blue).value(this.handClean).width(100)
                .style({ strokeWidth: 20, scaleCount: 30, scaleWidth: 20})
            }.onClick(()=>{
              if (this.handClean < 20) {
                this.washHandDialogController.open();
                this.virusList.push(SANITIZER);
                this.virusList = this.deleteVirus();
                let len = this.virusList.length;
                if (len == 3) {
                  for (let i=0;i<len-1;i++) {
                    this.virusList[i]=this.virusList[i+1];
                  }
                }

              } else {
                prompt.showToast({
                  message:'手已经很干净啦，洗太多次会对皮肤有损伤哦！',
                  duration: 2000
                })
              }
            })
            // 文字说明
            Text('手清洁').fontSize(16)
          }
          Column({space: 10}) {
            // 进度条
            Stack() {
              Image($rawfile('icon_process_tooth.png')).width(50).height(50)
                .objectFit(ImageFit.Contain).width(50).height(50)
              Progress({ value: 20, total: 100, type: ProgressType.Ring})
                .color(Color.Blue).value(60).width(100)
                .style({ strokeWidth: 20, scaleCount: 30, scaleWidth: 20})
            }.onClick(()=>{
              this.brushTeethDialogController.open()
            })
            // 文字说明
            Text('牙清洁').fontSize(16)
          }
          Column({space: 10}) {
            // 进度条
            Stack() {
              Image($rawfile('icon_process_like.png')).width(45).height(45)
                .objectFit(ImageFit.Contain).width(45).height(45)
              if (this.clickFavor) {
                Text(this.character.favor.toString()+'%').fontSize(22).fontStyle(FontStyle.Italic)
                  .fontWeight(FontWeight.Bold)
              }
              Progress({ value: 20, total: 100, type: ProgressType.Ring})
                .color(Color.Blue).value(this.character.favor).width(100)
                .style({ strokeWidth: 20, scaleCount: 30, scaleWidth: 20})
            }
            .onClick(()=>{
              // test
              getRandomNegativeEmotion();
              // end
              this.favorTime++;
              if (this.favorTime>=5){
                let temp:WishData = new WishData(WishType.Words);
                let rdmIndex = getRandomNum(0,favorWords.length-1);
                temp.message = favorWords[rdmIndex];
                this.wish = temp;
                this.favorTime = 0;
              }
              this.clickFavor = true;
              console.info('用户点击了好感度')
              setTimeout(()=>{
                this.clickFavor = false;
              },5000)
            })
            // 文字说明
            Text('好感度').fontSize(16)
          }
          Column({space: 10}) {
            // 进度条
            Stack() {
              Image($rawfile('icon_process_stomach.png')).width(45).height(45)
                .objectFit(ImageFit.Contain).width(45).height(45)
              if (this.clickHunger) {
                Text(this.character.hunger.toString()+'%').fontSize(22).fontStyle(FontStyle.Italic)
                  .fontWeight(FontWeight.Bold)
              }
              Progress({ value: 20, total: 100, type: ProgressType.Ring})
                .color(this.character.hunger>=90?'#F7CE00':Color.Blue).value(this.character.hunger).width(100)
                .style({ strokeWidth: 20, scaleCount: 30, scaleWidth: 20})
            }
            .onClick(()=>{
              this.clickHunger = true;
              console.info('用户点击了饥饿值')
              setTimeout(()=>{
                this.clickHunger = false;
              },5000)
            })
            // 文字说明
            Text('饱腹感').fontSize(16)
          }
        }.height('20%').margin({top:10})

        Column() {
          Stack(){
            Column() {
              // 回首页，健康值
              Row() {
                Row() {
                  Image($rawfile('icon_left_home.png')).width(35).height(35)
                    .objectFit(ImageFit.Contain).width(35).height(35)
                  Image($rawfile('icon_home.png')).width(50).height(50)
                    .objectFit(ImageFit.Contain).width(50).height(50)
                }.onClick(() => {
                  this.writeInStore();
                  router.push({
                    uri: 'pages/index'
                  })
                })

                Row({ space: 10 }) {
                  Text('健康值').fontSize(25).fontStyle(FontStyle.Italic)
                  HealthHeartList({ list: $heartList })
                }.width('60%')
                .margin({ left: 70 })
              }.width('100%')
//              .offset({ x: 0, y: '-5%' })
              .justifyContent(FlexAlign.Center)

              Grid(){
                ForEach(this.virusList,(item:VisibleItem,index:number)=>{
                  GridItem(){
                    Image(item.imgURL).width(100).height(100)
                      .objectFit(ImageFit.Contain).width(100).height(100)
                  }
                  .visibility(item.isVisible?Visibility.Visible:Visibility.Hidden)
                  .onClick(()=>{
                    prompt.showToast({
                      message: item.content,
                      duration: 2000
                    })
                  })
                },(item:VisibleItem,index:number)=>index.toString())
              }.columnsTemplate('1fr')
              .rowsTemplate('1fr 1fr 1fr')
              .width(100).height(320)
              .offset({x:'35%',y:0})
            }.width('100%').height('100%')

            Image(this.img).width(300).height(300)
              .objectFit(ImageFit.Contain).width(300).height(300)
//              .transform(this.matrix1.combine(this.matrix2))
              .transform(this.matrix1)
              .onClick(()=>{
                this.handlePopup = true;
              })
              .bindPopup(this.handlePopup,{
                builder:this.popupBuilder(),
                placement: Placement.Top,
                enableArrow: true,
                popupColor:Color.White,
                onStateChange: (e) => {
                  if (!e.isVisible) {
                    this.handlePopup = false;
                  }
                }
              })
          }.width('100%').height('80%')
//          .backgroundColor(Color.Yellow)
        }.padding({top:20})

      }.width('50%').height('100%')

      Column() {
        List() {
          ListItem(){
            Row(){
              Text('我的粮仓').fontSize(30).fontWeight(FontWeight.Bold)
              Row({ space: 5 }) {
                Image($rawfile('icon_property_coin.png')).width(30).height(30)
                  .objectFit(ImageFit.Contain).width(30).height(30)
                Text(this.character.money.toString()).fontSize(25).fontWeight(FontWeight.Bold)
              }
            }.width('100%')
            .padding({left: 5, right: 10})
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
        BagList({
          handClean: $handClean,
          character: $character,
          heartList: $heartList,
          virusList: $virusList,
          img: $img,
          handlePopup: $handlePopup,
          wish:$wish,
          matrix1: $matrix1
        })
      }.height('100%').width('50%').backgroundColor(0xDCDCDC)
    }
  }
}