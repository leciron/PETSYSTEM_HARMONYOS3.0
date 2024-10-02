import { TalkData } from '../feed/model/TalkData';
import { PhoneTalkDialog } from '../feed/component/PhoneTalkDialog';
import router from '@system.router';

let testTalk:TalkData = {
  avatar:$rawfile('avatar_manager_pink.png'),
  name:'狂野学生阿串' ,
  message:'你好你好！'
}

/**
 * 手机的index，主要是控制物品显示
 */
@Entry
@Component
struct PhoneIndex {
  @State message: string = '请选择希望显示的物品吧！'
  controller:CustomDialogController = new CustomDialogController({
    builder:PhoneTalkDialog({
      avatar:testTalk.avatar,
      name:testTalk.name,
      message:testTalk.message
    }),
    autoCancel:true,
    customStyle:true
  });

  build() {
    Column() {
      Column() {
        Image($rawfile('store_avatar_red.png')).width(100).height(100)
          .objectFit(ImageFit.Contain).width(100).height(100)
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Button('选择商店物品').fontSize(20)
          .onClick(()=>{
            router.push({
              uri:'pages/phoneFood'
            })
          }).margin(20)
        Button('垃圾分类大比拼').fontSize(20).margin(20)
          .onClick(()=>{
            router.push({
              uri:'pages/competiton'
            })
          })
        Button('对话框测试').fontSize(20).margin(20)
          .onClick(()=>{
            this.controller.open();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}