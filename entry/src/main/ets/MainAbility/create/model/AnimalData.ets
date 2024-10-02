export class AnimalData {
  animalId: number;
  animalName: string;
  animalType: string;
  imgURL: Resource;
  content: string;
  isVisible: boolean;

  constructor(animalId: number, animalName: string, animalType: string, imgURL: Resource, content: string, isVisible: boolean) {
    this.animalId = animalId;
    this.animalName = animalName;
    this.animalType = animalType;
    this.imgURL = imgURL;
    this.content = content;
    this.isVisible = isVisible;
  }
}

