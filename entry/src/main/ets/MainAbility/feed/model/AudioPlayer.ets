import prompt from '@ohos.prompt';
import { Logger } from '../../utils/Logger';
import media from '@ohos.multimedia.media'
import fileIO from '@ohos.fileio';
import featureAbility from '@ohos.ability.featureAbility';

// 打印码流轨道信息
export function printfDescription(obj) {
  for (let item in obj) {
    let property = obj[item];
    console.info('audio key is ' + item);
    console.info('audio value is ' + property);
  }
}

export function audio_On_Play(audioPlayer){
  audioPlayer.on('dataLoad', () => {              //设置'dataLoad'事件回调，src属性设置成功后，触发此回调
    console.info('audio set source success');
    audioPlayer.play();                           //调用play方法开始播放，触发'play'事件回调
  });
  audioPlayer.on('play', () => {                  //设置'play'事件回调
    console.info('audio play success');
  });
  audioPlayer.on('finish', () => {                //设置'finish'事件回调，播放完成触发
    console.info('audio play finish');
    audioPlayer.release();                        //audioPlayer资源被销毁
    audioPlayer = undefined;
    prompt.showToast({
      message: 'audio finished.',
      duration: 2000
    })
  });
}

// 设置播放器回调函数
export function setAudioCallBack(audioPlayer) {
  audioPlayer.on('dataLoad', () => { // 设置'dataLoad'事件回调，src属性设置成功后，触发此回调
    console.info('audio set source success');
    audioPlayer.play(); // 需等待'dataLoad'事件回调完成后，才可调用play进行播放，触发'play'事件回调
  });
  audioPlayer.on('play', () => { // 设置'play'事件回调
    console.info('audio play success');
    audioPlayer.pause(); // 触发'pause'事件回调，暂停播放
  });
  audioPlayer.on('pause', () => { // 设置'pause'事件回调
    console.info('audio pause success');
    audioPlayer.seek(5000); // 触发'timeUpdate'事件回调，seek到5000ms处播放
  });
  audioPlayer.on('stop', () => { // 设置'stop'事件回调
    console.info('audio stop success');
    audioPlayer.reset(); // 触发'reset'事件回调后，重新设置src属性，可完成切歌
  });
  audioPlayer.on('reset', () => { // 设置'reset'事件回调
    console.info('audio reset success');
    audioPlayer.release(); // audioPlayer资源被销毁
    audioPlayer = undefined;
  });
  audioPlayer.on('timeUpdate', (seekDoneTime) => { // 设置'timeUpdate'事件回调
    if (typeof(seekDoneTime) == 'undefined') {
      console.info('audio seek fail');
      return;
    }
    console.info('audio seek success, and seek time is ' + seekDoneTime);
    audioPlayer.setVolume(0.5); // 触发'volumeChange'事件回调
  });
  audioPlayer.on('volumeChange', () => { // 设置'volumeChange'事件回调
    console.info('audio volumeChange success');
    audioPlayer.getTrackDescription((error, arrlist) => { // 通过回调方式获取音频轨道信息
      if (typeof (arrlist) != 'undefined') {
        for (let i = 0; i < arrlist.length; i++) {
          printfDescription(arrlist[i]);
        }
      } else {
        console.log(`audio getTrackDescription fail, error:${error.message}`);
      }
      audioPlayer.stop(); // 触发'stop'事件回调，停止播放
    });
  });
  audioPlayer.on('finish', () => { // 设置'finish'事件回调，播放完成触发
    console.info('audio play finish');
  });
  audioPlayer.on('error', (error) => { // 设置'error'事件回调
    console.info(`audio error called, errName is ${error.name}`);
    console.info(`audio error called, errCode is ${error.code}`);
    console.info(`audio error called, errMessage is ${error.message}`);
  });
}

/**
 * 创建音频播放器，播放给定音频 fileName:string
 * @param fileName '/01.mp3'
 */
export async function audioPlayer() {
//  let uri = '/data/user/0/com.example.petdemo/files/orange_juice.mp3'
  /*
 *  创建播放器实例，设置audio的播放路径
 * */
  // 1. 创建实例
  let audioPlayer = media.createAudioPlayer();
  setAudioCallBack(audioPlayer); // 设置事件回调
  // 2. 用户选择音频，设置uri
  let fdPath = 'fd://'
  // path路径的码流可通过"hdc file send D:\OHOSProjects\MusicPlayer_API9_eTS_Stage\entry\src\main\ets\pages\PlayBulk\New_Soul.mp3 /data/user/0/com.leeg.musicplayer8/files" 命令，将其推送到设备上
  let path = '/data/user/0/com.example.testdistributeddb/files/orange_juice.mp3';
  let dest = '/data/user/0/com.example.testdistributeddb/files/cache_files/orange_juice.mp3'

  /*
   *  由于上传文件后操作权限不足，需要先将文件copy之后再进行下一步的open操作，如何获取权限还在研究【未完待续，我迟早会回来的】
   * */
  fileIO.copyFile(path, dest, 0).then(function () {
    console.info("Leeg : copyFile succeed");
    console.info('Leeg : Current File Path is ' + dest)
  }).catch(function (err) {
    console.info("Leeg : copyFile failed with error:" + err);
  });

  /*
   *  打开文件成功之后使用音频播放器进行播放
   * */
  fileIO.open(dest).then((fdNumber) => {
    console.info('Leeg : Open Begin')
    fdPath = fdPath + '' + fdNumber;
    console.info('Leeg ： open fd success fd is' + fdPath);
    console.info('Leeg : Current fdPath is ' + fdPath);
    prompt.showToast({
      message:'打开成功！',
      duration: 2000
    })
  }, (err) => {
    console.info('Leeg ： open fd failed err is' + err);
  }).catch((err) => {
    console.info('Leeg ： open fd failed err is' + err);
  });

  audioPlayer.src = fdPath; // 设置src属性，并触发'dataLoad'事件回调
}