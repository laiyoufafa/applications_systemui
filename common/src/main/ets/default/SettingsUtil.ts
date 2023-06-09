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

import settings from "@ohos.settings";
import {DataAbilityHelper} from "ability/dataAbilityHelper";
import featureAbility from "@ohos.ability.featureAbility";
import Log from "./Log";
import Constants from "./Constants";
import createOrGet from "./SingleInstanceHelper";
import AbilityManager from "./abilitymanager/abilityManager";

const TAG = "SettingsUtil";

export class SettingsUtil {
    helper: DataAbilityHelper;

    constructor() {
        Log.showInfo(TAG, `constructor`);
        try {
            this.helper = featureAbility.acquireDataAbilityHelper(AbilityManager.getContext(), Constants.URI_VAR);
        } catch (e) {
            Log.showInfo(TAG, `constructor, acquire helper error: ${e.toString()}`);
        }
    }

    getValue(name: string, defValue?: string): string {
        Log.showInfo(TAG, `getValue, name: ${name} defValue: ${defValue}`);
        let value: string = null;
        try {
            value = settings.getValueSync(this.helper, name, defValue ? defValue : "");
        } catch (e) {
            Log.showInfo(TAG, `getValue e: ${e.toString()}`);
        }
        Log.showInfo(TAG, `getValue, value: ${value}`);
        return value;
    }

    setValue(name: string, value: string): boolean {
        Log.showInfo(TAG, `setValue, name: ${name} value: ${value}`);
        let result = false;
        try {
            result = settings.setValueSync(this.helper, name, value);
        } catch (e) {
            Log.showInfo(TAG, `setValue e: ${e.toString()}`);
        }
        Log.showInfo(TAG, `setValue, result: ${result}`);
        return result;
    }
}

let sSettingsUtil = createOrGet(SettingsUtil, TAG);

export default sSettingsUtil as SettingsUtil;