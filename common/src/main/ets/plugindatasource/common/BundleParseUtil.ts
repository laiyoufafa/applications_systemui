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

import bundleManager from "@ohos.bundle";
import commonEvent from "@ohos.commonEvent";
import { AbilityInfo } from "bundle/abilityInfo";
import Log from "../../default/Log";

export type AbilityInfoWithId = AbilityInfo & { itemId: string };
export type BundleListener = {
  onBundleNotify: (bundleName: string, event: BundleEventType) => void;
};
export type ListenerHandle = {
  unRegister: () => void;
};
export type PluginData = {
  [key: string | number]: any;
};

export enum BundleEventType {
  BUNDLE_ADD,
  BUNDLE_CHANGE,
  BUNDLE_REMOVE,
  UNKNOWN_EVENT,
}

const TAG = "SourceLoader-BundleParseUtil";
const DEFAULT_BUNDLE_FLAG =
  bundleManager.BundleFlag.GET_ABILITY_INFO_WITH_METADATA | bundleManager.BundleFlag.GET_ABILITY_INFO_WITH_PERMISSION;
const BUNDLE_SUBSCRIBE_INFO = {
  events: [
    commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED,
    commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED,
    commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED,
  ],
};

export async function queryAbility(action: string, userId: number, bundleName?: string): Promise<Array<AbilityInfo>> {
  if (bundleName) {
    return await bundleManager.queryAbilityByWant(
      {
        action: action,
        bundleName: bundleName,
      },
      DEFAULT_BUNDLE_FLAG,
      userId
    );
  }
  return await bundleManager.queryAbilityByWant({ action: action }, DEFAULT_BUNDLE_FLAG, userId);
}

export function filterAbilityInfo(info: AbilityInfoWithId, filterKey: string): PluginData | undefined {
  let pluginDatas = info.metaData.filter((data) => data.name == filterKey);
  if (!pluginDatas.length) {
    Log.showDebug(TAG, `filterKey: ${filterKey}, metaData: ${JSON.stringify(info.metaData.values)}`);
    return undefined;
  }
  let pluginData = JSON.parse("{" + pluginDatas[0].extra + "}");
  if (!pluginData) {
    Log.showError(TAG, `Can't parse pluginData: ${pluginDatas[0]}， filterKey: ${filterKey}`);
    return undefined;
  }
  Log.showInfo(TAG, `createItemComponentData, pluginData: ${JSON.stringify(pluginData)}`);
  return pluginData;
}

export function registerBundleListener(listener: BundleListener, callback: (handle: ListenerHandle) => void) {
  commonEvent.createSubscriber(BUNDLE_SUBSCRIBE_INFO, (err, handle) => {
    Log.showDebug(TAG, `registerBundleListener, err: ${JSON.stringify(err)}, handle: ${handle}`);
    if (err.code != 0) {
      Log.showError(TAG, `Can't regitser bundle subscribe, err: ${JSON.stringify(err)}`);
      return;
    }
    commonEvent.subscribe(handle, (err, data) => {
      Log.showDebug(TAG, `bundle change, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      if (err.code != 0) {
        Log.showError(TAG, `Can't handle bundle change, err: ${JSON.stringify(err)}`);
        return;
      }
      let event = BundleEventType.UNKNOWN_EVENT;
      switch (data.event) {
        case commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED:
          event = BundleEventType.BUNDLE_ADD;
          break;
        case commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED:
          event = BundleEventType.BUNDLE_CHANGE;
          break;
        case commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED:
          event = BundleEventType.BUNDLE_REMOVE;
          break;
        default:
          Log.showError(TAG, `unknow event: ${event}`);
      }
      listener.onBundleNotify(data.bundleName ?? "unkown", event);
    });
    callback({
      unRegister: () => {
        commonEvent.unsubscribe(handle, () => {
          Log.showInfo(TAG, `unRegister bundle info listener, handle: ${handle}`);
        });
      },
    });
  });
}
