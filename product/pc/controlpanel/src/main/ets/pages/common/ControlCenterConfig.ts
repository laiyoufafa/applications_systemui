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
import {FASlotName} from '../../../../../../../../common/src/main/ets/default/Constants';

type pluginIconData = {
  id: string;
  bundleName: string;
  abilityName: string;
};
type Config = {
  ComplexToggleLayout: Array<string>;
  DefaultSimpleToggleLayout: Array<string>;
  LocalToggles: {
    ComplexToggles: Array<string>;
    SimpleToggles: Array<string>;
  };
  MetaToggles: Array<pluginIconData>;
};

const ControlCenterConfig: Config = {
  ComplexToggleLayout: [FASlotName.WIFI, FASlotName.BLUETOOTH],
  DefaultSimpleToggleLayout: ["screenshot", FASlotName.RING_MODE, FASlotName.LOCATION],
  LocalToggles: {
    ComplexToggles: [FASlotName.AIR_PLANE, FASlotName.BLUETOOTH, FASlotName.WIFI],
    SimpleToggles: [FASlotName.LOCATION, FASlotName.RING_MODE],
  },
  MetaToggles: [
    {
      id: "screenshot",
      bundleName: "com.ohos.screenshot",
      abilityName: "com.ohos.screenshot.ServiceExtAbility",
    },
  ],
};

export default ControlCenterConfig;
