export default interface CharacterData {
  // 角色名字
  characterName: string;
  // 角色信息下标
  characterIndex: number;
  // 饥饿值
  hunger: number;
  // 健康值
  health: number;
  // 金钱
  money: number;
  // 好感值
  favor: number;
  // 经验值
  experience: number;
  // 是否正在使用
  isOnUse: string;
}

// 示例
export let testCharacter:CharacterData = {characterName:'阿串',characterIndex:3,
hunger: 100, health: 90, money: 60, favor: 100, experience: 100,isOnUse: 'true'}

export let testCharacters: Array<CharacterData> = [
  {
    characterName:'阿串',
    characterIndex:1,
    hunger: 100, health: 90, money: 60, favor: 100, experience: 100,
    isOnUse: 'true'
  },
  {
    characterName:'阿猫',
    characterIndex:2,
    hunger: 100, health: 90, money: 60, favor: 100, experience: 100,
    isOnUse: 'true'
  },
  {
    characterName:'大坡',
    characterIndex:5,
    hunger: 100, health: 90, money: 60, favor: 100, experience: 100,
    isOnUse: 'true'
  },
];
