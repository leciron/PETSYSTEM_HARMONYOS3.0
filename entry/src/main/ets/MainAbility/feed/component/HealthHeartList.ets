import { HeartData , heart} from '../model/HeartData';


@Component
export struct HealthHeartList {
  @Link list:Array<HeartData>;

  build() {
    Row(){
      Grid(){
        ForEach(this.list, (item:HeartData)=>{
          GridItem(){
            Image(item.isOn?heart[1]:heart[0]).width(40).height(40)
              .objectFit(ImageFit.Contain).width(40).height(40)
          }
        }, item=>item.id.toString())
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    }.width(210).height(40)
  }
}