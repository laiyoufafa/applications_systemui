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

import mBatteryModel from '../batteryModel';
import BatteryPic from './batteryPic'
import BatterySoc from './batterySoc'
import Constants from '../common/constants'
import Log from '../../../../../../../common/src/main/ets/default/Log'
import StyleConfigurationCommon from '../../../../../../../common/src/main/ets/default/StyleConfiguration'
import StyleConfiguration from '../common/StyleConfiguration'

const TAG = 'BatteryComponent-batteryIcon'

@Component
export default struct BatteryIcon {
  @StorageLink('batterySoc') batterySoc: number = 100
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  @State style: any = StyleConfiguration.getBatteryComponentStyle()
  @State styleCommon: any = StyleConfigurationCommon.getCommonStyle()

  aboutToAppear() {
    mBatteryModel.initBatteryModel();
    Log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      Row().width(this.styleCommon.statusBarMarginLeftRight).height('100%')
      BatterySoc()
      Row().width(this.style.componentGap).height('100%')
      BatteryPic()
      Row().width(this.styleCommon.statusBarMarginLeftRight).height('100%')
    }
    .height('100%')
  }
}