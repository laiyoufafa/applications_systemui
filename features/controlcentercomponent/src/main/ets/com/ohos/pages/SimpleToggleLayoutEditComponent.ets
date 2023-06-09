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
import Constants from '../common/Constants'
import StyleConfiguration from '../common/StyleConfiguration'
import SimpleToggleLayoutEditGrid from './SimpleToggleLayoutEditGrid'
import SimpleToggleLayoutEditDialogComponent from './SimpleToggleLayoutEditDialogComponent'

const TAG = 'Control-SimpleToggleLayoutEditComponent'
const TAG_SimpleToggleLayoutEditUpTitle = 'Control-SimpleToggleLayoutEditUpTitle'
const TAG_SimpleToggleLayoutEditOptMsg = 'Control-SimpleToggleLayoutEditOptMsg'

@Component
export default struct SimpleToggleLayoutEditComponent {
  private mDisplayingToggles: string[] = []
  private mHidingToggles: string[] = []
  private mDefaultDisplayToggles: string[] = []
  @Prop mColumnCount: number
  private simpleToggleLayoutEditEndCallback: () => void
  private onSaveDisplayingToggles: (toggles: string[]) => void
  @State mNewDisplayingToggles: string[] = []
  @State mNewHidingToggles: string[] = []
  @State style: any = StyleConfiguration.getSimpleToggleLayoutEditComponentStyle()
  @State mOptMsg: Resource = $r('app.string.control_center_simple_toggle_layout_edit_opt_desc')
  private mDisplayingTogglesMaxCount: number = Constants.SIMPLE_TOGGLE_LAYOUT_MAX_TOGGLE_COUNT
  private mDisplayingTogglesMinCount: number = Constants.SIMPLE_TOGGLE_LAYOUT_MIN_TOGGLE_COUNT
  private mHidingTogglesMaxCount: number = 0
  private mHidingTogglesMinCount: number = 0
  @State mCurrentDragToggleName: string = ''
  private titleDisplayInside: boolean = false
  private backDialogController: CustomDialogController = new CustomDialogController({
    builder: SimpleToggleLayoutEditDialogComponent({
      title: $r("app.string.control_center_simple_toggle_layout_edit_back_confirm"),
      leftButton: $r("app.string.control_center_simple_toggle_layout_edit_back_confirm_primary"),
      rightButton: $r("app.string.control_center_simple_toggle_layout_edit_back_confirm_secondary"),
      leftAction: () => this.callSimpleToggleLayoutEditEnd(),
      rightAction: () => this.onFinishBtnClick(null),
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 0 },
    customStyle: true
  });
  private resetDialogController: CustomDialogController = new CustomDialogController({
    builder: SimpleToggleLayoutEditDialogComponent({
      title: $r("app.string.control_center_simple_toggle_layout_edit_reset_confirm"),
      leftButton: $r("app.string.control_center_simple_toggle_layout_edit_reset_confirm_primary"),
      rightButton: $r("app.string.control_center_simple_toggle_layout_edit_reset_confirm_secondary"),
      leftAction: () => {
      },
      rightAction: () => this.editResetConfirm(),
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 0 },
    customStyle: true
  });

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
    this.mNewDisplayingToggles = [...this.mDisplayingToggles]
    this.mNewHidingToggles = [...this.mHidingToggles]
    let allTogglesCount = this.mNewDisplayingToggles.length + this.mNewHidingToggles.length
    this.mHidingTogglesMaxCount = allTogglesCount - this.mDisplayingTogglesMinCount
    if (this.mHidingTogglesMaxCount < 0) {
      this.mHidingTogglesMaxCount = 0
    }
    this.mHidingTogglesMinCount = allTogglesCount - this.mDisplayingTogglesMaxCount
    if (this.mHidingTogglesMinCount < 0) {
      this.mHidingTogglesMinCount = 0
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear ')
  }

  build() {
    Column() {
      Column()
        .width('100%')
        .height(this.style.marginTop)

      if (!this.titleDisplayInside) {
        Column() {
          SimpleToggleLayoutEditUpTitle({
            simpleToggleLayoutEditEndCallback: () => this.onSimpleToggleLayoutEditEnd()
          })
        }
        .width('100%')
        .height(this.style.titleHeight)

        Column()
          .width('100%')
          .height(this.style.titleMarginBottom)
      }

      Row() {
        Column().width(this.style.marginLeft).height(1).layoutWeight(0)
        Column() {
          if (this.titleDisplayInside) {
            Column() {
              SimpleToggleLayoutEditUpTitle({
                simpleToggleLayoutEditEndCallback: () => this.onSimpleToggleLayoutEditEnd()
              })
            }
            .width('100%')
            .height(this.style.titleHeight)
          }
          Column() {
            Column()
              .width('100%')
              .height(this.style.upGridMarginTop)

            Row() {
              Column().width(this.style.gridMarginLeft).height(1).layoutWeight(0)
              Column() {
                SimpleToggleLayoutEditGrid({
                  mToggles: $mNewDisplayingToggles,
                  mMaxCount: this.mDisplayingTogglesMaxCount,
                  mMinCount: this.mDisplayingTogglesMinCount,
                  mColumnCount: this.mColumnCount,
                  mGlobalDragToggleName: this.mCurrentDragToggleName,
                  gridTag: 'displaying',
                  onItemDragStart: (toggleName) => this.onDisplayingGridItemDragStart(toggleName),
                  onItemDrop: (status) => this.onDisplayingGridItemDrop(status)
                })
              }.layoutWeight(1)

              Column().width(this.style.gridMarginRight).height(1).layoutWeight(0)
            }.width('100%')

            Column()
              .width('100%')
              .height(this.style.upGridMarginBottom)
          }
          .width('100%')

          Column() {
            Column()
              .width('100%')
              .height(this.style.msgMarginTop)

            SimpleToggleLayoutEditOptMsg({
              mOptMsg: $mOptMsg
            })
            Column()
              .width('100%')
              .height(this.style.msgMarginBottom)

            Row() {
              Column().width(this.style.gridMarginLeft).height(1).layoutWeight(0)
              Column() {
                SimpleToggleLayoutEditGrid({
                  mToggles: $mNewHidingToggles,
                  mMaxCount: this.mHidingTogglesMaxCount,
                  mMinCount: this.mHidingTogglesMinCount,
                  mColumnCount: this.mColumnCount,
                  mGlobalDragToggleName: this.mCurrentDragToggleName,
                  gridTag: 'hiding',
                  onItemDragStart: (toggleName) => this.onHidingGridItemDragStart(toggleName),
                  onItemDrop: (status) => this.onHidingGridItemDrop(status)
                })
              }.layoutWeight(1)

              Column().width(this.style.gridMarginRight).height(1).layoutWeight(0)
            }.width('100%')

            Column()
              .width('100%')
              .height(this.style.btnMarginTop)

            Row() {
              Column().width(this.style.editBtnMarginLeft).height(1).layoutWeight(0)
              Grid() {
                GridItem() {
                  Button({ type: ButtonType.Capsule, stateEffect: true }) {
                    Text($r("app.string.control_center_simple_toggle_layout_edit_reset"))
                      .fontColor(this.style.editBtnFontColor)
                      .fontSize(this.style.editBtnFontSize)
                  }
                  .backgroundColor(this.style.editBtnBgColor)
                  .width('100%')
                  .height('100%')
                  .onClick(this.onResetBtnClick.bind(this))
                }

                GridItem() {
                  Button({ type: ButtonType.Capsule, stateEffect: true }) {
                    Text($r("app.string.control_center_simple_toggle_layout_edit_finish"))
                      .fontColor(this.style.editBtnFontColor)
                      .fontSize(this.style.editBtnFontSize)
                  }
                  .backgroundColor(this.style.editBtnBgColor)
                  .width('100%')
                  .height('100%')
                  .onClick(this.onFinishBtnClick.bind(this))
                }
              }
              .layoutWeight(1)
              .height(this.style.editBtnHeight)
              .columnsTemplate('1fr 1fr')
              .rowsTemplate('1fr')
              .columnsGap(this.style.editBtnSpace)

              Column().width(this.style.editBtnMarginRight).height(1).layoutWeight(0)
            }
            .width('100%')

            Column()
              .width('100%')
              .height(this.style.btnMarginBottom)
          }
          .width('100%')
          .backgroundColor(this.style.downAreaBgColor)

        }
        .layoutWeight(1)
        .borderRadius(this.style.borderRadius)
        .backgroundColor(this.style.upAreaBgColor)
        .clip(true)

        Column().width(this.style.marginRight).height(1).layoutWeight(0)
      }.width('100%')

    }
    .width('100%')
    .onTouch(this.onComponentTouch.bind(this))
  }

  onSimpleToggleLayoutEditEnd() {
    Log.showInfo(TAG, `onSimpleToggleLayoutEditEnd`)
    let changed = JSON.stringify(this.mDisplayingToggles) != JSON.stringify(this.mNewDisplayingToggles)
    Log.showInfo(TAG, `onSimpleToggleLayoutEditEnd, changed: ${changed}`)
    if (changed) {
      this.backDialogController.open()
    } else {
      this.callSimpleToggleLayoutEditEnd()
    }
  }

  callSimpleToggleLayoutEditEnd() {
    Log.showInfo(TAG, `callSimpleToggleLayoutEditEnd`)
    if (this.simpleToggleLayoutEditEndCallback) {
      this.simpleToggleLayoutEditEndCallback()
    }
  }

  onResetBtnClick(event: ClickEvent) {
    Log.showInfo(TAG, `onResetBtnClick`)
    let equalDefault = JSON.stringify(this.mDefaultDisplayToggles) == JSON.stringify(this.mNewDisplayingToggles)
    Log.showInfo(TAG, `onResetBtnClick, equalDefault: ${equalDefault}`)
    if (!equalDefault) {
      this.resetDialogController.open()
    }
  }

  editResetConfirm() {
    Log.showInfo(TAG, `editResetConfirm`)
    this.resetData()
    this.callSaveDisplayingToggles()
  }

  resetData(): void{
    Log.showInfo(TAG, `resetData`)
    let tempDisplayingToggles: string[] = [...this.mDefaultDisplayToggles]
    let tempHidingToggles: string[] = []
    this.mDisplayingToggles.forEach((toggleName) => {
      if (tempDisplayingToggles.indexOf(toggleName) < 0) {
        tempHidingToggles.push(toggleName)
      }
    })
    this.mHidingToggles.forEach((toggleName) => {
      if (tempDisplayingToggles.indexOf(toggleName) < 0) {
        tempHidingToggles.push(toggleName)
      }
    })
    this.mNewDisplayingToggles = tempDisplayingToggles
    this.mNewHidingToggles = tempHidingToggles
    this.mDisplayingToggles = [...tempDisplayingToggles]
    this.mHidingToggles = [...tempHidingToggles]
    Log.showInfo(TAG, `resetData, mNewDisplayingToggles: ${JSON.stringify(this.mNewDisplayingToggles)}`)
    Log.showInfo(TAG, `resetData, mNewHidingToggles: ${JSON.stringify(this.mNewHidingToggles)}`)
  }

  onFinishBtnClick(event: ClickEvent) {
    Log.showInfo(TAG, `onFinishBtnClick`)
    let changed = JSON.stringify(this.mDisplayingToggles) != JSON.stringify(this.mNewDisplayingToggles)
    Log.showInfo(TAG, `onFinishBtnClick, changed: ${changed}`)
    if (changed) {
      this.callSaveDisplayingToggles()
    }
    this.callSimpleToggleLayoutEditEnd()
  }

  callSaveDisplayingToggles(): void{
    Log.showInfo(TAG, `callSaveDisplayingToggles`)
    if (this.onSaveDisplayingToggles) {
      this.onSaveDisplayingToggles(this.mNewDisplayingToggles)
    }
  }

  async onDisplayingGridItemDragStart(toggleName: string): Promise<void> {
    Log.showInfo(TAG, `onDisplayingGridItemDragStart, toggleName: ${toggleName}`)
    this.mCurrentDragToggleName = toggleName
    this.setOptMsg(toggleName)
  }

  async onDisplayingGridItemDrop(status: string): Promise<void> {
    Log.showInfo(TAG, `onDisplayingGridItemDrop, status: ${status}`)
    this.setOptMsg(null)
  }

  async onHidingGridItemDragStart(toggleName: string): Promise<void> {
    Log.showInfo(TAG, `onHidingGridItemDragStart, toggleName: ${toggleName}`)
    this.mCurrentDragToggleName = toggleName
    this.setOptMsg(toggleName)
  }

  async onHidingGridItemDrop(status: string): Promise<void> {
    Log.showInfo(TAG, `onHidingGridItemDrop, status: ${status}`)
    this.setOptMsg(null)
  }

  setOptMsg(toggleName: string): void {
    Log.showInfo(TAG, `setOptMsg, toggleName: ${toggleName}`)
    if (!toggleName || toggleName.length == 0) {
      this.mOptMsg = $r('app.string.control_center_simple_toggle_layout_edit_opt_desc')
      return
    }
    if (this.mNewDisplayingToggles.indexOf(toggleName) >= 0) {
      if (this.mNewDisplayingToggles.length <= this.mDisplayingTogglesMinCount) {
        this.mOptMsg = $r('app.string.control_center_simple_toggle_layout_edit_opt_min', this.mDisplayingTogglesMinCount.toString())
      } else {
        this.mOptMsg = $r('app.string.control_center_simple_toggle_layout_edit_opt_drag')
      }
    } else if (this.mNewHidingToggles.indexOf(toggleName) >= 0) {
      if (this.mNewDisplayingToggles.length >= this.mDisplayingTogglesMaxCount) {
        this.mOptMsg = $r('app.string.control_center_simple_toggle_layout_edit_opt_max', this.mDisplayingTogglesMaxCount.toString())
      } else {
        this.mOptMsg = $r('app.string.control_center_simple_toggle_layout_edit_opt_drag')
      }
    }
  }

  onComponentTouch(event: TouchEvent) {
    Log.showInfo(TAG, `onComponentTouch`)
    event.stopPropagation()
  }
}

@Component
struct SimpleToggleLayoutEditUpTitle {
  private simpleToggleLayoutEditEndCallback: Function
  @State style: any = StyleConfiguration.getSimpleToggleLayoutEditUpTitleStyle()

  aboutToAppear() {
    Log.showInfo(TAG_SimpleToggleLayoutEditUpTitle, 'aboutToAppear')
  }

  aboutToDisappear() {
    Log.showInfo(TAG_SimpleToggleLayoutEditUpTitle, 'aboutToDisappear ')
  }

  build() {
    Row() {
      Row()
        .width(this.style.marginLeft)
        .height('100%')
      Image($r('app.media.ic_public_back'))
        .objectFit(ImageFit.Contain)
        .size({ width: this.style.imageWidth,
          height: this.style.imageHeight })
        .fillColor(this.style.fontColor)
        .onClick(this.backClick.bind(this))
      Row()
        .width(this.style.editTitleSpace)
        .height('100%')
      Text($r('app.string.control_center_simple_toggle_layout_edit'))
        .fontColor(this.style.fontColor)
        .fontSize(this.style.titleFontSize)
        .fontWeight(FontWeight.Bold)
    }.width('100%')
    .height('100%')
  }

  backClick(event: ClickEvent) {
    Log.showInfo(TAG_SimpleToggleLayoutEditUpTitle, `backClick, event: ${JSON.stringify(event)}`)
    this.simpleToggleLayoutEditEndCallback()
  }
}

@Component
struct SimpleToggleLayoutEditOptMsg {
  @Link mOptMsg: Resource
  @State style: any = StyleConfiguration.getSimpleToggleLayoutEditOptMsgStyle()

  aboutToAppear() {
    Log.showInfo(TAG_SimpleToggleLayoutEditOptMsg, 'aboutToAppear')
  }

  aboutToDisappear() {
    Log.showInfo(TAG_SimpleToggleLayoutEditOptMsg, 'aboutToDisappear ')
  }

  build() {
    Row() {
      Column().width(this.style.marginLeftRight).height(1).layoutWeight(0)
      Column() {
        Text(this.mOptMsg)
          .fontSize(this.style.fontSize)
          .fontColor(this.style.fontColor)
      }.layoutWeight(1)

      Column().width(this.style.marginLeftRight).height(1).layoutWeight(0)
    }
    .width('100%')
    .height(this.style.height)
  }
}