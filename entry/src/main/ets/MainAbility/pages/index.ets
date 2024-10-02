import featureAbility from '@ohos.ability.featureAbility';
import wantConstant from '@ohos.ability.wantConstant';
import { getRandomNum } from '../utils/DateUtil';
import matrix4 from '@ohos.matrix4';
import { NullCharacterDialog } from '../create/component/NullCharacterDialog';
import { getAnimalById } from '../create/model/AnimalDataModel';
import { AnimalData } from '../create/model/AnimalData';
import CharacterData, { testCharacter }  from '../create/model/CharacterData';
import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import router from '@system.router';

let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);
let ANI_TIME_ID;

@Entry
@Component
struct Index {
  @State character: CharacterData = {characterName:'测试阿串',characterIndex:3,
    hunger: 100, health: 90, money: 60, favor: 100, experience: 100,isOnUse: 'true'};
  @State animalInfo: AnimalData = getAnimalById(this.character.characterIndex);
//  @State character:CharacterData = testCharacter;
  nullCharacterController: CustomDialogController = new CustomDialogController({
    builder: NullCharacterDialog({
      text:'宇宙重连中ing...',
      cancel: this.cancelNullDialog()
    }),
    autoCancel:false
  })
  // 动画 - 宠物动作
  @State angle:number = 10;
  @State matrix1:any = '';
  @State setWasteUI:boolean = false;

  async aboutToAppear(){
    // 渲染垃圾画面 - 50%概率
    let randomIndex = getRandomNum(0,3);
    if (randomIndex >1) {
      this.setWasteUI = true;
    }
    console.info('打印垃圾桶UI- '+this.setWasteUI)

    /* 宠物数据获取 */
    // 从数据库获取
    let str = <string> await character_LiteStore.getValue();
    // 没有数据，跳转回创建页面
    if (str === '') {
      this.nullCharacterController.open();
    }
//    this.nullCharacterController.open(); // 测试
    this.character = JSON.parse(str);
    console.info('[测试结果]' + JSON.stringify(this.character))
    this.animalInfo = getAnimalById(this.character.characterIndex)
    /*  */
    /*  宠物动画  */
    // 初始化matrix1
    this.matrix1 = matrix4.identity().rotate({x:1, y:1, z:2, angle:this.angle})
    // 每900毫秒（1s）对图片执行一次旋转
    ANI_TIME_ID = setInterval(()=>{
      this.angle = -this.angle;
      this.matrix1 = matrix4.identity().rotate({x:1, y:1, z:2, angle:this.angle})
      console.info('我又变了hhh ' + this.angle.toString())
    },1000)
    /*    */
  }

  onPageHide(){
    clearInterval(ANI_TIME_ID);
    console.info('离开【家庭页面】');
  }

  /**
   * 5秒后自动跳转到createCharacter页面
   */
  cancelNullDialog() {
    setTimeout(()=>{
      router.push({
        uri:'pages/createCharacter'
      });
      this.nullCharacterController.close();
    },5000)
  }

  build() {
    Row() {
      Column({space: 20}) {
        // 角色名字
        Text(this.character.characterName)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button("去创建宠物！").width(200)
          .onClick(() => {
            router.push({
              uri: 'pages/createCharacter'
            });
          })
        Button("我的角色列表").width(200)
          .onClick(() => {
            router.push({
              uri: 'pages/editCharacters'
            });
          })
        Button("去商店").width(200)
          .onClick(() => {
            let prob = getRandomNum(0,2);
            if (prob >0) {
              router.push({
                uri: 'pages/traffic',
                params: {
                  img:this.animalInfo.imgURL
                }
              });
            } else {
              router.push({
                uri: 'pages/store'
              });
            }
          })
        Button("测试道路出行场景").width(200)
          .onClick(() => {
            router.push({
              uri: 'pages/traffic'
            });
          })
        Stack({alignContent: Alignment.Bottom}){
          if (this.setWasteUI) {
            Image($rawfile('waste_item_plasticBottle.png')).width(100).height(100)
              .objectFit(ImageFit.Contain).width(100).height(100)
            Image($rawfile('waste_item_orangePeel.png')).width(50).height(50)
              .objectFit(ImageFit.Contain).width(50).height(50)
          }
          Image($rawfile('waste_bin_home.png')).width(150).height(120)
            .objectFit(ImageFit.Contain).width(150).height(120)
        }.onClick(()=>{
          router.push({
            uri:'pages/garbageClassification'
          })
        })
      }
      .width('50%')
      .backgroundImage($rawfile('bg_furniture_index.png'))
      .backgroundImageSize({width:'100%',height:'100%'})
      Column() {
        Image(this.animalInfo.imgURL).transform(this.matrix1)
          .objectFit(ImageFit.Contain).width(200).height(300)
          .onClick(() => {
            router.push({
              uri: 'pages/food'
            })
          })
        Row() {
          Stack(){
            Image($rawfile('module_game.png')).width(150).height(150)
              .objectFit(ImageFit.Contain).width(150).height(150)
            Text('我的游戏').fontSize(20)
          }.alignContent(Alignment.Bottom)
          .onClick(()=>{
//            featureAbility.startAbility({
//              "want": { // 去游戏首页
//                "bundleName": "com.example.distributemotiongame1",
//                "abilityName": "com.example.distributemotiongame1.MainAbility",
//                "flags": wantConstant.Flags.FLAG_ABILITY_FORM_ENABLED,
//                "parameters": {
//                  "url": 'pages/index',
//                },
//              }
//            }, (err, data) => {
//            });
          })

          Stack() {
            Image($rawfile('module_notebook.png')).width(150).height(150)
              .objectFit(ImageFit.Contain).width(150).height(150)
            Text('我的手账').fontSize(20)
          }.alignContent(Alignment.Bottom)
          .onClick(()=>{
//            featureAbility.startAbility({
//              "want": { // 去手账首页
//                "bundleName": "com.ccc.handaccount",
//                "abilityName": "com.ccc.handaccount.MainAbility",
//                "flags": wantConstant.Flags.FLAG_ABILITY_FORM_ENABLED,
//                "parameters": {
//                  "url": 'pages/index',
//                },
//              }
//            }, (err, data) => {
//            });
          })
        }.width('90%')
        .justifyContent(FlexAlign.Center)
      }
      .width('50%')
      .height('100%')
      .backgroundColor('#fff5ec')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
  }
}

