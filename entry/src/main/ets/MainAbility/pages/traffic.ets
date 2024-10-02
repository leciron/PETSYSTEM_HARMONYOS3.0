import router from '@system.router';
import { TalkDialog } from '../feed/component/TalkDialog';
import { TalkData } from '../feed/model/TalkData';
import { getRandomLeft , Pedestrian, getRandomRight, getRandomRightPedestrian} from '../feed/model/Pedestrian';
import prompt from '@ohos.prompt';
import { getRandomNum } from '../utils/DateUtil';

let count=0;
const talks:string[] = [
  '规则帮助我们更安心地生活。\n遵守道路交通规则，是我们尊重自己、尊重他人生命安全的方式。小朋友们可要记在心里呀。',
  '生活里，有时候是别人不遵守规则。\n比如逆行、闯红灯、饮酒驾驶等等，这些行为很容易造成交通隐患，给自己和他人带来不可挽回的伤害。',
  '我们更愿意成为对自己行为负责任的人。\n相信遵守交通规则的公民会越来越多的，安全生活需要我们所有人共同维护。',
  '当我们在路上行走时，最好不要打闹。\n因为道路宽度有限，谁也不知道突如其来的推挤、滑倒、踩踏会带来多严重的后果。',
  '感谢你认真阅读这些规则，并且认真履行。\n我是安心小姐，让我们一起帮助小宠物在这个星球安全出行吧！欢迎你来和我探讨~'
];

// 斑马线：{x:-350-i,y:-20+i*10}————xPosition:-350,yPosition:20
// 斑马线外：{x:100,y:-20+i*10}————xPosition:100,yPosition:20
function getPath(xPosiiton:number,yPosition:number):Array<Position>{
  let list:Array<Position>=[];
  for (let i=0;i<15;i++){
    let position:Position = {x:xPosiiton-i,y:yPosition+i*10};
    list.push(position);
    console.info(JSON.stringify(position));
  }
  console.info(JSON.stringify(list));
  return list;
}

@Entry
@Component
struct Traffic {
  // 随机威胁
  private leftHazard:Pedestrian;
  private rightHazard_1:Pedestrian;
  private rightHazard_2:Pedestrian;
  private rightPedestrian_1:Pedestrian;
  private rightPedestrian_2:Pedestrian;
  // 位置
  @State img:any = router.getParams().img;
  @State message: string = '过街准则：\n一、步行走在人行道，过街要走斑马线\n二、红灯停，绿灯行\n三、左右看，心谨慎\n四、不逗留、不玩耍，及时通行'
  @State position:Position = {x:100,y:-20};
  // 交互动作
  @State isGreenLight:boolean = true;
  @State isRightPlace:boolean = true;
  @State isNoLeftHazard:boolean = true; // 道路左侧潜在威胁
  @State rightHazardNum:number = 3; // 道路右侧潜在威胁; 0无，1单车，2车辆，3单车+车辆
  @State rightPedestrian:number = 3; // 道路右侧的行人；0无，1号位，2号位，3两个位置都有人
  @State arr:Array<Position> = getPath(100,-20);
  // 气泡效果
  @State handlePopup_1: boolean = false;
  @State handlePopup_2: boolean = false;
  talkDialogController:CustomDialogController;

  aboutToAppear(){
    /*          随机素材            */
    this.rightHazard_1 = getRandomRight();
    this.rightHazard_2 = getRandomRight();
    this.rightPedestrian_1 = getRandomRightPedestrian();
    this.rightPedestrian_2 = getRandomRightPedestrian();
    this.leftHazard = getRandomLeft();
  }

  onPageShow(){
    // 设置红绿灯
    let greenPossibility = getRandomNum(1,10);
    if (greenPossibility>3){
      this.isGreenLight = false;
    } else {
      this.isGreenLight = true;
    }
    // 设置站位
    let placePossibility = getRandomNum(1,10);
    if (placePossibility>3){
      this.isRightPlace = false;
      this.position = {x:100,y:-20};
    } else {
      this.isRightPlace = true;
      this.position = {x:-350,y:-20};
    }
    // 设置右侧路上潜在威胁
    this.rightHazardNum = getRandomNum(0,3);
    // 设置右侧路上行人数量
    this.rightPedestrian = getRandomNum(0,3);
    // 设置左侧路上潜在威胁
    let leftPossibility = getRandomNum(1,10);
    console.info('[onPageShow]输出左侧出现概率：'+leftPossibility.toString());
    console.info('[onPageShow]输出isNoLeftHazard：'+this.isNoLeftHazard);
    if (leftPossibility>4){
      this.isNoLeftHazard = false;
    } else {
      this.isNoLeftHazard = true;
    }

    // 测试  -  在定义处修改即可

    // 打印
    console.info('[onPageShow]打印 isGreenLight ：'+this.isGreenLight);
    console.info('[onPageShow]打印 isRightPlace ：'+this.isRightPlace);
    console.info('[onPageShow]打印 isNoLeftHazard ：'+this.isNoLeftHazard);
    console.info('[onPageShow]打印 rightHazardNum(0,1,2,3) ：'+this.rightHazardNum.toString());
    console.info('[onPageShow]打印 isGreenLight(0,1,2,3) ：'+this.rightPedestrian.toString());
  }

  openTalkDialog(item:TalkData){
    this.talkDialogController = new CustomDialogController({
      builder:TalkDialog({
        avatar:item.avatar,
        name:item.name,
        message:item.message
      }),
      autoCancel:true,
      customStyle:true,
      alignment:DialogAlignment.Bottom,
      offset:{dx:0, dy:-30},
    })
    this.talkDialogController.open();
  }

  build() {
    Row() {
      Column() {
        Row(){
          Image(this.isGreenLight?$rawfile('traffic_go_greenLight.png'):$rawfile('traffic_stop_redLight.png')).width(100).height(200)
            .objectFit(ImageFit.Contain).width(100).height(200)
            .offset({x:50,y:-80})
            .onClick(()=>{
              this.isGreenLight = !this.isGreenLight;
            })
          Stack() {
            Rect({width:'90%',height:200}).fill(Color.White).opacity(0.8)
              .radius(10)
              .offset({x:-15,y:0})
            Text(this.message)
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .width('90%').height(200)
          }.width('60%').offset({x:300,y:-80})
          .onClick(()=>{
            let talk:TalkData = {
              avatar:$rawfile('avatar_traffic.png'),
              name:'安心小姐',
              message:talks[getRandomNum(0,talks.length-1)]
            };

            this.openTalkDialog(talk);
          })
        }.width('100%')
        Stack() {
          Row() {
            // 反向 车、行人
            Image(this.leftHazard.img).width(this.leftHazard.imgSize).height(this.leftHazard.imgSize)
              .objectFit(ImageFit.Contain).width(this.leftHazard.imgSize).height(this.leftHazard.imgSize)
              .offset({ x:-50, y: 25})
              .visibility(this.isNoLeftHazard?Visibility.Hidden:Visibility.Visible)
              .onClick(()=>{
                this.isNoLeftHazard = !this.isNoLeftHazard;
                console.info('[Click]输出isNoLeftHazard：'+this.isNoLeftHazard);
              })
            // 潜在威胁
            Image(this.rightHazard_1.img).width(this.rightHazard_1.imgSize).height(this.rightHazard_1.imgSize)
              .objectFit(ImageFit.Contain).width(this.rightHazard_1.imgSize).height(this.rightHazard_1.imgSize)
              .offset({ x: 200, y: 50 })
              .visibility((this.rightHazardNum==1||this.rightHazardNum==3)?Visibility.Visible:Visibility.Hidden)
              .onClick(()=>{
                this.rightHazardNum = this.rightHazardNum-1;
              })
            // 其他路人1
            Image(this.rightPedestrian_1.img).width(this.rightPedestrian_1.imgSize).height(this.rightPedestrian_1.imgSize)
              .objectFit(ImageFit.Contain).width(this.rightPedestrian_1.imgSize).height(this.rightPedestrian_1.imgSize)
              .offset({ x: 200, y: -40 })
              .visibility((this.rightPedestrian==1||this.rightPedestrian==3)?Visibility.Visible:Visibility.Hidden)
              .onClick(()=>{
                this.handlePopup_1 = true;
              })
              .bindPopup(this.handlePopup_1,{
                message:this.rightPedestrian_1.content,
                placementOnTop: true,
                primaryButton: {
                  value: '好的，我知道啦~',
                  action: () => {
                    this.handlePopup_1 = !this.handlePopup_1
                    console.info('confirm Button click')
                  }
                },
                onStateChange: (e) => {
                  console.info(e.isVisible.toString())
                  if (!e.isVisible) {
                    this.handlePopup_1 = false
                  }
                }
              })
            // 其他路人2
            Image(this.rightPedestrian_2.img).width(this.rightPedestrian_2.imgSize).height(this.rightPedestrian_2.imgSize)
              .objectFit(ImageFit.Contain).width(this.rightPedestrian_2.imgSize).height(this.rightPedestrian_2.imgSize)
              .offset({ x: 200, y: -40 })
              .visibility((this.rightPedestrian==2||this.rightPedestrian==3)?Visibility.Visible:Visibility.Hidden)
              .onClick(()=>{
                this.handlePopup_2 = true;
              })
              .bindPopup(this.handlePopup_2,{
                message:this.rightPedestrian_2.content,
                placementOnTop: true,
                primaryButton: {
                  value: '好的，我知道啦~',
                  action: () => {
                    this.handlePopup_2 = !this.handlePopup_2
                    console.info('confirm Button click')
                  }
                },
                onStateChange: (e) => {
                  console.info(e.isVisible.toString())
                  if (!e.isVisible) {
                    this.handlePopup_2 = false
                  }
                }
              })
            // 潜在威胁2
            Image(this.rightHazard_2.img).width(this.rightHazard_2.imgSize).height(this.rightHazard_2.imgSize)
              .objectFit(ImageFit.Contain).width(this.rightHazard_2.imgSize).height(this.rightHazard_2.imgSize)
              .offset({ x: 200, y: 25 })
              .visibility((this.rightHazardNum==2||this.rightHazardNum==3)?Visibility.Visible:Visibility.Hidden)
              .onClick(()=>{
                this.rightHazardNum = this.rightHazardNum-2;
              })
          }.width('100%')
          Image(this.img).width(100).height(100)
            .objectFit(ImageFit.Contain).width(100).height(100)
            .offset(this.position)
            .onClick(()=>{
              if (this.isRightPlace) {
                this.position = {x:100,y:-20};
              } else {
                this.position = {x:-350,y:-20};
              }
              this.isRightPlace = !this.isRightPlace;
            })
        }
        .width('100%')
        .height('30%')
        Row({space:10}) {
          Text('现在，我可以过马路了吗？').fontSize(20).fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Button('ok').fontSize(20)
            .onClick(()=>{
              if (this.isGreenLight&&this.isRightPlace&&this.isNoLeftHazard&&this.rightHazardNum==0) {
                //  成功过街
                prompt.showToast({
                  message:'恭喜你，过街成功啦！',
                  duration:2000
                })
                // 过街动画
                var x = Number(this.position.x);
                var y = Number(this.position.y);
                this.arr = getPath(x,y);
                let timeId = setInterval(()=>{
                  this.position = this.arr[count++];
                  if (count>this.arr.length-1){
                    count = 0;
                  }
                },100)
                setTimeout(()=>{
                  clearInterval(timeId);
                  router.push({
                    uri: 'pages/store'
                  })
                },1600)
              } else {
                // 仍然有潜在危险
                prompt.showToast({
                  message:'再找找看~',
                  duration:2000
                })
              }
            })
        }.offset({x:100,y:70})
        .width('50%').height('5%')
      }
      .width('100%')
    }
    .height('100%')
    .backgroundImage($rawfile('bg_traffic.jpg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}