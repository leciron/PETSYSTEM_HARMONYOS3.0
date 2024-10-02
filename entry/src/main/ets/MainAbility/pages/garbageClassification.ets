import { getBinIntroById , BinIntroduceData} from '../feed/model/BinIntroduceData';
import { BinIntroduceDialog } from '../feed/component/BinIntroduceDialog';
import router from '@system.router';
import CharacterData from '../create/model/CharacterData';
import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import { getRandomNum } from '../utils/DateUtil';
import { TalkDialog } from '../feed/component/TalkDialog';
import { TalkData , getTalkDataByName} from '../feed/model/TalkData';
import { WasteData , testWasteData, WasteType, WasteCompositionCount, getWasteById, getRandomWastes} from '../feed/model/WasteData';

const blackAnimation1 = [$rawfile('cat_Black_4.png'), $rawfile('cat_Black_1.png'),$rawfile('cat_Black_2.png'),
$rawfile('cat_Black_3.png')];

const pixel = 1;
const frameSize = 120;
const bagSize = 230;
const tip = '共同建设清洁社区'
const profit = 5;

// 数据库 - 读取经验值和金币值
let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);

@Entry
@Component
struct GarbageClassification {
  @State message: string = tip;
  @State character:CharacterData = {characterName:'测试阿串',characterIndex:3,
    hunger: 100, health: 5, money: 60, favor: 100, experience: 100,isOnUse: 'true'};
  //  @Link wasteList:Array<WasteData>;
  @State wastes:Array<WasteData>=testWasteData;
  @State selectedIndex:number = 0;
  @State selectedWaste:WasteData = testWasteData[this.selectedIndex];
  @State isCanceled:boolean = true; // true取消拖拽，在列表中显示
  @State isInBinArea:boolean = false; // 是否在垃圾箱的范围内
  //  @State isNext:boolean = false; // 是否为下一个
  @State binName:WasteType = WasteType.Recycable;
  @State bagIsOpen:boolean = false; // 是否打开垃圾袋
  // 对话
  @State cleaner:TalkData = getTalkDataByName('开心的保洁阿串')
  talkController:CustomDialogController;
  @State animateIndex:number = 0;
  @State playChecked:boolean = false;
  // 垃圾分类介绍
  binIntroduceController:CustomDialogController;

  @Builder testPixelMap(){
    Column(){
      Image(this.selectedWaste.imgURL)
        .width(this.selectedWaste.imgSize*pixel).height(this.selectedWaste.imgSize*pixel)
        .objectFit(ImageFit.Contain).width(this.selectedWaste.imgSize*pixel).height(this.selectedWaste.imgSize*pixel)
    }
    .onDrop(()=>{
      this.message = tip;
      // 不在垃圾箱范围内，手误操作
      if (!this.isInBinArea){
        this.isCanceled = true;
      } else { // 在垃圾箱范围内，丢垃圾
        this.wastes = this.deleteWastesItem(this.selectedIndex);
        this.isCanceled = true;
        this.isInBinArea = false;
        //        this.isNext = true;
        console.info('目前垃圾序列'+JSON.stringify(this.wastes));
        if (this.selectedWaste.type == this.binName) {
          console.info('垃圾分类成功');
          this.cleaner = getTalkDataByName('开心的保洁阿串')
          this.createTalkDialog();
          this.character.money = this.character.money + profit;
          this.writeInStore();
        } else {
          console.info('草率了');
          this.cleaner = getTalkDataByName('难过的保洁阿串')
          this.createTalkDialog();
        }
      }
      /*    测试    */
      // 已进入垃圾箱范围：isCanceled = false, isInBinArea = true
      // 未进入垃圾箱范围：isCanceled = false, isInBinArea = false
      // 进入垃圾箱范围，完成丢垃圾后：isCanceled = true, isInBinArea = false;
      var cancel;
      var binArea;
      if (this.isCanceled) {
        cancel = 'isCanceled = true 取消拖拽，在列表中显示';
      } else {
        cancel = 'isCanceled = false 拖拽，列表中不显示 isCanceled = false';
      }
      if (this.isInBinArea) {
        binArea = 'isInBinArea = true 进入垃圾桶';
      } else {
        binArea = 'isInBinArea = false 垃圾桶外';
      }
      console.info('用户已放手！');
      console.info(cancel);
      console.info(binArea);
      /*    结束    */
    })
  }

  /**
   * 打开聊天框
   */
  createTalkDialog(){
    this.talkController = new CustomDialogController({
      builder:TalkDialog({
        name:this.cleaner.name,
        avatar:this.cleaner.avatar,
        message:this.cleaner.message
      }),
      autoCancel:true,
      offset:{dx:0, dy:-30},
      alignment: DialogAlignment.Bottom,
      customStyle:true
    })
    this.talkController.open();
  }
  /**
   * 打开介绍窗口
   * @param index
   */
  openBinIntroduceDialog(index:number) {
    let binIntro:BinIntroduceData = getBinIntroById(index);
    this.binIntroduceController = new CustomDialogController({
      builder:BinIntroduceDialog({
        bin:binIntro
      }),
      customStyle:true,
      autoCancel:true
    })
    this.binIntroduceController.open();
  }

  /**
   * UI删除当前垃圾列表中的项
   * @param index
   */
  deleteWastesItem(index:number):Array<WasteData>{
    let list:Array<WasteData> = [];
    for (let i=0;i<this.wastes.length;i++) {
      if (i!=index){
        list.push(this.wastes[i]);
      }
    }
    return list;
  }

  getWasteItemVisibility(index:number){
    let visible:Visibility = Visibility.Visible;
    // 选中物品 未取消 未进入下一个
    if (index == this.selectedIndex && !this.isCanceled){
      visible = Visibility.Hidden;
    }
    return visible;
  }

  async writeInStore() {
    await character_LiteStore.setValue(JSON.stringify(this.character));
  }

  async aboutToAppear() {
    /*       随机生成垃圾序列       */
    this.wastes = getRandomWastes(5,'random');
    /*       读取用户数据       */
    let str = <string> await character_LiteStore.getValue();
    console.info('获取数据' + str);
    this.character = JSON.parse(str);
  }

  build() {
    Row() {
      Column() {
        Stack() {
          Row() {
            Button('回家')
              .onClick(() => {
                // 路由跳转
                router.push({
                  uri: 'pages/index'
                })
              }).width(100).fontSize(18)
            Row({ space: 5 }) {
              Image($rawfile('icon_property_coin.png')).width(50).height(50)
                .objectFit(ImageFit.Contain).width(50).height(50)
              Text(this.character.money.toString()).fontSize(20).fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
            }
          }
          .offset({x:0,y:-20})
          .width('100%')
          .padding({ right: 30, left: 30 })
          .justifyContent(FlexAlign.SpaceBetween)
          Row({ space: 10 }) {
            Text(this.message)
              .fontSize(50)
              .fontWeight(FontWeight.Bold)
            Button('喵~~~').onClick(() => {
              this.animateIndex = 0;
              this.playChecked = true;
              let timeId = setInterval(() => {
                let curIndex = this.animateIndex + 1;
                if (curIndex >= blackAnimation1.length) {
                  curIndex = 3;
                }
                this.animateIndex = curIndex;
                console.info('动画帧 ' + this.animateIndex.toString())
              }, 300)
              setTimeout(() => {
                clearInterval(timeId);
                console.info('时间已清理！')
                this.playChecked = false;
              }, 3000)
            })
          }
        }
        .width('100%')
        .height('15%')
        Row({space: 5}) {
          Stack(){
            Image($rawfile('waste_bin_recyclable.png')).width(300).height(300)
              .objectFit(ImageFit.Contain).width(300).height(300)
              .onClick(()=>{
                // 打开介绍
                this.openBinIntroduceDialog(0);
              })
              .onDragEnter((event: DragEvent, extraParams: string)=>{
                this.isInBinArea = true;
                this.binName = WasteType.Recycable;
                this.message = '可回收物';
                console.info('目标进入 '+this.binName+' x:'+ event.getX().toString()+' y:'+event.getY().toString());
              })
              .onDrop((event: DragEvent, extraParams: string) => {
                this.wastes = this.deleteWastesItem(this.selectedIndex);
                this.isCanceled = true;
                this.isInBinArea = false;
                console.info('目前垃圾序列'+JSON.stringify(this.wastes));
                if (this.selectedWaste.type == this.binName) {
                  console.info('垃圾分类成功');
                  this.cleaner = getTalkDataByName('开心的保洁阿串')
                  this.createTalkDialog();
                  this.character.money = this.character.money + profit;
                  // 写入数据库
                  this.writeInStore();
                } else {
                  console.info('草率了');
                  this.cleaner = getTalkDataByName('难过的保洁阿串')
                  this.createTalkDialog();
                }
                this.message = tip;
                console.info('目标放下 '+this.binName+' x:'+ event.getX().toString()+' y:'+event.getY().toString());
              })
            if (this.playChecked) {
              Image(blackAnimation1[this.animateIndex]).width(120).height(120)
                .objectFit(ImageFit.Contain).width(120).height(120)
                .offset({ x: '35%', y: '40%' })
            }
          }
          Stack() {
            Image($rawfile('waste_bin_household_food.png')).width(300).height(300)
              .objectFit(ImageFit.Contain).width(300).height(300)
              .onClick(() => {
                // 打开介绍
                this.openBinIntroduceDialog(1);
              })
              .onDragEnter((event: DragEvent, extraParams: string) => {
                this.isInBinArea = true;
                this.binName = WasteType.Household;
                this.message = '厨余垃圾';
                console.info('目标进入 ' + this.binName + ' x:' + event.getX().toString() + ' y:' + event.getY().toString());
              })
              .onDrop((event: DragEvent, extraParams: string) => {
                this.wastes = this.deleteWastesItem(this.selectedIndex);
                this.isCanceled = true;
                this.isInBinArea = false;
                console.info('目前垃圾序列'+JSON.stringify(this.wastes));
                if (this.selectedWaste.type == this.binName) {
                  console.info('垃圾分类成功');
                  this.cleaner = getTalkDataByName('开心的保洁阿串')
                  this.createTalkDialog();
                  this.character.money = this.character.money + profit;
                  this.writeInStore();
                } else {
                  console.info('草率了');
                  this.cleaner = getTalkDataByName('难过的保洁阿串')
                  this.createTalkDialog();
                }
                this.message = tip;
                console.info('目标放下 ' + this.binName + ' x:' + event.getX().toString() + ' y:' + event.getY().toString());
              })
            Image($rawfile('icon_ad.png')).width(100).height(100)
              .offset({x:'30%',y:'-50%'})
              .onClick(()=>{
                router.push({
                  uri: 'pages/competiton'
                })
              })
          }
          Stack() {
            Image($rawfile('waste_bin_harmful.png')).width(300).height(300)
              .objectFit(ImageFit.Contain).width(300).height(300)
              .onClick(()=>{
                // 打开介绍
                this.openBinIntroduceDialog(2);
              })
              .onDragEnter((event: DragEvent, extraParams: string) => {
                this.isInBinArea = true;
                this.binName = WasteType.Harmful;
                this.message = '有害垃圾';
                console.info('目标进入 ' + this.binName + ' x:' + event.getX().toString() + ' y:' + event.getY().toString());
              })
              .onDrop((event: DragEvent, extraParams: string) => {
                this.wastes = this.deleteWastesItem(this.selectedIndex);
                this.isCanceled = true;
                this.isInBinArea = false;
                console.info('目前垃圾序列'+JSON.stringify(this.wastes));
                if (this.selectedWaste.type == this.binName) {
                  console.info('垃圾分类成功');
                  this.cleaner = getTalkDataByName('开心的保洁阿串')
                  this.createTalkDialog();
                  this.character.money = this.character.money + profit;
                  this.writeInStore();
                } else {
                  console.info('草率了');
                  this.cleaner = getTalkDataByName('难过的保洁阿串')
                  this.createTalkDialog();
                }
                this.message = tip;
                console.info('目标放下 ' + this.binName + ' x:' + event.getX().toString() + ' y:' + event.getY().toString());
              })
          }
        }
        .offset({x: 0, y:'15%'})

        Row() {
          Stack() {
            Image(!this.bagIsOpen ? $rawfile('waste_bag_close.png') : $rawfile('waste_bag_open.png'))
              .width(bagSize).height(bagSize)
              .objectFit(ImageFit.Contain).width(bagSize).height(bagSize)
              .offset({ x: '-10%', y: '-10%' })
            Text(!this.bagIsOpen ? '打开':'关上').fontSize(30).fontColor(Color.White).fontWeight(FontWeight.Bold)
              .offset({x: -20, y:0})
              .onClick(() => {
                this.bagIsOpen = !this.bagIsOpen;
              })
          }

          // 垃圾列表
          Row() {
            Stack() {
              Grid() {
                ForEach(this.wastes, (item: WasteData, index: number) => {
                  GridItem() {
                    Column() {
                      Stack() {
                        Image($rawfile('bg_wooden_frame.png')).width(frameSize).height(frameSize)
                          .objectFit(ImageFit.Contain).width(frameSize).height(frameSize)
                        Image(item.imgURL).width(item.imgSize).height(item.imgSize)
                          .objectFit(ImageFit.Contain).width(item.imgSize).height(item.imgSize)
                      }
                      Text(item.title).fontSize(20).fontColor(Color.White)
                        .onDragStart(() => {
                          /*    测试    */
                          var cancel;
                          var binArea;
                          if (this.isCanceled) {
                            cancel = 'isCanceled = true 取消拖拽，在列表中显示';
                          } else {
                            cancel = 'isCanceled = false 拖拽，列表中不显示 isCanceled = false';
                          }
                          if (this.isInBinArea) {
                            binArea = 'isInBinArea = true 进入垃圾桶';
                          } else {
                            binArea = 'isInBinArea = false 垃圾桶外';
                          }
                          console.info('开始拖拽！');
                          console.info(cancel);
                          console.info(binArea);
                          /*    结束    */
                          this.selectedIndex = index;
                          this.selectedWaste = this.wastes[index];
                          this.isCanceled = false;
                          return this.testPixelMap;
                        })
                    }.width(125).height(125)
                  }
                  .visibility(this.getWasteItemVisibility(index))
                }, (index: number) => index.toString())
              }
              .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
              .rowsGap(15)
              .borderRadius(16)
              .visibility(this.bagIsOpen&&this.wastes.length!=0?Visibility.Visible:Visibility.Hidden)
              .backgroundColor(Color.Black)
            }
          }.width('60%').height('30%')
        }
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($rawfile('bg_garbageClsfi_1.jpg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}