/**
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
import ConfigData from '../../common/constants';
import Log from '../../../../../../../../../common/src/main/ets/default/Log';

const TAG = 'ManagementComponent-SwitchComponent';

@Component
export default struct SwitchComponent {
  @Link title: string | Resource;
  @State describe: string | Resource = '';
  private initializationAction: (params?) => Promise<any>
  private settingAction: (params?) => void
  private register?: (listener) => void
  @State isCanChange: boolean = true
  @State initState: boolean= false

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        Column() {
          Text(this.title)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Bold)
            .align(Alignment.Start)
          Text(this.describe)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .align(Alignment.Start)
            .visibility((this.describe ? true : false) ? Visibility.Visible : Visibility.None)
        }.alignItems(HorizontalAlign.Start)
      }
      .flexShrink(0)
      .height($r('app.float.switchComp_height'))
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Start)
      .padding({ right: $r('app.float.switchComp_padding_r') })
      .margin({ left: $r('app.float.page_notice_info_label_margin') })

      Row() {
        Toggle({ type: ToggleType.Switch, isOn: this.initState })
          .align(Alignment.End)
          .width($r('app.float.toggle_comp_width'))
          .height($r('app.float.toggle_comp_height'))
          .enabled(this.isCanChange)
          .onChange((data) => {
            Log.showInfo(TAG, `Toggle onChange data:${data}`);
            this.initState = data ? true : false;
            this.settingAction(data);
          })
      }
      .alignItems(VerticalAlign.Center)
      .align(Alignment.End)
      .padding({ right: $r('app.float.switchComp_padding_r') })
    }.width(ConfigData.WH_100_100)
    .height($r('app.float.switchComp_height') )
    .border({ width: $r('app.float.border_width'), color: Color.White,
      radius: $r('app.float.border_radius') })
    .backgroundColor(Color.White)
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    if (this.register) {
      Log.showInfo(TAG, `aboutToAppear register listener`)
      this.register((stateValue: boolean) => {
        Log.showInfo(TAG, `aboutToAppear listener call`)
        this.initState = stateValue;
      });
    }
    this.initializationAction().then((data) => {
      Log.showInfo(TAG, `initializationAction:${data}`)
      this.initState = data;
    })
  }
}