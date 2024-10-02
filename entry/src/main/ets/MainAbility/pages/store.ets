import CharacterData from '../create/model/CharacterData';
import FoodBagData , { transStrToFoodBagData} from '../create/model/FoodBagData';
import { getFoodDatas } from '../feed/model/FoodDataModel';
import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import { BuyDialog } from '../test_store/common/BuyDialog';
import router from '@system.router';
import featureAbility from '@ohos.ability.featureAbility';
import prompt from '@ohos.prompt';
import { KvStoreModel } from '../test_store/model/KvStoreModel';
import { FoodData , transStrToFoodData} from '../feed/model/FoodData';
import { getRangeDate, getRandomNum} from '../utils/DateUtil';

// 分布式数据库 数据读取相关变量
let kvStoreModel: KvStoreModel = new KvStoreModel()
let foodList: Array<FoodData> = [];
// 存储商店显示物品
const Food_Store_Change = "foodStore_change";
const frameSize = 102;
// 数据库
let foodBag_LiteStore = new LiteStore(LiteStoreConstants.BAG_FOOD_KEY);
let tablet_Store = new LiteStore(LiteStoreConstants.TABLET_FOOD_STORE_KEY);
let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);

const block = ['block_blue.jpg','block_green.jpg','block_greenColor.jpg','block_greenGrape.jpg','block_pink.jpg',
'block_pinkPlay.jpg','block_purple.jpg','block_yellow.jpg','block_yellowPink.jpg']
let randomBlockIndex:number;
const avatar = ['store_avatar_red.png','store_avatar_red2.png','store_avatar_red3.png'];
let randomAvatarIndex:number;

/**
 * 本页面主要 - 渲染所有物品列表
 */
@Entry
@Component
struct Store {
  private dialogController: CustomDialogController = null;
  @State test: string = '我是测试';
  @State character:CharacterData = {characterName:'测试阿串',characterIndex:3,
    hunger: 100, health: 5, money: 60, favor: 100, experience: 100,isOnUse: 'true'};
  @State message: string = '欢迎来到阿串的商店~';
  @State foods: Array<FoodData> = [];
  @State offsetValue:number = 0;
  // 购物车数据
  @State buyList: Array<FoodBagData> = [];
  // 手动数据库同步
  @State deviceState: string = '同步失败！';
  deviceIds: string[] = []
  //获取周边设备
  async getDevice(){
    var ret = await FeatureAbility.getDeviceList(0)
    if (ret.code != 0) {
      this.deviceState = '同步失败！'
      prompt.showToast({
        message: '同步失败！',
        duration: 1000,
      });
      return
    }
    this.deviceState = '已同步的设备'
    // @ts-ignore
    this.deviceState = this.deviceName + '(' + ret.data.length + '个):'
    // @ts-ignore
    for (var i: number = 0;i < ret.data.length; i++) {
      this.deviceIds.push(ret.data[i].networkId)
      this.deviceState = this.deviceState + ret.data[i].deviceName + ' '
    }
    prompt.showToast({
      message: '同步成功',
      duration: 1000,
    });
  }

  // 从数据库拉信息，筛选展示isVisible为true的物品
  async onPageShow(){
//    let str = <string> await tablet_Store.getValue();
//    this.foods = JSON.parse(str);
    // 测试：购买商品
    this.foods = getFoodDatas();
  }

  async aboutToAppear() {
    //获取设备权限
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 666)
    // 获取周边设备
    this.getDevice();
    console.info('[aboutoAppear]foodList '+JSON.stringify(foodList));
    randomBlockIndex = getRandomNum(0,block.length-1);
    randomAvatarIndex = getRandomNum(0,avatar.length-1);
    // 从数据库读数据
    let str = <string> await character_LiteStore.getValue();
    console.info('获取数据' + str);
    this.character = JSON.parse(str);
    // 创建分布式数据库，安装监听器
    kvStoreModel.setOnMessageReceivedListener(Food_Store_Change, (value) => {
      console.info('kvstore[Phone_FoodPage] Food_Store_CHANGE' + value)
      foodList = transStrToFoodData(value)
      // 每500毫秒执行一次
      setInterval(() => {
        this.foods = this.isVisibleFilter(foodList);
      }, 500)
    });
  }

  // 筛选所有可见物品
  isVisibleFilter(param:Array<FoodData>):Array<FoodData> {
    let list:Array<FoodData> = [];
    for (let i=0; i < param.length;i++) {
      if (param[i].isVisible === true) {
        list.push(param[i]);
      }
    }
    return list;
  }

  // 显示弹窗
  showBuyDialog(item: FoodData){
    // 每次重新创建弹窗
    this.dialogController = new CustomDialogController({
      builder: BuyDialog({
        food: item,
        buyAction: this.buyAction,
      }),
      // 点击窗口周边(遮罩层)，实现关闭
      autoCancel: true
    })
    this.dialogController.open()
  }

  // 弹窗中：点击购买后的回调函数
  buyAction = (item:FoodData)=>{
    let curMoney = this.character.money - item.price;
    if (curMoney<0) {
      this.message = '你的钱还不够哦，赊账可不是个好习惯呀。'
      setTimeout(() => {
        this.message = '欢迎来到阿串的商店~';
      }, 5000)
    } else {
      // 增加背包数据
      let buy:FoodBagData = {index:item.foodId, produceDate: '', amount:0};
      let dateStr = item.reserve.split(' ');
      let date = Number(dateStr[0]);
      buy.produceDate = getRangeDate(-date-1,'random');
      console.info('打印获取的物品保质期限date：'+date.toString());
      console.info('[Leciron~~] 购买成功！');
      console.info('生产日期：'+ JSON.stringify(buy))
      this.buyList.push(buy);
      // 修改用户信息
      this.character.money = this.character.money - item.price;
      // 修改老板语录
      this.message = "感谢惠顾！阿串发财指日可待~";
      this.offsetValue = 75;
      // 写入数据库
      this.writeSingleItemInBag(buy);
      setTimeout(() => {
        this.message = '欢迎来到阿串的商店~';
        this.offsetValue = 0;
      }, 5000)
    }
  }

  // 每次点击【回家】按钮写入背包
  async writeInFoodBag() {
    // 获取oldBag中的数据
    let newBag:Array<FoodBagData> = [];
    let res = <string> await foodBag_LiteStore.getValue();
    let count = 0;
    if (res!='') {
      newBag = transStrToFoodBagData(res);
      count = newBag.length;
    }
    // 拼接buyList数据，整理编号，构成newBag
    for (let i=0;i<this.buyList.length;i++) {
      newBag.push(this.buyList[i]);
    }
    await foodBag_LiteStore.setValue(JSON.stringify(newBag))
    console.log("在商店购买商品如下：" + JSON.stringify(newBag))
    await character_LiteStore.setValue(JSON.stringify(this.character))
  }

  // 每次点击buy按钮写入
  async writeSingleItemInBag(item:FoodBagData) {
    // 获取oldBag中的数据
    let newBag:Array<FoodBagData> = [];
    let res = <string> await foodBag_LiteStore.getValue();
    if (res!='') {
      newBag = transStrToFoodBagData(res);
    }
    newBag.push(item);
    // 写入数据库
    await foodBag_LiteStore.setValue(JSON.stringify(newBag))
    console.log("在商店购买商品如下：" + JSON.stringify(newBag))
    await character_LiteStore.setValue(JSON.stringify(this.character))
    console.log('写入数据库用户数据：'+JSON.stringify(this.character))
  }

  async writeInStore() {
    await tablet_Store.setValue(JSON.stringify(this.foods));
  }

  build() {
    Column() {
      Stack() {
        // 店长
        Column() {
          Stack(){
            Image($rawfile(avatar[randomAvatarIndex])).width(120).height(120)
              .objectFit(ImageFit.Contain).width(120).height(120)
              .offset({x:this.offsetValue,y:0})
            Image($rawfile('store_coding.png')).width(250).height(250)
              .objectFit(ImageFit.Fill).width(250).height(163)
          }.alignContent(Alignment.Bottom)
          .onClick(()=>{
            console.info('打印当前offset值：'+this.offsetValue.toString());
            this.offsetValue = 75;
            setTimeout(()=>{
              this.offsetValue = 0;
              console.info('当前offset值已被设置为0');
            },3000)
          })
        }
        // 返回按钮 金币值
        Column() {
          Row() {
            Button('回家')
              .onClick(() => {
                // 写入背包数据库
                console.info('背包里的数据' + JSON.stringify(this.buyList))
                this.writeInStore();
                // 路由跳转
                router.push({
                  uri: 'pages/index'
                })
              }).width(100).fontSize(18)
            Row({ space: 5 }) {
              Image($rawfile('icon_property_coin.png')).width(50).height(50)
                .objectFit(ImageFit.Contain).width(50).height(50)
              Text(this.character.money.toString()).fontSize(20).fontWeight(FontWeight.Bold)
            }
          }
          .width('100%')
          .height('15%')
          .padding({ right: 30, left: 30 })
          .margin({ top: 20 })
          .justifyContent(FlexAlign.SpaceBetween)
          Row() {
            Button('设备同步')
              .onClick(() => {
                this.getDevice();
              }).width(100).fontSize(16)
            Stack() {
              Rect({ width: 300, height: 80 })
                .fill(0xFAEEE0).radius(10)
                .opacity(0.8)
              Text(this.message).fontSize(25).width(280).height(80)
                .borderRadius(15)
                .padding({left:20})
            }.alignContent(Alignment.Start)
          }
          .width('100%')
          .height('15%')
          .padding({ right: 30, left: 30 })
          .margin({ top: 20 })
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }.height('30%').width('100%')
      .alignContent(Alignment.Top)
      // 物品栏
      Column(){
        Grid() {
          ForEach(this.foods, (item: FoodData) => {
            GridItem() {
              Stack() {
                Image($rawfile('bg_wooden_frame.png')).width(frameSize).height(frameSize)
                  .objectFit(ImageFit.Contain).width(frameSize).height(frameSize)
                Rect({ width: 80, height: 75 })
                  .fill(Color.White).radius(8).opacity(0.6).offset({x: 1, y:0})
                Column() {
                  Image(item.imgURL).width(50).height(50)
                    .objectFit(ImageFit.Contain).width(50).height(50)
                  Row() {
                    Image($rawfile('icon_property_coin.png')).width(20).height(20)
                      .objectFit(ImageFit.Contain).width(20).height(20)
                    Text(item.price.toString()).fontSize(16)
                  }
                }

              }.alignContent(Alignment.Center)
            }.onClick(()=>{
              this.showBuyDialog(item);
              console.log('打开弹窗 '+ JSON.stringify(item))
            })
          }, item => item.foodId.toString())
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
        .columnsGap(5)
        .rowsGap(5)
        .width('80%')
        .height(320)
        .borderRadius(16)
        .backgroundImage($rawfile(block[randomBlockIndex]),ImageRepeat.XY)
        .margin({top:'5%'})
      }.width('100%').height('70%')
      .backgroundImage($rawfile(block[randomBlockIndex]),ImageRepeat.XY)
    }
    .height('100%')
  }
}