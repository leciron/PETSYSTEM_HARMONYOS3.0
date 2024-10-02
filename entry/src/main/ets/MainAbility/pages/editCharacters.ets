import prompt from '@ohos.prompt';
import { getAnimalImgById } from '../create/model/AnimalDataModel';
import { NullCharacterDialog } from '../create/component/NullCharacterDialog';
import LiteStoreConstants from '../constants/LiteStoreConstants';
import { LiteStore } from '../test_store/model/LiteStore';
import { ImageResource } from '../utils/ImageResource';
import CharacterData, { testCharacter , testCharacters}  from '../create/model/CharacterData';
import router from '@system.router';

// 此页面用于测试LiteStore的存储会否随着应用重新进入，而将数据重置
let character_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_KEY);
let characterList_LiteStore = new LiteStore(LiteStoreConstants.CHARACTER_LIST_KEY);

let imgSize = 200;

@Entry
@Component
struct EditCharacters {
  @State characters: Array<CharacterData> = [];
  @State nowCharacter:CharacterData = {characterName:'测试阿串',characterIndex:3  ,
    hunger: 100, health: 90, money: 60, favor: 100, experience: 100,isOnUse: 'true'};
  @State changeFlag:boolean = false;
  @State tip:string[] = ['你好，我是星球社区负责人——社区长阿串。请先点击左边按钮创建一个宠物角色吧！',
  '你好，我是星球社区负责人——社区长阿串，在左边选择你要陪伴的宠物角色吧！'];
  controller: CustomDialogController = new CustomDialogController({
    builder: NullCharacterDialog({
      text: '小宠物回自己的星球去啦！',
      cancel: this.cancelNullDialog()
    }),
    autoCancel:true
  })

  async aboutToAppear() {
    console.info('[aboutToAppear~~]')
    // 从数据库中读取当前角色列表
    let str = <string> await characterList_LiteStore.getValue();
    if (str!='') {
      this.characters = JSON.parse(str);
    }
    let str2 = <string> await character_LiteStore.getValue();
    if (str2!='') {
      this.nowCharacter = JSON.parse(str2);
    }

    this.sortCharactersIsOnUSE(this.characters.length-1);
    // 每个宠物有单独的名字，不能重复
  }

  onPageShow(){
    console.info('[OnPageShow~~] 打印当前角色列表');
    // 列表库里没有数据
    console.info(JSON.stringify(this.characters));
  }

  async writeInCharacterStore() {
    await character_LiteStore.setValue(JSON.stringify(this.nowCharacter));
    console.info('写入current角色-结束')
    console.info(JSON.stringify(this.nowCharacter))
  }

  async writeInCharacterListStore() {
    await characterList_LiteStore.setValue(JSON.stringify(this.characters));
    console.info('写入角色列表-结束')
    console.info(JSON.stringify(this.characters))
  }

  /**
   * 整理角色列表中的isOnUse属性
   * @param index
   */
  sortCharactersIsOnUSE(index:number) {
    if (index < 0) {
      return;
    }
    for (let i=0;i<this.characters.length;i++) {
      if (index != i) {
        this.characters[i].isOnUse = 'false';
      } else {
        this.characters[i].isOnUse = 'true';
      }
    }
  }

  /**
   * 删除宠物
   * @param index
   */
  deleteCharacterListItem(index:number):Array<CharacterData>{
    let list:Array<CharacterData>=[];
    for (let i=0;i<this.characters.length;i++) {
      if (index != i) {
        list.push(this.characters[i]);
      }
    }
    return list;
  }

  cancelNullDialog() {
    setTimeout(()=>{
      this.controller.close();
    },5000)
  }



  build() {
    Column() {
      // 标头：返回
      Row() {
        Text('编辑').fontSize(30).fontWeight(FontWeight.Bold)
      }.height('20%').width('100%').backgroundColor('#AEffff')
      .justifyContent(FlexAlign.SpaceBetween).padding({left:10, right:10})
      // 列表
      Row() {
        Column() {
          List() {
            ListItem() {
              Row() {
                Text('角色列表').fontSize(25)
                Button('返回创建页').height(60).onClick(() => {
                  router.push({
                    uri: 'pages/createCharacter'
                  })
                })
              }
              .width('100%').height(90)
              .backgroundColor(Color.Pink)
              .borderRadius(10)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({left:10, right:10})
            }
          }
          Column() {
            List() {
              ListItem() {
                Row({ space: 10 }) {
                  Row().width(50)
                  Row({ space: 80 }) {
                    Text('名字').fontSize(16)
                    Text('饥饿值').fontSize(16)
                    Text('健康值').fontSize(16)
                    Text('正在培养').fontSize(16)
                  }
                }
              }.padding({top:3})
              ForEach(this.characters, (item: CharacterData, index: number) => {
                ListItem() {
                  Column() {
                    Row({ space: 10 }) {
                      Row() {
                        Image(getAnimalImgById(item.characterIndex)).height(50)
                          .objectFit(ImageFit.Contain).width(50).height(50)
                      }.width(50)

                      Row({ space: 85 }) {
                        Text(item.characterName).fontSize(20)
                        Text(item.hunger.toString()).fontSize(20)
                        Text(item.health.toString()).fontSize(20)
                        Toggle({
                          type: ToggleType.Switch,
                          isOn: item.isOnUse === 'false' ? false : true
                        }).onChange((isOn: boolean) => {
                          if (isOn) { // 用户滑动switch，打开当前角色状态
                            this.changeFlag = false;
                            this.sortCharactersIsOnUSE(index);
                            this.nowCharacter = item;
                          } else {
                            item.isOnUse = 'false';
                            this.changeFlag = true;
                          }
                        })
                      }
                    }.width('100%')
                    Divider().width('100%').borderColor(Color.Gray)
                  }
                }.onClick(()=>{
                  // 点击确认是否删除角色
                  AlertDialog.show(
                    {
                      title: '角色操作',
                      message: '是否删除当前角色：'+item.characterName+' ?',
                      primaryButton: {
                        value: '不了',
                        action: () => {
                          console.info('Callback when the first button is clicked')
                        }
                      },
                      secondaryButton: {
                        value: '是的',
                        action: () => {
                          console.info('Callback when the second button is clicked')
                          if (this.characters.length <= 1) {
                            this.characters = [];
                            this.writeInCharacterListStore();
                          } else {
                            // 删除后，默认当前角色为列表中第一项
                            if (this.characters.indexOf(this.nowCharacter)==index) {
                              this.changeFlag = true;
                            }
                            this.characters = this.deleteCharacterListItem(index);
                            this.writeInCharacterListStore();
                          }
                        }
                      },
                      cancel: () => {
                        console.info('Closed callbacks')
                      }
                    })
                })
              }, (item: CharacterData, index: number) => index.toString())
            }
          }
        }.margin({ top: 20 }).padding({ left: 10 }).width('50%').height('50%')

        Column({space: 10}){
          if (this.characters.length === 0 || this.changeFlag) {
            Image($rawfile('store_avatar_red.png')).width(imgSize).height(imgSize)
              .objectFit(ImageFit.Contain).width(imgSize).height(imgSize)
            Stack() {
              Rect({ width: 300, height: 120 })
                .fill(0xFAEEE0).radius(10)
                .opacity(0.8)
              Text(this.characters.length === 0?this.tip[0]:this.tip[1]).fontSize(25).width(280).height(120)
                .borderRadius(15)
                .padding({left:20})
            }.alignContent(Alignment.Start)
          } else {
            Image(getAnimalImgById(this.nowCharacter.characterIndex)).width(imgSize).height(imgSize)
              .objectFit(ImageFit.Contain).width(imgSize).height(imgSize)
            Text("当前宠物："+this.nowCharacter.characterName).fontSize(20)
            Button('一起回家').width(200).height(100).fontSize(30).fontWeight(FontWeight.Bold)
              .onClick(()=>{
                this.writeInCharacterStore();
                router.push({
                  uri:'pages/index'
                })
              })
          }
        }.width('50%')
      }
    }.width('100%')
  }
}