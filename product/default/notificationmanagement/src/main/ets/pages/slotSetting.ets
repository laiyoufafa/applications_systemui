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

import Log from '../../../../../../../common/src/main/ets/default/log';
import HeadComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headcomponent';
import AppItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appitemcomponent';
import SwitchComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/switchcomponent';
import ConfigData from '../common/constants';
import NotificationConfigData from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants';
import Router from '@system.router'
import Notification from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/notificationlistener';
import {SlotLevel} from '@ohos.notification';

const TAG = 'NotificationManagement-SlotSetting';
const DEFAULT_SOUND = 'file://system/etc/Light.ogg';

let params;

@Entry
@Component
export default struct SlotSetting {
  private appInfo: any = null;
  private slotInfo: any = null;
  @State headName: Resource = $r('app.string.notificationManagement')
  @State allowNotice: Resource = $r('app.string.allowNotification')
  @State noticeStyleBanner: Resource = $r('app.string.notificationStyle_banner')
  @State noticeSound: Resource = $r('app.string.notificationSound')

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        GridContainer({
          columns: 12,
          sizeType: SizeType.Auto,
          gutter: vp2px(1) === 2 ? '12vp' : '0vp',
          margin: vp2px(1) === 2 ? '12vp' : '0vp'
        }) {
          Row() {
            Column() {
              HeadComponent({ headName: $headName, isActive: true });
              Row() {
                AppItemComponent({
                  appIcon: this.appInfo.appIcon,
                  appTitle: this.appInfo.appTitle,
                  appSummary: this.appInfo.appSummary,
                  appValue: this.slotInfo.type,
                  appArrow: this.appInfo.appArrow,
                  appArrowStyle: '',
                  appUri: this.appInfo.appUri,
                  appBundleName: this.appInfo.appBundleName,
                  appUid: this.appInfo.appUid,
                  appSwitch: 3,
                  isCanChange: !this.appInfo.systemApp
                });
              }
              .margin({ top: $r('app.float.page_notice_part_margin_t') })
              .padding({
                left: $r('sys.float.ohos_id_max_padding_start'),
                right: $r('sys.float.ohos_id_default_padding_end')
              })

              Row() {
                SwitchComponent({
                  title: $allowNotice,
                  initializationAction: () => this.notificationEnableInit(),
                  settingAction: (params) => this.notificationEnableSet(params),
                  register: (listener) => Notification.register({
                    bundle: this.appInfo.appBundleName,
                    onEnableChanged: listener
                  }),
                  isCanChange: false //TODO: There is no service, so it cannot be modified
                })
              }
              .margin({ top: $r('app.float.page_notice_title_margin_t') })
              .padding({
                left: $r('sys.float.ohos_id_card_margin_start'),
                right: $r('sys.float.ohos_id_card_margin_end')
              })
              .height($r('app.float.notice_row_height'))

              Row() {
                Text($r('app.string.notificationStyle'))
                  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                  .fontSize($r('sys.float.ohos_id_text_size_body2'))
                  .fontWeight(FontWeight.Bold)
                  .width(NotificationConfigData.WH_100_100)
                  .maxLines(NotificationConfigData.MAX_LINES_1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }.height($r('app.float.notice_title_height'))
              .padding({
                left: $r('sys.float.ohos_id_max_padding_start'),
                right: $r('sys.float.ohos_id_max_padding_end')
              })
              .margin({ top: $r('app.float.page_notice_part_margin_t')})
              .align(Alignment.Start);

              Row() {
                SwitchComponent({
                  title: $noticeStyleBanner,
                  initializationAction: () => this.bannerEnableInit(),
                  settingAction: (params) => this.bannerEnableSet(params)
                })
              }
              .padding({
                left: $r('sys.float.ohos_id_card_margin_start'),
                right: $r('sys.float.ohos_id_card_margin_end')
              })
              .margin({ top: $r('app.float.page_notice_title_margin_t')})
              .height($r('app.float.notice_row_height'))

              Row() {
                SwitchComponent({
                  title: $noticeSound,
                  initializationAction: () => this.soundEnableInit(),
                  settingAction: (params) => this.soundEnableSet(params)
                })
              }
              .padding({
                left: $r('sys.float.ohos_id_card_margin_start'),
                right: $r('sys.float.ohos_id_card_margin_end')
              })
              .margin({ top: $r('app.float.page_notice_row_margin_t') })
              .height($r('app.float.notice_row_height'))
            }
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .useSizeType({
              xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
              md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
            });
          }
          .width(ConfigData.WH_100_100)
          .height(ConfigData.WH_100_100);
        }
      }
      .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    params = Router.getParams();
    this.appInfo = params.appInfo;
    this.slotInfo = params.slotInfo
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }

  notificationEnableInit() {
    Log.showInfo(TAG, `notificationEnableInit`)
    return Notification.isNotificationEnabled({ bundle: this.appInfo.appBundleName, uid: this.appInfo.appUid })
  }

  notificationEnableSet(data) {
    Log.showInfo(TAG, `notificationEnableSet data:${JSON.stringify(data)}`)
    Notification.enableNotification({ bundle: this.appInfo.appBundleName, uid: this.appInfo.appUid }, data);
  }

  soundEnableInit() {
    Log.showInfo(TAG, `soundEnableInit`)
    return new Promise((resolve, reject) => {
      let result: boolean = false;
      if (!!this.slotInfo.sound) {
        result = true;
      }
      resolve(result);
      Log.showInfo(TAG, `soundEnableInit state:${result}`)
    });
  }

  soundEnableSet(params) {
    Log.showInfo(TAG, `soundEnableSet params:${JSON.stringify(params)}`)
    if (params == 0) {
      this.slotInfo.sound = '';
      this.slotInfo.level = SlotLevel.LEVEL_LOW
    } else if (params == 1) {
      this.slotInfo.sound = DEFAULT_SOUND;
      if (this.slotInfo.level < SlotLevel.LEVEL_DEFAULT) {
        this.slotInfo.level = SlotLevel.LEVEL_DEFAULT
      }
    }
    this.notificationSlotSet();
  }

  bannerEnableInit() {
    Log.showInfo(TAG, `bannerEnableInit`)
    return new Promise((resolve, reject) => {
      let result: boolean = false;
      if (this.slotInfo.level == SlotLevel.LEVEL_HIGH) {
        result = true;
      }
      Log.showInfo(TAG, `bannerEnableInit state:${result}`)
      resolve(result);
    });
  }

  bannerEnableSet(params) {
    Log.showInfo(TAG, `bannerEnableSet params:${JSON.stringify(params)}`)
    if (params == 0) {
      if (this.slotInfo.sound) {
        this.slotInfo.level = SlotLevel.LEVEL_DEFAULT;
      } else {
        this.slotInfo.level = SlotLevel.LEVEL_LOW;
      }
    } else if (params == 1) {
      this.slotInfo.level = SlotLevel.LEVEL_HIGH;
    }
    this.notificationSlotSet();
  }

  notificationSlotSet() {
    Log.showInfo(TAG, `notificationSlotSet slotInfo:${JSON.stringify(this.slotInfo)}`)
    Notification.notificationSlotSet({ bundle: this.appInfo.appBundleName, uid: this.appInfo.appUid }, this.slotInfo);
  }
}
