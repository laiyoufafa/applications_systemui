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

import ConfigData from '../common/constants';
import Log from '../../../../../../../common/src/main/ets/default/log';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager'
import BundleResourceModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/bundleresourcemodel';
import NoDisturbComponentViewModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/vm/nodisturbcomponentviewmodel'
import Router from '@system.router';

const TAG = 'NotificationManagement-NotificationManagenmentViewModel'

export default class NotificationManagenmentViewModel extends NoDisturbComponentViewModel {
  isPhone = false;
  ViewModelInit(): void{
    Log.showInfo(TAG, 'ViewModelInit');
    super.ViewModelInit();
    this.MigrateTo();
    this.judgeDeviceType();
  }

  RefreshNoDisturbState() {
    super.ViewModelInit();
  }

  MigrateTo() {
    Log.showInfo(TAG, 'MigrateTo');
    //get the want
    let want = globalThis[AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_want'];
    Log.showInfo(TAG, `aboutToAppear want:${JSON.stringify(want)}`)
    if (!want || !want.parameters.migrateUri || !want.parameters.migrateBundle) {
      return;
    }
    let migrateUri = want.parameters.migrateUri;
    let bundleName = want.parameters.migrateBundle;
    Log.showInfo(TAG, `aboutToAppear migrateUri:${migrateUri} migrateBundle:${JSON.stringify(bundleName)}`)

    let dataModel: BundleResourceModel = new BundleResourceModel()
    dataModel.getBundleInfo(bundleName, (bundleInfo) => {
      Log.showInfo(TAG, `MigrateTo bundleInfo:${JSON.stringify(bundleInfo)}`);
      //to next page
      Router.push({
        uri: migrateUri, params: bundleInfo
      });
    });
    //clear want
    globalThis[AbilityManager.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_want'] = null;
  }

  judgeDeviceType(){
    Log.showInfo(TAG, "judgeDeviceType");
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_APP_LIST, 'dis');
    Log.showInfo(TAG, `judgeDeviceType, configInfo: ${configInfo} `);
    if (configInfo.width < configInfo.height) {
      this.isPhone = true;
    }
  }
}