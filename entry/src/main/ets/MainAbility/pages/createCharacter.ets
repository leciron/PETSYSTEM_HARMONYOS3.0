import prompt from '@ohos.prompt';
import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import { MyDataSource } from '../constants/MyDataSource';
import CharacterData, { testCharacters }  from '../create/model/CharacterData';
import router from '@system.router';
import { getAnimalDatas } from '../create/model/AnimalDataModel';
import { AnimalData } from '../create/model/AnimalData';

import deviceInfo from '@ohos.deviceInfo'

let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);
let characterList_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_LIST_KEY);

// 角色数限制
const CHARACTER_LIMIT:number = 3;

@Entry
@Component
struct CreateCharacter {
  // UI-所有可选动物
  private swiperController: SwiperController = new SwiperController()
  private data: MyDataSource = new MyDataSource([])
  @State characters:Array<CharacterData> = [];
  @State deviceName: string = '同步失败！'

  @State currentAnimal: AnimalData = {"animalId":0, "animalName":"初始化", "animalType": "default",
    "imgURL":$rawfile('animal_bear.png'),"content":"this is just a test.", "isVisible":true};
  @State currentIndex: number = 0;
  // 已创建角色弹窗-列表
  @State isShow:boolean = false;

  private controller: TextInputController = new TextInputController();
  @State popupController:boolean = false;
  @State name:string = "";

  async aboutToAppear(){
    console.info('[aboutToAppear]')
    let str = <string> await characterList_LiteStore.getValue();
    if (str != '') {
      this.characters = JSON.parse(str);
    }
  }

  onPageShow(){
    // 初始化动物列表
    let list = getAnimalDatas();
    this.data = new MyDataSource(list);
    this.currentAnimal = this.data.getData(0)
    this.currentIndex = 0;
    // 判断跳转
    if (this.characters.length >= 3){
      router.push({
        uri:'pages/editCharacters'
      })
    }
    // 手机端直接进入选择物品页面
    if (deviceInfo.deviceType != "tablet") {
      router.push({
        uri: 'pages/phoneIndex'
      })
    }
  }

  /**
   * 将角色写入当前角色数据库
   */
  async createNewCharacter(newCharacter: CharacterData) {
    let str = JSON.stringify(newCharacter);
    await character_LiteStore.setValue(str);
    console.info('创建宠物成功！'+ str);
  }

  async addCharacterList() {
    await characterList_LiteStore.setValue(JSON.stringify(this.characters));
  }

  /**
   * 每个宠物只能有一个名字
   * @param str
   */
  nameHasExisted(str:string):boolean{
    for (let i=0;i<this.characters.length;i++) {
      if (this.characters[i].characterName === str) {
        return true;
      }
    }
    return false;
  }

  build() {
      Column() {
        Column() {
          Row({space: 10}) {
            Button('我的角色列表').margin({left:10})
              .onClick(()=>{
                router.push({
                  uri: 'pages/editCharacters',
                })
              })
            Text(this.currentAnimal.animalName).fontSize(30).fontWeight(FontWeight.Bold)
          }.width('100%').height('15%').backgroundColor('#AEffff')
          .alignItems(VerticalAlign.Center)
          Row() {
            Image($rawfile('icon_l_arrow.png')).width(50).height(50)
              .visibility(this.currentIndex == 0?Visibility.Hidden:Visibility.Visible)
              .onClick(()=>{
                this.swiperController.showPrevious();
              })
            Swiper(this.swiperController) {
              LazyForEach(this.data, (item:any)=>{
                Image(this.currentAnimal.imgURL).width('50%').height(300)
                  .objectFit(ImageFit.Contain).width(200).height(300)
                  .onClick(()=>{
                    this.popupController = true;
                  })
                Text(item).width('50%').height(300).backgroundColor(0xAFEEEE).textAlign(TextAlign.Center).fontSize(30)
              },item => item)
            }
            .cachedCount(0)
            .index(0)
            .autoPlay(false)
            .indicator(false)
            .loop(false)
            .itemSpace(0)
            .curve(Curve.Linear)
            .onChange((index: number)=>{
              this.currentIndex = index;
              this.currentAnimal = this.data.getData(index)
            })
            .bindPopup(this.popupController,{
              message:this.currentAnimal.content,
              placementOnTop:true,
              primaryButton: {
                value: 'Hi~你好呀！',
                action: () => {
                  this.popupController = !this.popupController;
                  console.info('confirm Button click : '+this.popupController.toString())
                }
              },
              onStateChange: (e) => {
                console.info(e.isVisible.toString())
                if (!e.isVisible) {
                  this.popupController = false;
                }
              }
            })
            Image($rawfile('icon_r_arrow.png')).width(50).height(50)
              .visibility((this.currentIndex == this.data.totalCount()-1)?Visibility.Hidden:Visibility.Visible)
              .onClick(()=>{
                this.swiperController.showNext()
              })
          }.justifyContent(FlexAlign.Center).width('50%')
          Text('在下方输入小宠物的名字吧！').fontSize(20).padding({top: 10}).fontColor('#d2691e')
          Divider().padding({top:10, bottom: 10})

          // 用户自定义 - 选择
          Row({space: 10}) {
            TextInput({ placeholder: '你可以给我取个名字~', controller:this.controller})
              .onChange((value:string)=>{
                this.name = value;
              })
              .width('20%').height(70)
            Button('选择我！')
              .height(60).fontSize(20)
              .onClick(()=>{
                if (this.nameHasExisted(this.name)||(this.name===''&&this.nameHasExisted(this.currentAnimal.animalName))) {
                  prompt.showToast({
                    message: '每个小宠物都应该有自己的名字，不容易混淆！',
                    duration: 3000
                  })
                } else if (this.characters.length>=CHARACTER_LIMIT) {
                  prompt.showToast({
                    message: '目前最多可以邀请'+CHARACTER_LIMIT.toString()+'位小宠物哦！',
                    duration: 3000
                  })
                } else {
                  AlertDialog.show(
                    {
                      title: '确定信',
                      message: '谢谢你，让我们一起开始新的旅程吧！',
                      primaryButton: {
                        value: '再等等',
                        action: () => {
                          console.info('Callback when the first button is clicked')
                        }
                      },
                      secondaryButton: {
                        value: '好的 ',
                        action: () => {
                          // 初始化
                          let newCharacter: CharacterData = {
                            "characterName": "",
                            "characterIndex": 0,
                            "hunger": 20,
                            "health": 5,
                            "money": 30,
                            "favor": 100,
                            "experience": 0,
                            "isOnUse": "false"
                          };
                          // 名字可以自定义
                          if (this.name === "") {
                            newCharacter.characterName = this.currentAnimal.animalName;
                          } else {
                            newCharacter.characterName = this.name;
                          }
                          newCharacter.characterIndex = this.currentIndex;
                          newCharacter.isOnUse = 'true';
                          // 写入LiteStore数据库
                          this.createNewCharacter(newCharacter);
                          this.characters.push(newCharacter);
                          this.addCharacterList();
                          router.push({
                            uri: 'pages/index',
                          })
                        }
                      },
                      cancel: () => {
                        console.info('Closed callbacks')
                      }
                    }
                  )
                }
              }).backgroundColor(0x317aff)
          }
        }.alignItems(HorizontalAlign.Center)
      }
  }
}