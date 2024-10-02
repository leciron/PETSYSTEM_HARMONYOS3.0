import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import { getFoodDatas } from '../feed/model/FoodDataModel';
import { KvStoreModel } from '../test_store/model/KvStoreModel';
import router from '@system.router';
import { SelectableFoodItem } from '../test_store/common/SelectableFoodItem';
import { FoodItemDataModel } from '../test_store/model/FoodItemDataModel';
import prompt from '@ohos.prompt';
import featureAbility from '@ohos.ability.featureAbility';
import { FoodData , transStrToFoodData} from '../feed/model/FoodData';

// 数据库 数据读取相关变量
let kvStoreModel: KvStoreModel = new KvStoreModel()
let foodList: Array<FoodData> = getFoodDatas();
// 存储商店显示物品
const Food_Store_Change = "foodStore_change";

/**
 * 手机页面 - 选择希望展示的食物项目，结合pad端的store页面测试
 * 需要写入分布式数据库
 */
@Entry
@Component
struct PhoneFood {
  @State message: string = 'Hello World';
  // 页面渲染、修改数据库 相关变量
  @State foods: Array<FoodData> = [];
  @State updateList: Array<FoodItemDataModel> = [];
  // 手动数据库同步
  @State deviceState: string = '同步失败！'
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

  aboutToAppear(){
    //获取设备权限
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 666)
    // 获取周边设备
    this.getDevice();
    console.info('[aboutoAppear]foodList '+JSON.stringify(foodList))
    // 创建数据库，安装监听器
    kvStoreModel.setOnMessageReceivedListener(Food_Store_Change, (value) => {
      console.info('kvstore[Phone_FoodPage] Food_Store_CHANGE' + value)
      foodList = transStrToFoodData(value)
      // 不知道有没有用
      setInterval(() => {
        this.foods = foodList;
      }, 500)
    });

  }

  onPageShow(){
    this.foods = foodList;
  }

  // SelectableFoodItem内部回调函数
  handleSelectFood(index: number, isOn: boolean) {
    foodList[index].isVisible = isOn;
  }

  build() {
    Column() {
      Row(){
        Text('请选择阿串商店的上架物品~')
          .fontSize(16).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
          .onClick(()=>{
            console.info('[Text]foodList '+JSON.stringify(foodList))
          })
        Button('返回首页').onClick(()=>{
          router.push({
            uri:'pages/phoneIndex'
          })
        })
      }.width('100%').height(80).backgroundColor('#6495ed')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({right:5,left:5})
      Column() {
        List() {
          ForEach(this.foods,item=>{
            ListItem(){
              SelectableFoodItem({
                food:item,
                handleSelectFood: this.handleSelectFood
              });
            }
          },item=>item.title.toString())
        }
      }
      .width('100%').height('72%')
      Row() {
        Button('选好啦！').alignSelf(ItemAlign.Center)
          .onClick(()=>{
            console.info('按钮前')
            // 存入数据库并同步
            kvStoreModel.put(Food_Store_Change, JSON.stringify(foodList), ()=>{
              kvStoreModel.kvStore.sync(this.deviceIds, 1)
              console.info('商店物品，数据同步成功！')
              for (let i=0;i<foodList.length;i++) {
                console.info(foodList[i].title + ' ' + foodList[i].isVisible)
              }
              prompt.showToast({
                message: '商品信息已传送~',
                duration: 1000,
              })
            })
          })
      }.height(100)
    }
    .width('100%')
  }
}