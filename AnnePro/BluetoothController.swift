//
//  BluetoothController.swift
//  AnnePro
//
//  Created by Michiel Visser on 04/12/2017.
//  Copyright © 2017 Michiel Visser. MIT license, see LICENSE.
//

//import Foundation
import CoreBluetooth
import IOBluetooth
import Cocoa

enum BluetoothState {
    case DISCONNECTED
    case SCANNING
    case CONNECTING
    case CONNECTED
}

protocol BluetoothControllerDelegate: class {
    func updateStatus(status: BluetoothState)
    func receiveData(data: Data?)
}

class BluetoothController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    
    weak var delegate: BluetoothControllerDelegate?
    
    let ANNE_PRO_SERVICE_UUID = CBUUID(string: "f000ffc0-0451-4000-b000-000000000000")
    let ANNE_PRO_READ_UUID = CBUUID(string: "f000ffc1-0451-4000-b000-000000000000")
    let ANNE_PRO_WRITE_UUID = CBUUID(string: "f000ffc2-0451-4000-b000-000000000000")
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    deinit {
        if self.peripheral != nil {
            self.centralManager.cancelPeripheralConnection(self.peripheral)
        }
    }
    
    func keyboardWriteMessage(_ data: Data) {
        if self.peripheral != nil && self.writeCharacteristic != nil {
            self.peripheral!.writeValue(data, for: self.writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    func cleanBluetoothCache() {
        IOBluetoothPreferenceSetControllerPowerState(0)
        
        let firstPath = NSString(string: "~/Library/Preferences/com.apple.Bluetooth.plist").expandingTildeInPath
        let secondPath = NSString(string: "~/Library/Preferences/ByHost").expandingTildeInPath
        let fileManager = FileManager.default
        
        do {
            if fileManager.fileExists(atPath: firstPath) {
                try fileManager.removeItem(atPath: firstPath)
                print("deleted:", firstPath)
            }
            
            let files = fileManager.enumerator(atPath: secondPath)
            while let file = files?.nextObject() {
                let strf = file as! String
                if strf.starts(with: "com.apple.Bluetooth.") {
                    let thirdPath = secondPath + "/" + strf
                    if fileManager.fileExists(atPath: thirdPath) {
                        try fileManager.removeItem(atPath: thirdPath)
                        print("deleted:", thirdPath)
                    }
                }
            }
        } catch {
            print("Unable to remove some files")
        }
            
        IOBluetoothPreferenceSetControllerPowerState(1)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth available!")
            delegate?.updateStatus(status: .SCANNING)
            print("Searching for a connected Anne Pro")
            let peripherals = self.centralManager.retrieveConnectedPeripherals(withServices: [ANNE_PRO_SERVICE_UUID])
            if (peripherals.count > 0) {
                let peripheral = peripherals[0];
                print("Found", peripherals.count, "matching peripherals", peripheral)
                self.centralManager.stopScan()
                
                self.peripheral = peripheral
                self.peripheral.delegate = self
                
                delegate?.updateStatus(status: .CONNECTING)
                self.centralManager.connect(peripheral, options: nil)
            } else {
                print("No paired peripherals found, scanning...")
                central.scanForPeripherals(withServices: nil, options: nil)
            }
        } else {
            print("Bluetooth not available.")
            delegate?.updateStatus(status: .DISCONNECTED)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
        if device != nil {
            print(device!)
        }
        if device?.contains("ANNE_KB") == true {
            print("Anne keyboard discovered!")
            self.centralManager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            delegate?.updateStatus(status: .CONNECTING)
            self.centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection failed!")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Keyboard connected!")
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Services discovered!")
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == ANNE_PRO_SERVICE_UUID {
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Characteristics discovered!")
        var read_characteristic: CBCharacteristic?
        var write_characteristic: CBCharacteristic?
        
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == ANNE_PRO_READ_UUID {
                read_characteristic = thisCharacteristic
            }
            if thisCharacteristic.uuid == ANNE_PRO_WRITE_UUID {
                write_characteristic = thisCharacteristic
            }
        }
        
        if read_characteristic != nil && write_characteristic != nil {
            peripheral.setNotifyValue(true, for: read_characteristic!)
            self.writeCharacteristic = write_characteristic!
            delegate?.updateStatus(status: .CONNECTED)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == ANNE_PRO_READ_UUID {
            delegate?.receiveData(data: characteristic.value)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnect peripheral!", error!.localizedDescription)
        if self.peripheral == peripheral && self.peripheral.state != .connected {
            self.peripheral = nil
            self.writeCharacteristic = nil
            delegate?.updateStatus(status: .SCANNING)
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
}
