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

import ServiceExtension from "@ohos.application.ServiceExtensionAbility";
import Log from "../../../../../../../common/src/main/ets/default/Log";
import WindowManager, { WindowType } from "../../../../../../../common/src/main/ets/default/WindowManager";
import AbilityManager from "../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager";
import StatusBarConfiguration from "../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/StatusBarConfiguration";

const TAG = "StatusBar_ServiceExtAbility";

class ServiceExtAbility extends ServiceExtension {
    async onCreate(want) {
        Log.showInfo(TAG, `api8New onCreate, want: ${JSON.stringify(want)}`);
        AbilityManager.setContext(AbilityManager.ABILITY_NAME_STATUS_BAR, this.context);

        let configInfo = await StatusBarConfiguration.getConfiguration();
        if (configInfo.showHorizontal) {
            configInfo.realHeight = (configInfo.realHeight * configInfo.maxWidth) / 1280;
            configInfo.minHeight = configInfo.realHeight;
            if (configInfo.yCoordinate > 0) {
                configInfo.yCoordinate = configInfo.maxHeight - configInfo.realHeight;
            }
        } else {
            configInfo.realWidth = (configInfo.realWidth * configInfo.maxWidth) / 1280;
            configInfo.minHeight = configInfo.realWidth;
            if (configInfo.xCoordinate > 0) {
                configInfo.xCoordinate = configInfo.maxWidth - configInfo.realWidth;
            }
        }
        AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, "config", configInfo);
        Log.showInfo(TAG, `api8New onCreate, configInfo: ${JSON.stringify(configInfo)}`);

        let statusBarRect = {
            left: configInfo.xCoordinate,
            top: configInfo.yCoordinate,
            width: configInfo.realWidth,
            height: configInfo.realHeight,
        };
        WindowManager.createWindow(this.context, WindowType.STATUS_BAR, statusBarRect, "pages/index").then(() =>
            WindowManager.showWindow(WindowType.STATUS_BAR)
        );
    }

    onDestroy() {
        Log.showInfo(TAG, "api8New onDestroy");
    }
}

export default ServiceExtAbility;
