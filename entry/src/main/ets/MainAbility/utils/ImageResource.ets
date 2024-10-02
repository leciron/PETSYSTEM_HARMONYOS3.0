import { getFoodDatas } from '../feed/model/FoodDataModel';
import { MyDataSource } from '../constants/MyDataSource';
import { getAnimalDatas } from '../create/model/AnimalDataModel';
export class ImageResource {
  private sysCharacterList: MyDataSource = new MyDataSource([])
  private sysFoodList: MyDataSource = new MyDataSource([])

  constructor() {
    let list_1 = getAnimalDatas();
    this.sysCharacterList = new MyDataSource(list_1);

    let list_2= getFoodDatas();
    this.sysFoodList = new MyDataSource(list_2);
  }

  /* 角色相关 */

  /**
   * Character - 根据下标获取相应 系统角色 的图像
   * @param index
   */
  getSysCharacterImg (index:number):Resource {
    let temp = this.sysCharacterList.getData(index);
    let imgURL = temp.imgURL;
    return imgURL;
  }


  /* 食物相关 */

  /**
   * Food - 根据下标获取相应 系统食物 的图像 - 【测试】
   * @param index
   */
  getSysFoodImg (index:number):string {
    let temp = this.sysFoodList.getData(index);
    let imgURL = temp.imgURL;
    return imgURL;
  }
}