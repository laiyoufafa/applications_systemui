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

import image from "@ohos.multimedia.image"
import Log from '../../../../../../../common/src/main/ets/default/Log'
import Notification from './notification'
import WindowManager, {
  WindowType,
  WINDOW_SHOW_HIDE_EVENT,
} from "../../../../../../../common/src/main/ets/default/WindowManager";
import EventManager, {unsubscribe} from "../../../../../../../common/src/main/ets/default/event/EventManager";
import {START_ABILITY_EVENT} from "../../../../../../../common/src/main/ets/default/event/EventUtil";
import MultimodalInputManager, {
  MultiKeyCode,
} from "../../../../../../../common/src/main/ets/default/MultimodalInputManager";

const TAG = 'NotificationPanel-Index'
const SHOW_EVENT = "showNotificationPanel";
const HIDE_EVENT = "hideNotificationPanel";
const SHOW_ANIM_CONFIG = {
  duration: 300,
  tempo: 1.0,
  curve: Curve.Friction,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal,
}
const HIDE_ANIM_CONFIG = {
  duration: 200,
  tempo: 1.0,
  curve: Curve.EaseOut,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal,
}

@Entry
@Component
struct Index {
  @State mBlur: number = 0;
  @State mOpacity: number = 0.0;
  @State mWidthSize: number = 0.2
  @State mHeightSize: number = 0.2
  @State mBackground: PixelMap | undefined = undefined;
  mClearCallbacks: Array<unsubscribe> = [];
  mShowAnimReady: boolean = false;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`)
    setAppBgColor('#00000000')
    this.initWindowPolicy();
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow`)
    this.startShowAnim();
  }

  onPageHide() {
    Log.showInfo(TAG, `onPageHide`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    this.mClearCallbacks.forEach((unsubscribe) => unsubscribe());
    this.mClearCallbacks.length = 0;
  }

  build() {
    Stack() {
      Image(this.mBackground)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
      Column() {
        Notification()
      }
      .backgroundColor($r('app.color.default_background'))
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .clip(true)
    .opacity(this.mOpacity)
    .borderRadius($r('app.float.default_border_radius'))
    .scale({
      x: this.mWidthSize,
      y: this.mHeightSize,
      z: 1,
      centerX: '100%',
      centerY: '0%'
    })
  }

  initWindowPolicy() {
    Log.showInfo(TAG, `init notification panel window Policy`);
    this.mClearCallbacks.push(
    EventManager.subscribe(SHOW_EVENT, () => WindowManager.showWindow(WindowType.NOTIFICATION_PANEL)),
    EventManager.subscribe(HIDE_EVENT, () => this.hideWindow()),
    EventManager.subscribe(START_ABILITY_EVENT, () => this.hideWindow()),
    EventManager.subscribe(WINDOW_SHOW_HIDE_EVENT, (args) => {
      let { windowName, isShow } = args;
      Log.showInfo(TAG, `WINDOW_SHOW_HIDE_EVENT windowName: ${windowName}, isShow: ${isShow}`);
      windowName == WindowType.CONTROL_PANEL && isShow && this.hideWindow();
      windowName == WindowType.NOTIFICATION_PANEL && isShow && (this.mShowAnimReady = true);
    }),
    MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], (data) => {
      let windowInfo = WindowManager.getWindowInfo(WindowType.NOTIFICATION_PANEL);
      Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}, windowInfo: ${windowInfo?.visibility}`);
      if (windowInfo) {
          windowInfo.visibility
          ? this.hideWindow()
          : WindowManager.showWindow(WindowType.NOTIFICATION_PANEL);
      }
    })
    );
  }

  _animateTo(config, callback) {
    animateTo(config, callback)
    setTimeout(config.onFinish, config.duration + config.delay)
  }

  async startShowAnim() {
    if (!this.mShowAnimReady) {
      return;
    }
    this.mShowAnimReady = false;
    this._animateTo({ ...SHOW_ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `show anim finish.`);
      this.mBlur = 20;
    } }, () => {
      this.mBlur = 20
      this.mOpacity = 1.0
      this.mWidthSize = 1.0
      this.mHeightSize = 1.0
    })
  }

  hideWindow() {
    Log.showInfo(TAG, `hide anim start`);
    this._animateTo({ ...HIDE_ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `anim finish, hide Notification window, view: ${JSON.stringify(this)}`);
      this.mBlur = 0
      WindowManager.hideWindow(WindowType.NOTIFICATION_PANEL);
    }
    }, () => {
      Log.showInfo(TAG, `do hide anim.`);
      this.mBlur = 0
      this.mOpacity = 0.0
      this.mWidthSize = 0.2
      this.mHeightSize = 0.2
    })
  }
}
