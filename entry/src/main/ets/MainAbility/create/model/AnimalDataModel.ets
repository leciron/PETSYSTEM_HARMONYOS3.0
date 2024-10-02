import {AnimalData} from './AnimalData'

const AnimalComposition: any[] = [
  {
    "animalId": 0,
    "animalName": "小棕熊",
    "animalType": "bear",
    "imgURL": $rawfile('animal_bear.png'),
    "content": "这是来自森林星球forest的小棕熊，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 1,
    "animalName": "茶杯鸟",
    "animalType": "bird",
    "imgURL": $rawfile('animal_bird.png'),
    "content": "这是来自蓝天星球blue sky的茶杯鸟，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 2,
    "animalName": "桔子猫",
    "animalType": "cat",
    "imgURL": $rawfile('animal_cat.png'),
    "content": "这是来自原野星球的桔子猫，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 3,
    "animalName": "奔奔驴",
    "animalType": "donkey",
    "imgURL": $rawfile('animal_donkey.png'),
    "content": "这是来自原野星球forest的奔奔驴，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 4,
    "animalName": "蓝象",
    "animalType": "elephant",
    "imgURL": $rawfile('animal_elephant.png'),
    "content": "这是来自森林星球forest的蓝象，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 5,
    "animalName": "跳狐狸",
    "animalType": "bear",
    "imgURL": $rawfile('animal_fox.png'),
    "content": "这是来自森林星球forest的跳狐狸，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 6,
    "animalName": "快乐蛙",
    "animalType": "frog",
    "imgURL": $rawfile('animal_frog.png'),
    "content": "这是来自森林星球forest的快乐蛙，打个招呼吧~",
    "isVisible": true
  },
  {
    "animalId": 7,
    "animalName": "好奇鼠",
    "animalType": "mice",
    "imgURL": $rawfile('animal_mice.png'),
    "content": "这是来自森林星球forest的好奇鼠，打个招呼吧~",
    "isVisible": true
  }
]

// 获取角色列表
export function getAnimalDatas(): Array<AnimalData> {
  let animalArray :Array<AnimalData> = []
  AnimalComposition.forEach(item=>{
    animalArray.push(new AnimalData(item.animalId, item.animalName, item.animalType,
    item.imgURL, item.content, item.isVisible));
  })
  return animalArray
}

// 通过ID获取角色信息
export function getAnimalById(id:number):AnimalData {
  let animal = AnimalComposition[id];
  return animal;
}

export function getAnimalImgById(id:number):Resource {
  let animal:AnimalData = AnimalComposition[id];
  return animal.imgURL;
}

export const hungerResponse = [
  {
    full:$rawfile('full_bear.png'),
    hungry:$rawfile('hungry_bear.png')
  },
  {
    full:$rawfile('full_bird.png'),
    hungry:$rawfile('hungry_bird.png')
  },
  {
    full:$rawfile('full_cat.png'),
    hungry:$rawfile('hungry_cat.png')
  },
  {
    full:$rawfile('full_donkey.png'),
    hungry:$rawfile('hungry_donkey.png')
  },
  {
    full:$rawfile('full_elephant.png'),
    hungry:$rawfile('hungry_elephant.png')
  },
  {
    full:$rawfile('full_fox.png'),
    hungry:$rawfile('hungry_fox.png')
  },
  {
    full:$rawfile('full_frog.png'),
    hungry:$rawfile('hungry_frog.png')
  },
  {
    full:$rawfile('full_mice.png'),
    hungry:$rawfile('hungry_mice.png')
  },
];