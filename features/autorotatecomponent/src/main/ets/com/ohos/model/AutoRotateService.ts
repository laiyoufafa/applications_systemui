/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import screen from '@ohos.screen';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import createOrGet from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';

const TAG = 'AutoRotateModel';

export class AutoRotateService {
  mIsStart: boolean = false;
  mListener: any;

  constructor() {
  }

  registerListener(listener: {
    'updateAutoRotateSwitchStatus': Function,
  }) {
    Log.showInfo(TAG, `registerListener, listener: ${listener}`)
    this.mListener = listener;
  }

  startService() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `startService`)
    this.mIsStart = true;
    this.asyncStartService();
  }

  async asyncStartService(): Promise<void> {
    Log.showInfo(TAG, `asyncStartService`)
    this.getOrientation();
    screen.on('change', this.onOrientationChange.bind(this));
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `stopService`)
    this.mIsStart = false;
    this.asyncStopService();
  }

  async asyncStopService(): Promise<void> {
    Log.showInfo(TAG, `asyncStopService`)
    screen.off('change', (value: number) => {
      Log.showInfo(TAG, `asyncStopService, off change value: ${value}`)
    });
  }

  onOrientationChange(value: number): void{
    Log.showInfo(TAG, `onOrientationChange, value: ${value}`)
    this.getOrientation();
  }

  async getOrientation(): Promise<void> {
    Log.showInfo(TAG, `getOrientation`)
    let mScreen = await this.getScreen();
    this.updateAutoRotateSwitchStatus(mScreen.orientation);
  }

  async changeSwitch(status: boolean): Promise<void> {
    Log.showInfo(TAG, `changeSwitch, status: ${status}`)
    let newOrientation = status ? 5 : 0;
    let mScreen = await this.getScreen();
    let ret = await mScreen.setOrientation(newOrientation);
    Log.showInfo(TAG, `changeSwitch, ret: ${ret}`)
  }

  updateAutoRotateSwitchStatus(orientation: number): void{
    Log.showInfo(TAG, `updateAutoRotateSwitchStatus, orientation: ${orientation}`)
    if (orientation == 0) {
      this.mListener?.updateAutoRotateSwitchStatus(false);
    } else if (orientation == 5) {
      this.mListener?.updateAutoRotateSwitchStatus(true);
    }
  }

  async getScreen(): Promise<any> {
    Log.showInfo(TAG, `getScreen`)
    let screens = await screen.getAllScreen();
    return screens[0];
  }
}


let sAutoRotateService = createOrGet(AutoRotateService, TAG);

export default sAutoRotateService as AutoRotateService;
