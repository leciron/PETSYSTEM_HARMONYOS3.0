import CharacterData from '../../create/model/CharacterData';
import vibrator from '@ohos.vibrator'

@CustomDialog
export struct DeleteDialog {
  controller: CustomDialogController;
  private expiredDeal = null;
  private nonExpiredDeal = null;

  build() {
    Column() {
      Text($r('app.string.alarm'))
        .fontSize(25)
        .fontWeight(20)
        .margin(10)
        .fontColor('#1a1919')
        .textAlign(TextAlign.Center)
      Text('节约粮食，从我做起！')
        .fontSize(20)
        .fontStyle(FontStyle.Italic)
        .textAlign(TextAlign.Center)
      .width('100%')
      .height('50%')
      Row() {
        Row() {
          Text('狠心丢弃').fontSize(20)
            .onClick(()=>{
              this.nonExpiredDeal();
            })
        }

        Row({space: 5}) {
          Image($rawfile('icon_property_coin.png')).width(25).height(25)
            .objectFit(ImageFit.Contain).width(25).height(25)
          Text('+10 过期丢弃').fontSize(20)
        }
        .onClick(()=>{
          this.expiredDeal();
        })
      }
      .width(500)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: 30, right: 30})
    }
    .width('50%').height('30%')
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
    .padding(10)
  }
}