import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import Command 1.0

Rectangle {
    width: 400
    height: 400

    function checkIfUserCanBurn() {
        if (imageText.text.length == 0 || deviceCombo.currentIndex == 0)
            burnButton.enabled = false
        else
            burnButton.enabled = true
    }

    FileDialog {
        id: imageFileDialog
        folder: "./"
        nameFilters: [ "Image files (*.img)", "All files (*)" ]
        title: "Please choose an image file"
        selectFolder : false
        onAccepted: {
            var url = "" + imageFileDialog.fileUrl
            var fileName = url.split("/").pop()
            imageText.text = fileName
            imageText.visible = true
            checkIfUserCanBurn()
        }
        onRejected: {
            checkIfUserCanBurn()
        }
    }

    Command {
        id: volumes
        command:"ls /Volumes"
    }

    Command {
        id: burnapp
        command:"sleep 5"
        onOutputReady: {
            burnButton.visible = true
            burningText.visible = false
        }
    }

    Column {
        height: parent.height
        Rectangle {
            id: titleContainer
            width: 400
            height: 70
            color: "#ffe5d0"
            Image {
                 source: "kanotitle.png"
                 anchors.centerIn: titleContainer
            }
        }
        Rectangle {
            id: chooseImageContainer
            width: 400
            height: 100
            color: "#ffdabb"
            Column {
                anchors.centerIn: chooseImageContainer
                spacing: 10
                Button {
                    width: 130
                    height: 40
                    id: chooseImageButton
                    text: qsTr("Choose image")
                    onClicked: imageFileDialog.open();
                }

                Text {
                    id: imageText
                    font.bold: true
                    visible: false
                    text: ""
                    anchors.horizontalCenter: chooseImageButton.horizontalCenter
                }
            }
        }

        Rectangle {
            id: selectVolumeContainer
            width: 400
            height: 100
            color: "#ffc591"
            ComboBox {
                width: 200
                id: deviceCombo
                model: {
                    var devices = [qsTr("Select a volume...")];
                    var currentDevices = volumes.execute().split("\n");
                    devices.push.apply(devices, currentDevices);
                    devices.pop();
                    return devices
                }
                anchors.centerIn: selectVolumeContainer
                onCurrentIndexChanged: {
                    checkIfUserCanBurn()
                }
            }
        }

        Rectangle {
            id: burnContainer
            width: 400
            height: 100
            color: "#ffac5f"
            Column {
                anchors.centerIn: burnContainer
                Button {
                    width: 130
                    height: 40
                    id: burnButton
                    enabled: false
                    text: qsTr("Burn")
                    onClicked: {
                        burnButton.visible = false
                        burningText.visible = true
                        burnapp.executeAsync()
                    }
                }

                Text {
                    font.bold: true
                    color: "#FFFFFF"
                    id: burningText
                    visible: false
                    text: qsTr("Burning your Kano image, please wait..")
                }
            }
        }

        Rectangle {
            id: footerContainer
            width: 400
            height: 30
            color: "#ec9324"
            Text {
                color: "#FFFFFF"
                font.bold: true
                text: qsTr("Created by Kano Computing Ltd. | Kano.me")
                anchors.centerIn: footerContainer
            }
        }
    }
}
