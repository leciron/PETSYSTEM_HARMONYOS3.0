import { PhoneTalkDialog } from '../feed/component/PhoneTalkDialog';
import { TalkData , getTalkDataByName} from '../feed/model/TalkData';
import { TalkDialog } from '../feed/component/TalkDialog';
import featureAbility from '@ohos.ability.featureAbility';
import prompt from '@ohos.prompt';
import { KvStoreModel } from '../test_store/model/KvStoreModel';
import deviceInfo from '@ohos.deviceInfo';
import { WasteType , WasteData, getAllWasteList, getWasteById} from '../feed/model/WasteData';

const showSize:number = 160;
const gridSize:number = 80;
const totalCount:number = 10;

const tips = ['等待信息','选择出题','选择答案'];

// 分布式数据库
const Receive_Change = "receive_change"
let kvStoreModel: KvStoreModel = new KvStoreModel()
let receiveNum:number = 0;

@Entry
@Component
struct Competiton {
  @State message: string = 'Hello World'
  @State tip:string = tips[0];
  @State wasteList:Array<WasteData> = getAllWasteList();
  @State sendFlag:boolean = true; // true出题状态，false接收状态
  @State waitFlag:boolean = true; // true等待中，false未等待（主要控制出题区是否渲染）
  @State isTablet:boolean = true; // 设备类型是否为平板，渲染方式不同
  @State turnCount:number = 0; // 轮数
  @State profit:number = 0;
  @State hasUpdateReception:boolean = false; // 接收数据已更新
  // 选择发送的垃圾
  @State wasteToSend:WasteData =   {
    id:6,
    title:'塑料袋',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_plasticBag.png'),
    imgSize: 100
  }
  // 接收的垃圾信息
  @State wasteReceive:WasteData = {
    id:0,
    title:'易拉罐',
    type:WasteType.Recycable,
    imgURL: $rawfile('waste_item_can.png'),
    imgSize: 100
  }
  // 手动数据库同步
  @State deviceState: string = '同步失败！';
  deviceIds: string[] = []
  // 弹窗
  talkController:CustomDialogController;
  openTalkController(item:TalkData) {
    if (this.isTablet) {
      this.talkController = new CustomDialogController({
        builder:TalkDialog({
          name:item.name,
          avatar:item.avatar,
          message:item.message
        }),
        autoCancel:true,
        customStyle:true,
        offset:{dx:0, dy:-30},
        alignment: DialogAlignment.Bottom,
      })
    } else {
      this.talkController = new CustomDialogController({
        builder:PhoneTalkDialog({
          name:item.name,
          avatar:item.avatar,
          message:item.message
        }),
        autoCancel:true,
        customStyle:true
      })
    }
    this.talkController.open();
  }

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
    if (deviceInfo.deviceType != "tablet") {
      this.isTablet = false;
    } else {
      this.isTablet = true;
    }
    //获取设备权限
    let context = featureAbility.getContext()
    context.requestPermissionsFromUser(['ohos.permission.DISTRIBUTED_DATASYNC'], 666)
    // 获取周边设备
    this.getDevice();
    console.info('[aboutoAppear]Receive_Waste_ID '+ Receive_Change);
    // 创建分布式数据库，安装监听器
    kvStoreModel.setOnMessageReceivedListener(Receive_Change, (value:number) => {
      console.info('kvstore[CompetitionPage] Receive_CHANGE' + value.toString())
      receiveNum = value;
      this.sendFlag = false;
      this.waitFlag = false;
      this.hasUpdateReception = true;
      // 每500毫秒执行一次
      setInterval(() => {
        this.wasteReceive = getWasteById(receiveNum);
      }, 500)
    });

  }

  /**
   * 获取当前提示语
   */
  getCurTip(){
    if (this.waitFlag) {
      this.tip = tips[0];
    } else {
      if (this.sendFlag) {
        this.tip = tips[1];
      } else {
        this.tip = tips[2];
      }
    }
  }

  build() {
    Column() {
      Row(){
        Stack() {
          // 金币 - 10组
          if (this.isTablet) {
            Column() {
              Row() {
                Row({ space: 20 }) {
                  Text('第 ' + this.turnCount.toString() + '/' + totalCount.toString() + ' 轮')
                    .fontSize(20).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
                  Text(this.tip).fontSize(20).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
                }
                Row({ space: 5 }) {
                  Image($rawfile('icon_property_coin.png')).width(35).height(35)
                    .objectFit(ImageFit.Contain).width(35).height(35)
                  Text(this.profit.toString()).fontSize(20)
                    .fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
                }
              }.height('30%').width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ right: 30, left: 30 })
            }.height('100%').width('100%')
          }
          //
          Column({ space: 5 }) {
            Text(this.sendFlag?this.wasteToSend.title:this.wasteReceive.title)
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
              .visibility(this.waitFlag?Visibility.Hidden:Visibility.Visible)
            Stack() {
              Rect({ width: showSize, height: showSize })
                .fill(Color.Pink).radius(10).opacity(0.6).offset({ x: 1, y: 0 })
              Image(this.sendFlag?this.wasteToSend.imgURL:this.wasteReceive.imgURL).width(showSize).height(showSize)
                .objectFit(ImageFit.Contain).width(showSize).height(showSize)
                .visibility(this.waitFlag?Visibility.Hidden:Visibility.Visible)
            }.height(showSize).width(showSize)

            if (this.sendFlag) {
              Row() {
                Button('出题！').fontSize(25).width(190).fontWeight(FontWeight.Bold)
                  .padding({top:5})
                  .onClick(() => {
                    this.sendFlag = false; // 发送结束后，进入做题模式
                    this.waitFlag = true; // 发送结束后，进入等待
                    //                  this.turnCount = this.turnCount + 1;
                    // 存入数据库并同步
                    kvStoreModel.put(Receive_Change, this.wasteToSend.id, () => {
                      kvStoreModel.kvStore.sync(this.deviceIds, 1)
                      console.info('商店物品，数据同步成功！')
                      prompt.showToast({
                        message: '商品信息已传送~',
                        duration: 1000,
                      })
                    })
                  })
              }.width('100%')
              .justifyContent(FlexAlign.Center)
            } else {
              Row() {
                Button('可回收').width('25%').fontSize(this.isTablet?25:18).fontWeight(FontWeight.Bold)
                  .margin({ left: 10, right: 10 })
                  .onClick(()=>{
                    this.sendFlag = true;
                    this.waitFlag = true;
                    // 判断逻辑并给分
                    if (this.hasUpdateReception) {
                      if (WasteType.Recycable === this.wasteReceive.type) {
                        this.profit+=10;
                        let cleaner:TalkData = getTalkDataByName('奖金-保洁阿串');
                        this.openTalkController(cleaner);
                      } else {
                        let cleaner:TalkData = getTalkDataByName('夸夸群-保洁阿串');
                        this.openTalkController(cleaner);
                      }
                      this.hasUpdateReception = false;
                    }
                  })
                Button('厨余').width('25%').fontSize(this.isTablet?25:18).fontWeight(FontWeight.Bold)
                  .margin({ left: 10, right: 10 })
                  .onClick(()=>{
                    this.sendFlag = true;
                    this.waitFlag = true;
                    if (this.hasUpdateReception) {
                      if (WasteType.Household === this.wasteReceive.type) {
                        this.profit+=10;
                        let cleaner:TalkData = getTalkDataByName('奖金-保洁阿串');
                        this.openTalkController(cleaner);
                      } else {
                        let cleaner:TalkData = getTalkDataByName('夸夸群-保洁阿串');
                        this.openTalkController(cleaner);
                      }
                      this.hasUpdateReception = false;
                    }
                  })
                Button('有害').width('25%').fontSize(this.isTablet?25:18).fontWeight(FontWeight.Bold)
                  .margin({ left: 10, right: 10 })
                  .onClick(()=>{
                    this.sendFlag = true;
                    this.waitFlag = true;
                    if (this.hasUpdateReception) {
                      if (WasteType.Harmful  === this.wasteReceive.type) {
                        this.profit+=10;
                        let cleaner:TalkData = getTalkDataByName('奖金-保洁阿串');
                        this.openTalkController(cleaner);
                      } else {
                        let cleaner:TalkData = getTalkDataByName('夸夸群-保洁阿串');
                        this.openTalkController(cleaner);
                      }
                      this.hasUpdateReception = false;
                    }
                  })
              }.width('100%')
              .justifyContent(FlexAlign.Center)
            }
          }.width('100%')
        }
      }.height('40%')
//      .backgroundColor(Color.Green)
      if (!this.isTablet) {
        Row() {
          Row({space: 20}){
            Text('第 ' + this.turnCount.toString() + '/' + totalCount.toString() + ' 轮')
              .fontSize(30).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
              .padding({left:10})
            Text(this.tip).fontSize(20).fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
            Text(this.wasteToSend.id.toString()).fontSize(20)
              .fontWeight(FontWeight.Bold).fontStyle(FontStyle.Italic)
          }.width('100%')
        }.height('10%').width('100%')
      }
      Row() {
        Row() {
          Text("垃圾列表")
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .width(30)
            .visibility(this.sendFlag?Visibility.Visible:Visibility.Hidden)
        }
        .width('10%').height('100%')
        .justifyContent(FlexAlign.Center)
        Grid() {
          ForEach(this.wasteList,(item:WasteData,index:number)=>{
            GridItem(){
              Stack() {
                Rect({ width: gridSize, height: gridSize })
                  .fill(Color.Pink).radius(10).opacity(0.6).offset({ x: 1, y: 0 })
                Image(item.imgURL).height(gridSize).width(gridSize)
                  .objectFit(ImageFit.Contain).height(gridSize).width(gridSize)
              }
            }.onClick(()=>{
              this.wasteToSend = item;
              this.waitFlag = false;
              this.getCurTip();
              console.info('[Leciron~~] 选择出题')
            })
          },(item:WasteData,index:number)=>index.toString())
        }.columnsTemplate(deviceInfo.deviceType==="tablet"?'1fr 1fr 1fr 1fr 1fr 1fr':'1fr 1fr 1fr')
        .rowsGap(20)
//        .backgroundColor(Color.Blue)
        .width('80%').height(this.isTablet?'70%':'80%')
        .visibility(this.sendFlag?Visibility.Visible:Visibility.Hidden)
      }
      .width('100%').height(this.isTablet?'60%':'50%')
//      .backgroundColor(Color.Orange)
    }
    .width('100%')
  }
}