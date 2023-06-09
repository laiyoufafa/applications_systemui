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

//import Window from '@ohos.window';
import Log from '../../../../../../../common/src/main/ets/default/log';
import HeadComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headcomponent';
import AppItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appitemcomponent';
import SwitchComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/switchcomponent';
import SlotLstComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/slotlstcomponent';
import ConfigData from '../common/constants';
import Router from '@system.router'
import Notification from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/notificationlistener';

const TAG = 'NotificationManagement-SetEnable';

let appInfo;

@Entry
@Component
export default struct SetEnable {
  private listeners: any[] = []
  @State headName:Resource = $r('app.string.notificationManagement')
  @State allowNotice:Resource = $r('app.string.allowNotification')
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        GridContainer({columns:12, sizeType: SizeType.Auto, gutter: vp2px(1) === 2 ? '12vp' : '0vp', margin: vp2px(1) === 2 ? '12vp' : '0vp'}) {
          Row() {
            Column() {
              HeadComponent({ headName: $headName, isActive: true });
              Row() {
                AppItemComponent({
                  appIcon: appInfo.appIcon,
                  appTitle: appInfo.appTitle,
                  appSummary: appInfo.appSummary,
                  appValue: '',
                  appArrow: appInfo.appArrow,
                  appArrowStyle: '',
                  appUri: appInfo.appUri,
                  appBundleName: appInfo.appBundleName,
                  appUid: appInfo.appUid,
                  appSwitch: 2
                });
              }
              .margin({ top: $r('app.float.page_notice_part_margin_t'), right: $r('app.float.page_margin_r') })
              .padding({ left: $r('sys.float.ohos_id_max_padding_start'), right: $r('sys.float.ohos_id_default_padding_end')})


              Row() {
                SwitchComponent({
                  title: $allowNotice,
                  initializationAction: () => this.switchComponentInit(),
                  settingAction: (params) => this.switchComponentSet(params),
                  register: (listener) => Notification.register({bundle:appInfo.appBundleName,onEnableChanged:listener}),
                  isCanChange: !appInfo.systemApp
                })
              }
              .margin({ top: $r('app.float.page_notice_title_margin_t')})
              .padding({ left: $r('sys.float.ohos_id_default_padding_start'), right: $r('sys.float.ohos_id_default_padding_end')})
              .height($r('app.float.notice_row_height'))

              Row() {
                SlotLstComponent({ appInfo: appInfo })
              }
              .align(Alignment.Start)
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
    appInfo = Router.getParams();
    appInfo.slotSettingUrl = 'pages/slotSetting'
    Notification.subscribeEnableChanged();
    Log.showInfo(TAG, `aboutToAppear end`)
  }

  aboutToDisappear(): void{
    Log.showInfo(TAG, `aboutToDisappear`)
    Notification.unsubscribeEnableChanged();
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }

  switchComponentInit() {
    Log.showInfo(TAG, `switchComponentInit`)
    return Notification.isNotificationEnabled({ bundle: appInfo.appBundleName, uid: appInfo.appUid })
  }

  switchComponentSet(params) {
    Log.showInfo(TAG, `switchComponentSet`)
    Notification.enableNotification({ bundle: appInfo.appBundleName, uid: appInfo.appUid }, params);
  }
}
