/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of the QtDataVisualization module.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
**
****************************************************************************/

import QtQuick 2.0
import HelperWidgets 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.1 as Controls

Column {
    anchors.left: parent.left
    anchors.right: parent.right

    Section {
        anchors.left: parent.left
        anchors.right: parent.right
        caption: qsTr("Surface3D")

        SectionLayout {
            Label {
                text: qsTr("renderingMode")
                toolTip: qsTr("Rendering Mode")
                Layout.fillWidth: true
            }
            SecondColumnLayout {
                ComboBox {
                    backendValue: backendValues.renderingMode
                    model: ["RenderIndirect", "RenderDirectToBackground",
                        "RenderDirectToBackground_NoClear"]
                    Layout.fillWidth: true
                    scope: "AbstractGraph3D"
                }
            }
            Label {
                text: qsTr("msaaSamples")
                toolTip: qsTr("MSAA Sample Count")
                Layout.fillWidth: true
            }
            SpinBox {
                suffix: " x MSAA"
                backendValue: backendValues.msaaSamples
                minimumValue: 0
                maximumValue: 16
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("shadowQuality")
                toolTip: qsTr("Shadow Quality")
                Layout.fillWidth: true
            }
            SecondColumnLayout {
                ComboBox {
                    backendValue: backendValues.shadowQuality
                    model: ["ShadowQualityNone", "ShadowQualityLow", "ShadowQualityMedium",
                        "ShadowQualityHigh", "ShadowQualitySoftLow", "ShadowQualitySoftMedium",
                        "ShadowQualitySoftHigh"]
                    Layout.fillWidth: true
                    scope: "AbstractGraph3D"
                }
            }
            Label {
                text: qsTr("selectionMode")
                toolTip: qsTr("Selection Mode")
                Layout.fillWidth: true
            }
            SecondColumnLayout {
                id: selectionLayout
                property bool isInModel: backendValue.isInModel;
                property bool isInSubState: backendValue.isInSubState;
                property bool selectionChangedFlag: selectionChanged
                property variant backendValue: backendValues.selectionMode
                property variant valueFromBackend: backendValue.value
                property string enumScope: "AbstractGraph3D"
                property string enumSeparator: " | "
                property int checkedCount: 0
                property bool selectionItem: false
                property bool selectionRow: false
                property bool selectionColumn: false
                property bool selectionSlice: false
                property bool selectionMulti: false

                function checkValue(checkedVariable, variableText, expressionBase) {
                    var expressionStr = expressionBase
                    if (checkedVariable) {
                        if (expressionStr !== "") {
                            expressionStr += enumSeparator
                        }
                        expressionStr += enumScope
                        expressionStr += "."
                        expressionStr += variableText
                        checkedCount++
                    }
                    return expressionStr
                }

                function composeSelectionMode() {
                    var expressionStr = ""
                    checkedCount = 0
                    expressionStr = checkValue(selectionItem, "SelectionItem", expressionStr)
                    expressionStr = checkValue(selectionRow, "SelectionRow", expressionStr)
                    expressionStr = checkValue(selectionColumn, "SelectionColumn", expressionStr)
                    expressionStr = checkValue(selectionSlice, "SelectionSlice", expressionStr)
                    expressionStr = checkValue(selectionMulti, "SelectionMultiSeries", expressionStr)

                    if (checkedCount === 0)
                        backendValue.expression = enumScope + ".SelectionNone"
                    else
                        backendValue.expression = expressionStr
                }

                function evaluate() {
                    if (backendValue.value === undefined)
                        return

                    selectionItem = (backendValue.expression.indexOf("SelectionItem") !== -1)
                    selectionRow = (backendValue.expression.indexOf("SelectionRow") !== -1)
                    selectionColumn = (backendValue.expression.indexOf("SelectionColumn") !== -1)
                    selectionSlice = (backendValue.expression.indexOf("SelectionSlice") !== -1)
                    selectionMulti = (backendValue.expression.indexOf("SelectionMultiSeries") !== -1)

                    selectionItemBox.checked = selectionItem
                    selectionRowBox.checked = selectionRow
                    selectionColumnBox.checked = selectionColumn
                    selectionSliceBox.checked = selectionSlice
                    selectionMultiSeriesBox.checked = selectionMulti
                }

                onSelectionChangedFlagChanged: evaluate()

                onIsInModelChanged: evaluate()

                onIsInSubStateChanged: evaluate()

                onBackendValueChanged: evaluate()

                onValueFromBackendChanged: evaluate()

                ColumnLayout {
                    anchors.fill: parent

                    Controls.CheckBox {
                        id: selectionItemBox
                        style: checkBox.style
                        text: "SelectionItem"
                        Layout.fillWidth: true
                        onClicked: {
                            selectionLayout.selectionItem = checked
                            selectionLayout.composeSelectionMode()
                        }
                    }
                    Controls.CheckBox {
                        id: selectionRowBox
                        style: checkBox.style
                        text: "SelectionRow"
                        Layout.fillWidth: true
                        onClicked: {
                            selectionLayout.selectionRow = checked
                            selectionLayout.composeSelectionMode()
                        }
                    }
                    Controls.CheckBox {
                        id: selectionColumnBox
                        style: checkBox.style
                        text: "SelectionColumn"
                        Layout.fillWidth: true
                        onClicked: {
                            selectionLayout.selectionColumn = checked
                            selectionLayout.composeSelectionMode()
                        }
                    }
                    Controls.CheckBox {
                        id: selectionSliceBox
                        style: checkBox.style
                        text: "SelectionSlice"
                        Layout.fillWidth: true
                        onClicked: {
                            selectionLayout.selectionSlice = checked
                            selectionLayout.composeSelectionMode()
                        }
                    }
                    Controls.CheckBox {
                        id: selectionMultiSeriesBox
                        style: checkBox.style
                        text: "SelectionMultiSeries"
                        Layout.fillWidth: true
                        onClicked: {
                            selectionLayout.selectionMulti = checked
                            selectionLayout.composeSelectionMode()
                        }
                    }
                }
            }
            Label {
                text: qsTr("measureFps")
                toolTip: qsTr("Measure Frames Per Second")
                Layout.fillWidth: true
            }
            SecondColumnLayout {
                CheckBox {
                    backendValue: backendValues.measureFps
                    Layout.fillWidth: true
                }
            }
            Label {
                text: qsTr("orthoProjection")
                toolTip: qsTr("Use Orthographic Projection")
                Layout.fillWidth: true
            }
            SecondColumnLayout {
                CheckBox {
                    backendValue: backendValues.orthoProjection
                    Layout.fillWidth: true
                }
            }

            // Kept for debugging
            Label { }
            SecondColumnLayout {
                TextEdit {
                    id: debugLabel
                    Layout.fillWidth: true
                    wrapMode: TextEdit.WordWrap
                    textFormat: TextEdit.RichText
                    width: 400
                    visible: false
                }
            }
            Controls.CheckBox {
                property color textColor: colorLogic.textColor
                id: checkBox
                style: CustomCheckBoxStyle {}
                visible: false
                ColorLogic {
                    id: colorLogic
                    backendValue: backendValues.selectionMode
                }
            }
        }
    }
}
