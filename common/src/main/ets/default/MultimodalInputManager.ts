/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import inputConsumer from "@ohos.multimodalInput.inputConsumer";
import Log from "./Log";
import createOrGet from "./SingleInstanceHelper";

export type MultiCallback = (keyOptions: typeof inputConsumer.KeyOptions) => void;
export enum MultiKeyCode {
  WIN = 2076,
  N = 2030,
  I = 2025,
}

const TAG = "MultimodalInputManager";

class MultimodalInputManager {
  //win + N
  notificationKeyOptions: any = {
    preKeys: [2076],
    finalKey: 2030,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };
  //win + I
  controlKeyOptions: any = {
    preKeys: [2076],
    finalKey: 2025,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
  };

  subscribeCombinationKey(keys: MultiKeyCode[], cb: MultiCallback): () => void {
    if (keys.length <= 1) {
      Log.showError(TAG, `Invalid keys, can't subscribe.`);
      return () => {};
    }
    let keyOptions = {
      preKeys: keys.slice(0, keys.length - 1),
      finalKey: keys[keys.length - 1],
      isFinalKeyDown: true,
      finalKeyDownDuration: 0,
    };
    inputConsumer.on("key", keyOptions, (err, options) => {
      Log.showInfo(TAG, `on CombinationKey, options:${JSON.stringify(options)}, err: ${JSON.stringify(err)}`);
      cb(options);
    });
    Log.showInfo(TAG, `subscribe CombinationKey, keys:${JSON.stringify(keys)}`);
    return () => {
      inputConsumer.off("key", keyOptions, (err, data) => {});
    };
  }

  registerControlListener(callback) {
    Log.showInfo(TAG, `registerListener control`);
    inputConsumer.on("key", this.controlKeyOptions, (err, data) => {
      Log.showInfo(TAG, `controlRegisterCallBack err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      callback.onControlShowOrHide(err, data);
    });
    Log.showInfo(TAG, `registerListener end`);
  }

  registerNotificationListener(callback) {
    Log.showInfo(TAG, `registerListener notification`);
    inputConsumer.on("key", this.notificationKeyOptions, (err, data) => {
      Log.showInfo(TAG, `notificationRegisterCallBack err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      callback.onNotificationShowOrHide(err, data);
    });
    Log.showInfo(TAG, `registerListener end`);
  }

  unregisterListener() {
    Log.showInfo(TAG, `unregisterListener start`);
    inputConsumer.off("key", this.notificationKeyOptions, (err, data) => {
      Log.showInfo(TAG, `notificationUnregisterCallBack err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    });
    inputConsumer.off("key", this.controlKeyOptions, (err, data) => {
      Log.showInfo(TAG, `controlUnregisterCallBack err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    });
    Log.showInfo(TAG, `unregisterListener end`);
  }
}
let sMultimodalInputManager = createOrGet(MultimodalInputManager, TAG);

export default sMultimodalInputManager as MultimodalInputManager;
