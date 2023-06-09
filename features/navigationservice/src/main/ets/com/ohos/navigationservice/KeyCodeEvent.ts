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

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import commonEvent from '@ohos.commonevent';
import Constants from './common/constants';
import Input from '@ohos.multimodalInput.inputEventClient';
const TAG = 'KeyCodeEvent'

let res;

export class KeyCodeEvent {
  public sendKeyEvent(keyCode: number, eventType: number) {
    Log.showInfo(TAG, `sendKeyEvent keycode: ${keyCode} type: ${eventType}`);
    switch (keyCode) {
      case Constants.KEYCODE_BACK:
        Log.showInfo(TAG, `sendKeyEvent case back type: ${eventType}`);
        if (eventType === Constants.KEY_DOWN) {
          Log.showInfo(TAG, 'sendKeyEvent, if');
          this.sendBackKeyEventStart(); //down
        } else if (eventType === Constants.KEY_UP) {
          Log.showInfo(TAG, `sendKeyEvent, else type: ${eventType}`);
          this.sentEvnt();
          this.sendBackKeyEventEnd(); //up
        }
        break;
      case Constants.KEYCODE_HOME:
        Log.showInfo(TAG, `sendKeyEvent case home type: ${eventType}`);
        if (eventType === Constants.KEY_UP) {
          Log.showInfo(TAG, 'sendKeyEvent, if');
          this.sentEvnt();
          this.sendHomeKeyEvent();
        }
        break;
      case Constants.KEYCODE_RECENT:
        Log.showInfo(TAG, `sendKeyEvent case recent type: ${eventType}`);
        if (eventType === Constants.KEY_UP) {
          Log.showInfo(TAG, 'sendKeyEvent, if');
          this.sentEvnt();
          this.sendRecentKeyEvent();
        }
        break;
      default:
        Log.showInfo(TAG, `sendKeyEvent case default keycode: ${keyCode} type: ${eventType}`);
        break;
    }
  }

  private sendBackKeyEventStart() {
    Log.showInfo(TAG, 'sendBackKeyEventStart');

    let keyEvent = {
      isPressed: true,
      // back keycode
      keyCode: 2,
      // After consulting the multi-mode subsystem, this parameter proved meaningless and remained unchanged
      keyDownDuration: 1,
      // This parameter changes with the version, and is currently 10008
      isIntercepted: false
    }
    res = Input.injectEvent({
      KeyEvent: keyEvent
    });
    Log.showInfo(TAG, `injectEventHandler injectEventSync down res: ${res}`);
  }

  private sendBackKeyEventEnd() {
    Log.showInfo(TAG, 'sendBackKeyEventEnd');
    let keyEvent = {
      isPressed: false,
      // back keycode
      keyCode: 2,
      // After consulting the multi-mode subsystem, this parameter proved meaningless and remained unchanged
      keyDownDuration: 1,
      // This parameter changes with the version, and is currently 10008
      isIntercepted: false
    }
    res = Input.injectEvent({
      KeyEvent: keyEvent
    });
  }

  private sendHomeKeyEvent() {
    Log.showInfo(TAG, 'sendHomeKeyEvent');
    Log.showInfo(TAG, 'home click and start ability launcher');
    Log.showInfo(TAG, `startAbility`);
    AbilityManager.startAbility({
      bundleName: Constants.LAUNCHER_BUNDLE_NAME,
      abilityName: Constants.LAUNCHER_ABILITY_NAME
    });
  }

  private sendRecentKeyEvent() {
    Log.showInfo(TAG, 'sendRecentKeyEvent');
    commonEvent.publish('CREATE_RECENT_WINDOW_EVENT', (err, data) => {
      Log.showInfo(TAG, `publish launcher err ${JSON.stringify(err)}`);
      Log.showInfo(TAG, `publish launcher data ${JSON.stringify(data)}`);
    });

    Log.showInfo(TAG, `startAbility`);
    AbilityManager.startAbility({
      bundleName: Constants.RECENT_BUNDLE_NAME,
      abilityName: Constants.RECENT_ABILITY_NAME
    })
  }

  private sentEvnt() {
    let commonEventPublishData = {
      code: 1,
      data: JSON.stringify({
        callType: 1
      })
    }

    commonEvent.publish('SET_STATUSBAR_MIN_EVENT', commonEventPublishData, (err, data) => {
      Log.showInfo(TAG, `publish statusbar err ${JSON.stringify(err)}`);
      Log.showInfo(TAG, `publish statusbar data ${JSON.stringify(data)}`);
    });
  }
}

let keyCodeEvent = new KeyCodeEvent();

export default keyCodeEvent as KeyCodeEvent;
