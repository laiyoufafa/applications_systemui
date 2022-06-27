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

import ServiceExtension from '@ohos.application.ServiceExtensionAbility';
import Want from '@ohos.application.Want';
import display from '@ohos.display';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import VolumeWindowController from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/common/VolumeWindowController';

const TAG = 'VolumePanel_ServiceExtAbility';

class ServiceExtAbility extends ServiceExtension {
  onCreate(want: Want): void {
    Log.showInfo(TAG, `onCreate, want:${want.abilityName}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_VOLUME_PANEL, this.context);
    display.getDefaultDisplay().then((dis) => {
      let volumeRect = {
        left: 0,
        top: 0,
        width: dis.width,
        height: dis.height,
      };

      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis', {
        width: dis.width,
        height: dis.height,
      });
      WindowManager.createWindow(this.context, WindowType.VOLUME_PANEL, volumeRect, 'pages/index')
        .then((win) => {
          Log.showInfo(TAG, 'onCreate, createWindow callback');
          VolumeWindowController.getInstance().setWindowHandle(win);
        })
        .catch((err) => Log.showError(TAG, `Can't create window, err:${JSON.stringify(err)}`));
    }).then(() => {
    }).catch((err) => {
    });
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
