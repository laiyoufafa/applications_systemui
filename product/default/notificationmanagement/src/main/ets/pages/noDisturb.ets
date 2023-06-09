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
import ConfigData from '../common/constants';
import Router from '@system.router'
import { concatTime } from '../../../../../../../common/src/main/ets/default/timemanager';
import ItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/itemcomponent';
import {DoNotDisturbType} from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants';
import NoDisturbingModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/nodisturbingmodel';
import ViewModel from '../vm/nodisturbviewmodel'

const TAG = 'NotificationManagement-NoDisturb';
const GROUP_REPEAT_MODE = 'repeatMode'

@Entry
@Component
export default struct NoDisturb {
  @State mViewModel: ViewModel = new ViewModel()
  @State headName:Resource =  $r('app.string.noDisturb')
  @State repeatTitle:Resource = $r('app.string.repeat')
  @State startDateTitle:Resource = $r('app.string.startDate')
  @State endDateTitle:Resource = $r('app.string.endDate')
  @State startTitle:Resource = $r('app.string.startTime')
  @State endTitle:Resource = $r('app.string.endTime')
  @State arrow: string | PixelMap | Resource = $r('app.media.ic_settings_arrow')
  @State mRefreshCnt: number = 0;
  mPrevData: string = '';

  startDateDialogController: CustomDialogController = new CustomDialogController({
    builder: DateDialog({
      action:(data)=> this.setStartDate(data),
      title: $r('app.string.startDate'),
      defaultDate: this.mViewModel.defaultStartTime
    }),
    cancel: ()=>this.mViewModel.onCancel(),
    autoCancel: false
  });
  startTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialog({
      action:(data)=> this.setStartTime(data),
      title: $r('app.string.startTime'),
      defaultDate: this.mViewModel.defaultStartTime
    }),
    cancel: ()=>this.mViewModel.onCancel(),
    autoCancel: false
  });
  endDateDialogController: CustomDialogController = new CustomDialogController({
    builder: DateDialog({
      action:(data)=> this.setEndDate(data),
      title: $r('app.string.endDate'),
      defaultDate: this.mViewModel.defaultEndTime
    }),
    cancel: ()=>this.mViewModel.onCancel(),
    autoCancel: false
  });
  endTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialog({
      action:(data)=> this.setEndTime(data),
      title: $r('app.string.endTime'),
      defaultDate: this.mViewModel.defaultEndTime
    }),
    cancel: ()=>this.mViewModel.onCancel(),
    autoCancel: false
  });
  repeatDialogController: CustomDialogController = new CustomDialogController({
    builder: RepeatModeDialog({
      action:(data)=> this.setRepeatMode(data),
      title: $r('app.string.repeat'),
      selectMode: this.mViewModel.repeatMode
    }),
    cancel: ()=>this.mViewModel.onCancel(),
    autoCancel: false
  });

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {
       GridContainer({columns:12, sizeType: SizeType.Auto, gutter: vp2px(1) === 2 ? '12vp' : '0vp', margin: vp2px(1) === 2 ? '12vp' : '0vp'}) {
            Row() {
              Column() {
                HeadComponent({ headName: $headName, isActive: true })
                if (this.mRefreshCnt > 0) {
                  Row() {
                    ItemComponent({
                      title: $repeatTitle,
                      value: this.mViewModel.repeatName,
                      arrow: $arrow
                    })
                  }.onClick(() => {
                    this.repeatDialogController.open()
                  }).margin({ bottom: $r('app.float.itemComp_margin_b') })

                  if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
                    List() {
                      ListItem() {
                        Row() {
                          ItemComponent({
                            title: $startDateTitle,
                            value: this.mViewModel.startDateClue,
                            arrow: $arrow
                          })
                        }.onClick(() => {
                          this.startDateDialogController.open()
                        })
                      }
                      ListItem() {
                        Row() {
                          ItemComponent({
                            title: $startTitle,
                            value: this.mViewModel.startTimeClue,
                            arrow: $arrow
                          })
                        }.onClick(() => {
                          this.startTimeDialogController.open()
                        })
                      }
                    }.divider({
                      strokeWidth: 1,
                      color: $r('app.color.divider_color'),
                      startMargin: $r('app.float.divider_margin_l'),
                      endMargin: $r('app.float.divider_margin_r')
                    }).width(ConfigData.WH_100_100)
                    .visibility(Visibility.Visible)
                    .zIndex(0)
                    .border({ width: $r('app.float.border_width'), color: Color.White,
                      radius: $r('app.float.border_radius') })
                    .backgroundColor(Color.White)
                    .margin({ bottom: $r('app.float.itemComp_margin_b')})
                    .flexShrink(1)
                    List() {
                      ListItem() {
                        Row() {
                          ItemComponent({
                            title: $endDateTitle,
                            value: this.mViewModel.endDateClue,
                            arrow: $arrow
                          })
                        }.onClick(() => {
                          this.endDateDialogController.open()
                        })
                      }
                      ListItem() {
                        Row() {
                          ItemComponent({
                            title: $endTitle,
                            value: this.mViewModel.endTimeClue,
                            arrow: $arrow
                          })
                        }.onClick(() => {
                          this.endTimeDialogController.open()
                        })
                      }
                    }.divider({
                      strokeWidth: 1,
                      color: $r('app.color.divider_color'),
                      startMargin: $r('app.float.divider_margin_l'),
                      endMargin: $r('app.float.divider_margin_r')
                    }).width(ConfigData.WH_100_100)
                    .visibility(Visibility.Visible)
                    .zIndex(0)
                    .border({ width: $r('app.float.border_width'), color: Color.White,
                      radius: $r('app.float.border_radius') })
                    .backgroundColor(Color.White)
                    .margin({ bottom: $r('app.float.itemComp_margin_b')})
                    .flexShrink(1)
                  } else {
                    Row() {
                      ItemComponent({
                        title: $startTitle,
                        value: this.mViewModel.startTimeClue,
                        arrow: $arrow
                      })
                    }.onClick(() => {
                      this.mPrevData = this.mViewModel.startTime
                      this.startTimeDialogController.open()
                    }).margin({ bottom: $r('app.float.itemComp_margin_b')})
                    Row() {
                      ItemComponent({
                        title: $endTitle,
                        value: this.mViewModel.endTimeClue,
                        arrow: $arrow
                      })
                    }.onClick(() => {
                      this.mPrevData = this.mViewModel.endTime
                      this.endTimeDialogController.open()
                    }).margin({ bottom: $r('app.float.itemComp_margin_b')})
                  }
                }
              }
              .width(ConfigData.WH_100_100)
              .height(ConfigData.WH_100_100)
              .padding({
                left: $r('sys.float.ohos_id_default_padding_start'),
                right: $r('sys.float.ohos_id_default_padding_end')
              })
              .useSizeType({
                xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
                md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
              })
            }
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
         }
      }
      .backgroundColor($r("sys.color.ohos_id_color_sub_background"))
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100);
    }
    .width(ConfigData.WH_100_100)
  }

  setRepeatMode(data: number) {
    this.mViewModel.onRepeatModeAccect(data);
    this.mRefreshCnt++;
  }
  setStartDate(data: string) {
    let dataSource = this.mViewModel.setDateIntoDateTime(this.mViewModel.defaultStartTime, data);
    this.mViewModel.onStartTimeAccept(dataSource);
    this.mRefreshCnt++;
  }
  setStartTime(data: string) {
    let dataSource = data;
    if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      dataSource = this.mViewModel.setTimeIntoDateTime(this.mViewModel.defaultStartTime, data);
    } else if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_NONE){
      dataSource = this.mPrevData;
    }
    this.mViewModel.onStartTimeAccept(dataSource);
    this.mRefreshCnt++;
  }
  setEndDate(data: string) {
    let dataSource = this.mViewModel.setDateIntoDateTime(this.mViewModel.defaultEndTime, data);
    this.mViewModel.onEndTimeAccept(dataSource);
    this.mRefreshCnt++;
  }
  setEndTime(data: string) {
    let dataSource = data;
    if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_CLEARLY) {
      dataSource = this.mViewModel.setTimeIntoDateTime(this.mViewModel.defaultEndTime, data);
    } else if (this.mViewModel.repeatMode == DoNotDisturbType.TYPE_NONE){
      dataSource = this.mPrevData;
    }
    this.mViewModel.onEndTimeAccept(dataSource);
    this.mRefreshCnt++;
  }


  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
    this.mRefreshCnt++;

  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }
}

/**
 * select date dialog
 */
@CustomDialog
struct DateDialog {
  public controller: CustomDialogController
  public action: (data) => void
  private selectedDate: string = ''
  private title: string | Resource = ''
  private defaultDate: Date = new Date()
  private minDate: Date = new Date('2008-01-01');
  private maxDate: Date = new Date('2037-12-31');

  build() {
    Column() {
      Column() {
        Text(this.title)
          .height($r('app.float.dialog_title_height'))
          .width(ConfigData.WH_100_100)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.dialog_title_font'))
          .fontWeight(FontWeight.Medium)
        DatePicker({ start: this.minDate, end: this.maxDate, selected: this.defaultDate })
          .onChange((date: DatePickerResult) => {
            let dateSource = new Date(date.year, date.month, date.day);
            this.selectedDate = NoDisturbingModel.formatDate(dateSource);
          })
          .width(ConfigData.WH_100_100)
          .height($r('app.float.timeDialog_datePicker_height'))
      }

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          this.controller.close();
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100);
        Divider()
          .vertical(true)
          .color($r('app.color.divider_color'))
          .strokeWidth(1)
          .height($r('app.float.divider_height'))
        Column() {
          Text($r('app.string.confirm'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          Log.showInfo(TAG, `confirm button of DateDialog on click`)
          this.controller.close();
          if(this.selectedDate != '') {
            this.action(this.selectedDate);
          }
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100)
      }
      .width(ConfigData.WH_100_100)
      .margin({top: $r("app.float.noDisturb_margin_16"), bottom: $r("app.float.noDisturb_margin_16")})
    }
    .height($r('app.float.timeDialog_height'))
    .width(ConfigData.WH_100_100)
  }
}

/**
 * select time dialog
 */
@CustomDialog
struct TimeDialog {
  public controller: CustomDialogController
  public action: (data) => void
  private selectedTime: string = ''
  private title: string | Resource = ''
  private defaultDate: Date = new Date()

  build() {
    Column() {
      Column() {
        Text(this.title)
          .height($r('app.float.dialog_title_height'))
          .width(ConfigData.WH_100_100)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.dialog_title_font'))
          .fontWeight(FontWeight.Medium)
        TimePicker({ selected: this.defaultDate, })
          .useMilitaryTime(false)
          .onChange((date: TimePickerResult) => {
            this.selectedTime = concatTime(date.hour, date.minute);
          })
          .width(ConfigData.WH_100_100)
          .height($r('app.float.timeDialog_datePicker_height'))
      }

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          this.controller.close();
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100);
        Divider()
          .vertical(true)
          .color($r('app.color.divider_color'))
          .strokeWidth(1)
          .height($r('app.float.divider_height'))
        Column() {
          Text($r('app.string.confirm'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          Log.showInfo(TAG, `confirm button of TimeDialog on click`)
          this.controller.close();
          if(this.selectedTime != '') {
            this.action(this.selectedTime);
          }
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100)
      }
      .width(ConfigData.WH_100_100)
      .margin({top: $r("app.float.noDisturb_margin_16"), bottom: $r("app.float.noDisturb_margin_16")})
    }
    .height($r('app.float.timeDialog_height'))
    .width(ConfigData.WH_100_100)
  }
}

/**
 * select repeat Mode dialog
 */
@CustomDialog
struct RepeatModeDialog {
  public controller: CustomDialogController
  public action: (data) => void
  private title: string | Resource = ''
  private prevModeSetCnt: number = 0
  @State selectMode: number = DoNotDisturbType.TYPE_NONE
  itSelectedBefore: number = -1
  build() {
    Column() {
      Column() {
        Text(this.title)
          .height($r('app.float.dialog_title_height'))
          .width(ConfigData.WH_100_100)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.dialog_title_font'))
          .fontWeight(FontWeight.Medium)
        Row() {
          Text($r('app.string.noDisturb_none'))
            .fontSize($r('app.float.repeatDialog_cont_font'))
            .fontColor(Color.Black)
            .width(ConfigData.WH_70_100)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
          Radio({ value: '' + DoNotDisturbType.TYPE_NONE, group: GROUP_REPEAT_MODE })
            .checked(this.selectMode == DoNotDisturbType.TYPE_NONE)
            .align(Alignment.End)
            .width($r('app.float.toggle_check_width'))
            .height($r('app.float.toggle_check_width'))
            .onClick(() => {
              if (this.prevModeSetCnt == 0) {
                this.itSelectedBefore = this.selectMode;
              }
              this.prevModeSetCnt++
              this.selectMode = DoNotDisturbType.TYPE_NONE;
            })
        }
        Row() {
          Text($r('app.string.noDisturb_once'))
            .fontSize($r('app.float.repeatDialog_cont_font'))
            .fontColor(Color.Black)
            .width(ConfigData.WH_70_100)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
          Radio({ value: '' + DoNotDisturbType.TYPE_ONCE, group: GROUP_REPEAT_MODE })
            .checked(this.selectMode == DoNotDisturbType.TYPE_ONCE)
            .align(Alignment.End)
            .width($r('app.float.toggle_check_width'))
            .height($r('app.float.toggle_check_width'))
            .onClick(() => {
              if (this.prevModeSetCnt == 0) {
                this.itSelectedBefore = this.selectMode;
              }
              this.prevModeSetCnt++
              this.selectMode = DoNotDisturbType.TYPE_ONCE;
            })
        }
        Row() {
          Text($r('app.string.noDisturb_daily'))
            .fontSize($r('app.float.repeatDialog_cont_font'))
            .fontColor(Color.Black)
            .width(ConfigData.WH_70_100)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
          Radio({ value: '' + DoNotDisturbType.TYPE_DAILY, group: GROUP_REPEAT_MODE })
            .checked(this.selectMode == DoNotDisturbType.TYPE_DAILY)
            .align(Alignment.End)
            .width($r('app.float.toggle_check_width'))
            .height($r('app.float.toggle_check_width'))
            .onClick(() => {
              if (this.prevModeSetCnt == 0) {
                this.itSelectedBefore = this.selectMode;
              }
              this.prevModeSetCnt++
              this.selectMode = DoNotDisturbType.TYPE_DAILY;
            })
        }
        Row() {
          Text($r('app.string.noDisturb_clearly'))
            .fontSize($r('app.float.repeatDialog_cont_font'))
            .fontColor(Color.Black)
            .width(ConfigData.WH_70_100)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
          Radio({ value: '' + DoNotDisturbType.TYPE_CLEARLY, group: GROUP_REPEAT_MODE })
            .checked(this.selectMode == DoNotDisturbType.TYPE_CLEARLY)
            .align(Alignment.End)
            .width($r('app.float.toggle_check_width'))
            .height($r('app.float.toggle_check_width'))
            .onClick(() => {
              if (this.prevModeSetCnt == 0) {
                this.itSelectedBefore = this.selectMode;
              }
              this.prevModeSetCnt++
              this.selectMode = DoNotDisturbType.TYPE_CLEARLY;
            })
        }
      }

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor($r("app.color.font_color_007DFF"))

        }.onClick(() => {
          this.controller.close();
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100);
        Divider()
          .vertical(true)
          .color($r('app.color.divider_color'))
          .strokeWidth(1)
          .height($r('app.float.divider_height'))
        Column() {
          Text($r('app.string.confirm'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor($r("app.color.font_color_007DFF"))

        }.onClick(() => {
          Log.showInfo(TAG, `confirm button of TimeDialog on click`)
          this.controller.close();
          if (this.itSelectedBefore != -1 && this.itSelectedBefore != this.selectMode){
            this.action(this.selectMode);
          }
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100)
      }
      .width(ConfigData.WH_100_100)
      .margin({top: $r("app.float.noDisturb_margin_16"), bottom: $r("app.float.noDisturb_margin_16")})
    }
    .height($r('app.float.repeatDialog_height'))
    .width(ConfigData.WH_100_100)
  }
}
