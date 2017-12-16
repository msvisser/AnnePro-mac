//
//  KeyboardController.swift
//  AnnePro
//
//  Created by Michiel Visser on 04/12/2017.
//  Copyright © 2017 Michiel Visser. MIT license, see LICENSE.
//

import Foundation

class KeyboardController: NSObject, BluetoothControllerDelegate {
    
    var bluetoothController: BluetoothController!
    var statusMenuController: StatusMenuController!
    
    var bluetoothName: String!
    var keyboardId: [UInt8] = []
    var lightingData: [UInt8] = []
    var layoutData: [UInt8] = []
    
    init(_ statusMenu: StatusMenuController) {
        super.init()
        self.statusMenuController = statusMenu
        self.bluetoothController = BluetoothController()
        self.bluetoothController.delegate = self
    }
    
    func setLightingMode(mode: UInt8) {
        print("Setting lighting mode:", mode)
        let data = Data(bytes: [9, 2, 1, mode])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func requestLightingMode() {
        print("Requesting normal lighting mode")
        let data = Data(bytes: [9, 1, 8])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func requestCustomLightingId() {
        print("Requesting custom lighting id")
        let data = Data(bytes: [9, 1, 10])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func setCustomLightingData(data: [UInt8]) {
        print("Setting custom lighting data")
        let prefix = Data(bytes: [9, 215, 3])
        
        if data.count != 214 {
            print("Incorrect lighting data!")
            return
        }

        let dataLen: UInt8 = UInt8(data.count)
        let maxLen: UInt8 = 14
        let numPackets: UInt8 = dataLen / maxLen + (dataLen % maxLen == 0 ? 0 : 1)
        var index: UInt8 = 0
        var packetIndex: UInt8 = 0
        
        while index < dataLen {
            let thisLen = min(maxLen, dataLen - index)
            let packetLen: UInt8 = thisLen + 2
            var currData: [UInt8] = []
            currData.append(contentsOf: prefix)
            currData.append(packetLen)
            currData.append(numPackets)
            currData.append(packetIndex)
            for _ in 0..<thisLen {
                currData.append(data[Int(index)])
                index += 1
            }
            while currData.count < maxLen + 2 {
                currData.append(0)
            }
            packetIndex += 1

            let d = Data(bytes: currData)
            self.bluetoothController.keyboardWriteMessage(d)
            usleep(40000)
        }
    }
    
    func requestCustomLightingData() {
        print("Requesting custom lighting data")
        let data = Data(bytes: [9, 1, 9])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func setLightingBrightness(brightness: UInt8) {
        print("Setting lighting brightness:", brightness)
        let data = Data(bytes: [9, 4, 2, 1, brightness, 0])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func setLayoutMode(mode: UInt8) {
        print("Setting layout mode:", mode)
        let data = Data(bytes: [7, 2, 3, mode])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func requestLayoutMode() {
        print("Requesting layout mode")
        let data = Data(bytes: [7, 1, 4])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func requestCustomLayoutData() {
        print("Requesting custom layout data")
        let data = Data(bytes: [7, 1, 5])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func setCustomLayoutData(data: [UInt8]) {
        print("Setting custom layout data")
        let prefix = Data(bytes: [7, 145, 2])
        
        if data.count != 144 {
            print("Incorrect layout data!")
            return
        }
        
        let dataLen: UInt8 = UInt8(data.count)
        let maxLen: UInt8 = 14
        let numPackets: UInt8 = dataLen / maxLen + (dataLen % maxLen == 0 ? 0 : 1)
        var index: UInt8 = 0
        var packetIndex: UInt8 = 0
        
        while index < dataLen {
            let thisLen = min(maxLen, dataLen - index)
            let packetLen: UInt8 = thisLen + 2
            var currData: [UInt8] = []
            currData.append(contentsOf: prefix)
            currData.append(packetLen)
            currData.append(numPackets)
            currData.append(packetIndex)
            for _ in 0..<thisLen {
                currData.append(data[Int(index)])
                index += 1
            }
            while currData.count < maxLen + 2 {
                currData.append(0)
            }
            packetIndex += 1
            
            let d = Data(bytes: currData)
            self.bluetoothController.keyboardWriteMessage(d)
            usleep(40000)
        }
    }
    
    func requestKeyboardId() {
        print("Requesting keyboard id")
        let data = Data(bytes: [2, 1, 1])
        self.bluetoothController.keyboardWriteMessage(data)
    }
    
    func updateStatus(status: BluetoothState) {
        let smc = self.statusMenuController!
        switch status {
        case .DISCONNECTED:
            smc.setInfoMessage("Not connected")
            smc.setControlsEnabled(false)
        case .SCANNING:
            smc.setInfoMessage("Scanning...")
            smc.setControlsEnabled(false)
        case .CONNECTING:
            self.bluetoothName = self.bluetoothController.peripheral.name!
            smc.setInfoMessage("Found: " + self.bluetoothName)
            smc.setControlsEnabled(false)
        case .CONNECTED:
            self.bluetoothName = self.bluetoothController.peripheral.name!
            smc.setInfoMessage("Waiting for sync: " + self.bluetoothName)
            smc.setControlsEnabled(false)
            self.requestKeyboardId()
        }
    }
    
    func receiveData(data: Data?) {
        if data != nil {
            let data = [UInt8](data!)
            print(data)
            
            // Sync data
            // [2, 15, 129, 10,  2,  0,  1,  2, 50, 55, 71,  1, 50, 48]
            // [2, 15, 129,  8,  2,  1, 54, 48, 52,  0, 54,  0, 50, 48]
            if data[0] == 2 {
                if data[2] == 129 {
                    let dataLen = data[3]
                    let numBlock = data[4]
                    let indexBlock = data[5]
                    
                    if indexBlock == 0 {
                        self.keyboardId = []
                    }
                    
                    for i in 0..<dataLen - 2 {
                        self.keyboardId.append(data[Int(i + 6)])
                    }
                    
                    if indexBlock == numBlock - 1 {
                        print(self.keyboardId)
                        self.statusMenuController.setInfoMessage("Connected: " + self.bluetoothName)
                        self.statusMenuController.setControlsEnabled(true)
                    }
                }
            }
            
            if data[0] == 7 {
                if data[2] == 130 {
                    if data[3] == 128 {
                        let layoutViewController = self.statusMenuController.layoutWindowController.window?.contentViewController as! LayoutViewController?
                        layoutViewController?.updateLayoutDataSet()
                    }
                } else if data[2] == 133 {
                    let dataLen = data[3]
                    let numBlock = data[4]
                    let indexBlock = data[5]
                    
                    if indexBlock == 0 {
                        self.layoutData = []
                    }
                    
                    for i in 0..<dataLen - 2 {
                        self.layoutData.append(data[Int(i + 6)])
                    }
                    
                    if indexBlock == numBlock - 1 {
                        self.layoutData.removeSubrange(0...3)
                        print(self.layoutData)
                        let layoutViewController = self.statusMenuController.layoutWindowController.window?.contentViewController as! LayoutViewController?
                        layoutViewController?.updateLayoutData(self.layoutData)
                    }
                }
            }
            
            if data[0] == 9 {
                if data[2] == 131 {
                    if data[3] == 128 {
                        let lightingViewController = self.statusMenuController.lightingWindowController.window?.contentViewController as! LightingViewController?
                        lightingViewController?.updateLightingDataSet()
                    }
                } else if data[2] == 137 {
                    let dataLen = data[3]
                    let numBlock = data[4]
                    let indexBlock = data[5]
                    
                    if indexBlock == 0 {
                        self.lightingData = []
                    }
                    
                    for i in 0..<dataLen - 2 {
                        self.lightingData.append(data[Int(i + 6)])
                    }
                    
                    if indexBlock == numBlock - 1 {
                        self.lightingData.removeSubrange(0...3)
                        print(self.lightingData)
                        let lightingViewController = self.statusMenuController.lightingWindowController.window?.contentViewController as! LightingViewController?
                        lightingViewController?.updateLightingData(self.lightingData)
                    }
                }
            }
        }
    }
    
}
