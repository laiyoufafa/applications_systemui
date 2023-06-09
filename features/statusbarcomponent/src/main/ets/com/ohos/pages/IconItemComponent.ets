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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import EventManager, {unsubscribe} from '../../../../../../../../common/src/main/ets/default/event/EventManager'
import CheckEmptyUtils from '../../../../../../../../common/src/main/ets/default/CheckEmptyUtils'
import {WINDOW_SHOW_HIDE_EVENT} from '../../../../../../../../common/src/main/ets/default/WindowManager'
import {PluginType} from "../../../../../../../../common/src/main/ets/plugindatasource/common/Constants"
import ViewModel from '../viewmodel/StatusBarVM'
import StyleConfigurationCommon from '../../../../../../../../common/src/main/ets/default/StyleConfiguration'
import StyleConfiguration from '../common/StyleConfiguration'
import MetaIconItemComponent from './MetaIconItemComponent'

const TAG = 'IconItemComponent'

@Component
export default struct IconItemComponent {
  private keyId: string
  @State mItemData: any = {}
  @State mItemStatus: any = {
    selected: false
  }
  mClearCallback: unsubscribe | undefined
  @State style: any = StyleConfiguration.getIconItemComponentStyle()
  @State styleCommon: any = StyleConfigurationCommon.getCommonStyle()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start, keyId: ${this.keyId} `)
    this.linkItemData()
    if (this.mItemData.get()?.relationWindowId) {
      this.mClearCallback = EventManager.subscribe(WINDOW_SHOW_HIDE_EVENT, (args) => this.onWindowChange(args))
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    this.mClearCallback && this.mClearCallback()
    this.mClearCallback = undefined
  }

  linkItemData() {
    Log.showInfo(TAG, `linkItemData, keyId: ${this.keyId}`)
    this.mItemData = AppStorage.Link('StatusBar_' + this.keyId)
    Log.showInfo(TAG, `linkItemData, mItemData: ${this.keyId} ${this.mItemData.get().label} ${
    this.mItemData.get()
    .iconUrl}`)
    this.mItemStatus = AppStorage.SetAndLink('StatusBar_Status_' + this.keyId, { selected: false }).get()
  }

  build() {
    Row() {
      Row().width(this.style.marginLeft).height('100%')
      Row() {
        Row().width(this.style.stackPadding).height('100%')

        if (this.mItemData.get().pluginType == PluginType.META) {
          MetaIconItemComponent({
            keyId: this.keyId
          })
        } else if (this.mItemData.get().pluginType == PluginType.DATA_ABILITY) {
          // TODO:
        } else if (this.mItemData.get().pluginType == PluginType.PLUGIN_COMPONENT) {
          // TODO:
        }

        Row().width(this.style.stackPadding).height('100%')
      }
      .height(this.style.stackHeight)
      .borderRadius(this.style.stackBorderRadius)
      .backgroundColor(this.mItemStatus.selected ? this.style.stackBgColorSelected : this.style.stackBgColorUnSelected)
      .onClick(this.onIconItemClick.bind(this))
      .gesture(LongPressGesture({ repeat: false }).onAction(this.onIconItemLongPressGesture.bind(this)))
      .onTouch(this.onIconItemTouch.bind(this))

      Row().width(this.style.marginRight).height('100%')
    }.height('100%')
  }

  onWindowChange(args) {
    if (this.mItemData.get().canSelect && args?.windowName == this.mItemData.get().relationWindowId) {
      this.mItemStatus.selected = args?.isShow
    }
  }

  onIconItemClick(event: ClickEvent) {
    Log.showInfo(TAG, `onIconItemClick`)
    if (!this.mItemStatus.selected) {
      this.execClickAction()
    } else {
      this.execSelectedClickAction()
    }
  }

  execClickAction() {
    Log.showInfo(TAG, `execClickAction`)
    if (this.mItemData.get()?.actionData?.clickAction) {
      EventManager.publish(this.mItemData.get().actionData.clickAction)
    }
  }

  execSelectedClickAction() {
    Log.showInfo(TAG, `execSelectedClickAction ${this.mItemData.get()?.actionData?.selectedClickAction}`)
    if (this.mItemData.get()?.actionData?.selectedClickAction) {
      EventManager.publish(this.mItemData.get().actionData.selectedClickAction)
    }
  }

  onIconItemLongPressGesture(event: GestureEvent) {
    Log.showInfo(TAG, `onIconItemLongPressGesture, event: ${JSON.stringify(event)}`)
    let longClickEvent = this.mItemData.get().actionData.longClickAction;
    longClickEvent && EventManager.publish(longClickEvent);
  }

  onIconItemTouch(event: TouchEvent) {
    Log.showInfo(TAG, `onIconItemTouch, event: ${JSON.stringify(event)}`)
    if (this.mItemData.get()?.actionData?.clickAction || this.mItemData.get()?.actionData?.longClickAction) {
      event.stopPropagation()
    }
  }
}