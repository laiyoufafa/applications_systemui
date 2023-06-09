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
import ServiceExtension from '@ohos.application.ServiceExtensionAbility'
import Log from '../../../../../../common/src/main/ets/default/Log'
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import initSystemUi from '../../../../../../common/src/main/ets/default/InitSystemUi'

const TAG = "SystemUI_ServiceExtAbility"

var statusBarWant = {
    "bundleName": "com.ohos.systemui",
    "abilityName": "com.ohos.systemui.statusbar.ServiceExtAbility"
}

var navigationBarWant = {
    "bundleName": "com.ohos.systemui",
    "abilityName": "com.ohos.systemui.navigationbar.ServiceExtAbility"
}

var volumePanelWant = {
    "bundleName": "com.ohos.systemui",
    "abilityName": "com.ohos.systemui.volumepanel.ServiceExtAbility"
}

var controlPanelWant = {
    "bundleName": "com.ohos.systemui",
    "abilityName": "com.ohos.systemui.controlpanel.ServiceExtAbility"
}

var notificationPanelWant = {
    "bundleName": "com.ohos.systemui",
    "abilityName": "com.ohos.systemui.notificationpanel.ServiceExtAbility"
}

class ServiceExtAbility extends ServiceExtension {
    onCreate(want) {
        Log.showInfo(TAG, `api8New onCreate, want: ${JSON.stringify(want)}`)
        initSystemUi(this.context);
        AbilityManager.setContext(AbilityManager.ABILITY_NAME_ENTRY, this.context)
        AbilityManager.startAbility(statusBarWant)
        AbilityManager.startAbility(navigationBarWant)
        AbilityManager.startAbility(volumePanelWant)
        AbilityManager.startAbility(controlPanelWant)
        AbilityManager.startAbility(notificationPanelWant)
    }

    onDestroy() {
        Log.showInfo(TAG, 'api8New onDestroy')
    }
}

export default ServiceExtAbility