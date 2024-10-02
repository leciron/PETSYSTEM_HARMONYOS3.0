import { Logger } from '../../utils/Logger';
import dataStorage from '@ohos.data.storage'
import featureAbility from '@ohos.ability.featureAbility'

const TAG: string = 'LiteStore'

// storage支持存储 number string boolean
export class LiteStore {
  private store: dataStorage.Storage = undefined
  private key: string = ''

  constructor(key: string) {
    this.key = key
  }

  async setValue(value) {
    if (this.store === undefined) {
      await this.getStore()
    }
    Logger.info(TAG, `setValue: ${value}`)
    await this.store.put(this.key, value)
    await this.store.flush()
  }

  async getValue() {
    if (this.store === undefined) {
      await this.getStore()
    }
    // 若没有返回数据，则返回默认值
    let result = await this.store.get(this.key,'')
    Logger.info(TAG, `getValue: ${result}`)
    return result
  }

  async getStore() {
    let context = featureAbility.getContext()
    let path = await context.getFilesDir()
    this.store = await dataStorage.getStorage(path + '/mystore')
  }
}

// 注册默认创建
// export default new LiteStore(KEY)