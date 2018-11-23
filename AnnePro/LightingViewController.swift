//
//  LightingViewController.swift
//  AnnePro
//
//  Created by Michiel Visser on 05/12/2017.
//  Copyright © 2017 Michiel Visser. MIT license, see LICENSE.
//

import Cocoa

class LightingViewController: NSViewController {

    @IBOutlet weak var multipleColorWell: NSColorWell!
    
    @IBOutlet weak var escKey: NSColorWell!
    @IBOutlet weak var oneKey: NSColorWell!
    @IBOutlet weak var twoKey: NSColorWell!
    @IBOutlet weak var threeKey: NSColorWell!
    @IBOutlet weak var fourKey: NSColorWell!
    @IBOutlet weak var fiveKey: NSColorWell!
    @IBOutlet weak var sixKey: NSColorWell!
    @IBOutlet weak var sevenKey: NSColorWell!
    @IBOutlet weak var eightKey: NSColorWell!
    @IBOutlet weak var nineKey: NSColorWell!
    @IBOutlet weak var zeroKey: NSColorWell!
    @IBOutlet weak var minusKey: NSColorWell!
    @IBOutlet weak var plusKey: NSColorWell!
    @IBOutlet weak var backspaceKey: NSColorWell!
    @IBOutlet weak var tabKey: NSColorWell!
    @IBOutlet weak var qKey: NSColorWell!
    @IBOutlet weak var wKey: NSColorWell!
    @IBOutlet weak var eKey: NSColorWell!
    @IBOutlet weak var rKey: NSColorWell!
    @IBOutlet weak var tKey: NSColorWell!
    @IBOutlet weak var yKey: NSColorWell!
    @IBOutlet weak var uKey: NSColorWell!
    @IBOutlet weak var iKey: NSColorWell!
    @IBOutlet weak var oKey: NSColorWell!
    @IBOutlet weak var pKey: NSColorWell!
    @IBOutlet weak var squareOpenKey: NSColorWell!
    @IBOutlet weak var squareCloseKey: NSColorWell!
    @IBOutlet weak var backslashKey: NSColorWell!
    @IBOutlet weak var capsKey: NSColorWell!
    @IBOutlet weak var aKey: NSColorWell!
    @IBOutlet weak var sKey: NSColorWell!
    @IBOutlet weak var dKey: NSColorWell!
    @IBOutlet weak var fKey: NSColorWell!
    @IBOutlet weak var gKey: NSColorWell!
    @IBOutlet weak var hKey: NSColorWell!
    @IBOutlet weak var jKey: NSColorWell!
    @IBOutlet weak var kKey: NSColorWell!
    @IBOutlet weak var lKey: NSColorWell!
    @IBOutlet weak var semicolonKey: NSColorWell!
    @IBOutlet weak var quoteKey: NSColorWell!
    @IBOutlet weak var enterKey: NSColorWell!
    @IBOutlet weak var lshiftKey: NSColorWell!
    @IBOutlet weak var zKey: NSColorWell!
    @IBOutlet weak var xKey: NSColorWell!
    @IBOutlet weak var cKey: NSColorWell!
    @IBOutlet weak var vKey: NSColorWell!
    @IBOutlet weak var bKey: NSColorWell!
    @IBOutlet weak var nKey: NSColorWell!
    @IBOutlet weak var mKey: NSColorWell!
    @IBOutlet weak var commaKey: NSColorWell!
    @IBOutlet weak var periodKey: NSColorWell!
    @IBOutlet weak var slashKey: NSColorWell!
    @IBOutlet weak var rshiftKey: NSColorWell!
    @IBOutlet weak var lctrlKey: NSColorWell!
    @IBOutlet weak var windowsKey: NSColorWell!
    @IBOutlet weak var laltKey: NSColorWell!
    @IBOutlet weak var spaceKey: NSColorWell!
    @IBOutlet weak var raltKey: NSColorWell!
    @IBOutlet weak var fnKey: NSColorWell!
    @IBOutlet weak var anneKey: NSColorWell!
    @IBOutlet weak var rctrlKey: NSColorWell!
    
    var allList: [NSColorWell]!
    var numberList: [NSColorWell]!
    var letterList: [NSColorWell]!
    var modList: [NSColorWell]!
    
    @IBOutlet weak var downloadButton: NSButton!
    @IBOutlet weak var uploadButton: NSButton!
    @IBOutlet weak var brightnessSlider: NSSlider!
    @IBOutlet weak var exportButton: NSButton!
    @IBOutlet weak var importButton: NSButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        allList = [
            escKey, oneKey, twoKey, threeKey, fourKey, fiveKey, sixKey, sevenKey, eightKey, nineKey, zeroKey, minusKey, plusKey, backspaceKey,
            tabKey, qKey, wKey, eKey, rKey, tKey, yKey, uKey, iKey, oKey, pKey, squareOpenKey, squareCloseKey, backslashKey,
            capsKey, aKey, sKey, dKey, fKey, gKey, hKey, jKey, kKey, lKey, semicolonKey, quoteKey, enterKey,
            lshiftKey, zKey, xKey, cKey, vKey, bKey, nKey, mKey, commaKey, periodKey, slashKey, rshiftKey,
            lctrlKey, windowsKey, laltKey, spaceKey, raltKey, fnKey, anneKey, rctrlKey
        ]
        numberList = [oneKey, twoKey, threeKey, fourKey, fiveKey, sixKey, sevenKey, eightKey, nineKey, zeroKey, minusKey, plusKey]
        letterList = [
            qKey, wKey, eKey, rKey, tKey, yKey, uKey, iKey, oKey, pKey,
            aKey, sKey, dKey, fKey, gKey, hKey, jKey, kKey, lKey,
            zKey, xKey, cKey, vKey, bKey, nKey, mKey,
            squareOpenKey, squareCloseKey, semicolonKey, quoteKey, commaKey, periodKey, slashKey
        ]
        modList = [
            escKey, backspaceKey, tabKey, backslashKey, capsKey, enterKey, lshiftKey, rshiftKey, lctrlKey, windowsKey, laltKey, spaceKey, raltKey, fnKey, anneKey, rctrlKey
        ]
    }
    
    override func viewWillDisappear() {
        NSColorPanel.shared.orderOut(nil)
        for well in allList {
            well.deactivate()
        }
    }
    
    func setControlsEnabled(_ enable: Bool) {
        self.downloadButton.isEnabled = enable
        self.uploadButton.isEnabled = enable
    }
    func updateLightingDataSet() {
        self.downloadButton.isEnabled = true
        self.uploadButton.isEnabled = true
    }
    func updateLightingData(_ data: [UInt8]) {
        if data.count != 210 {
            print("Incorrect update light data len")
            return
        }
        
        var j = 0
        for i in 0..<70 {
            if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                let r = CGFloat(data[i * 3 + 0]) / 255.0
                let g = CGFloat(data[i * 3 + 1]) / 255.0
                let b = CGFloat(data[i * 3 + 2]) / 255.0
                allList[j].color = NSColor(red: r, green: g, blue: b, alpha: 1.0)
                j += 1
            }
        }
        
        self.downloadButton.isEnabled = true
        self.uploadButton.isEnabled = true
    }
    
    @IBAction func allClicked(_ sender: NSButton) {
        let color = multipleColorWell.color
        for well in numberList {
            well.color = color
        }
        for well in letterList {
            well.color = color
        }
        for well in modList {
            well.color = color
        }
    }
    @IBAction func modifiersClicked(_ sender: NSButton) {
        let color = multipleColorWell.color
        for well in modList {
            well.color = color
        }
    }
    @IBAction func numbersClicked(_ sender: NSButton) {
        let color = multipleColorWell.color
        for well in numberList {
            well.color = color
        }
    }
    @IBAction func lettersClicked(_ sender: NSButton) {
        let color = multipleColorWell.color
        for well in letterList {
            well.color = color
        }
    }
    @IBAction func downloadClicked(_ sender: NSButton) {
        self.downloadButton.isEnabled = false
        self.uploadButton.isEnabled = false
        StatusMenuController.keyboardController.requestCustomLightingData()
    }
    @IBAction func uploadClicked(_ sender: NSButton) {
        self.downloadButton.isEnabled = false
        self.uploadButton.isEnabled = false
        
        var colorData: [UInt8] = []
        for _ in 0..<214 {
            colorData.append(0)
        }
        
        var j = 0
        for i in 0..<70 {
            if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                let c = allList[j].color
                colorData[(i * 3 + 0) + 4] = UInt8(c.redComponent * 255)
                colorData[(i * 3 + 1) + 4] = UInt8(c.greenComponent * 255)
                colorData[(i * 3 + 2) + 4] = UInt8(c.blueComponent * 255)
                j += 1
            } else {
                colorData[(i * 3 + 0) + 4] = 255
                colorData[(i * 3 + 1) + 4] = 255
                colorData[(i * 3 + 2) + 4] = 255
            }
        }
        
        let checksum = CRC16.calculateCRC16(colorData, start: 4, length: 210)
        colorData[3] = UInt8(checksum & 0xff);
        colorData[2] = UInt8((checksum >> 8) & 0xff);
        
        StatusMenuController.keyboardController.setCustomLightingData(data: colorData)
    }
    @IBAction func exportToJson(_ sender: NSButton) {
        guard let window = view.window else { return }
        
        //convert datalist to JSON
        var colorData: [UInt8] = []
        for _ in 0..<214 {
            colorData.append(0)
        }
        
        var j = 0
        for i in 0..<70 {
            if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                let c = allList[j].color
                colorData[(i * 3 + 0) + 4] = UInt8(c.redComponent * 255)
                colorData[(i * 3 + 1) + 4] = UInt8(c.greenComponent * 255)
                colorData[(i * 3 + 2) + 4] = UInt8(c.blueComponent * 255)
                j += 1
            } else {
                colorData[(i * 3 + 0) + 4] = 255
                colorData[(i * 3 + 1) + 4] = 255
                colorData[(i * 3 + 2) + 4] = 255
            }
        }
        
        let checksum = CRC16.calculateCRC16(colorData, start: 4, length: 210)
        colorData[3] = UInt8(checksum & 0xff);
        colorData[2] = UInt8((checksum >> 8) & 0xff);
        
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(colorData)
            
            print(data)
            
            //open save panel
            
            let panel = NSSavePanel()
            panel.nameFieldStringValue = "AnneProLEDs.json"
            panel.allowedFileTypes = ["json"]
            panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Documents")
            
            panel.beginSheetModal(for: window) { (result) in
                if result.rawValue == NSFileHandlingPanelOKButton,
                    let url = panel.url {
                    //encode and save file
                    do {
                        try data.write(to: url)
                    } catch {
                        self.showErrorDialogIn(window: window,
                                               title: "Unable to save file",
                                               message: error.localizedDescription)
                    }
                }
            }
        } catch {
            self.showErrorDialogIn(window: window,
                                   title: "Something unexpected happened",
                                   message: "Please, write an issue on GitHub at ")
        }
    }
    
    @IBAction func importFromJson(_ sender: Any) {
        //open file
        guard let window = view.window else { return }
        var selectedFile: URL = FileManager.default.homeDirectoryForCurrentUser
        
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false

        panel.beginSheetModal(for: window) { (result) in
            if result.rawValue == NSFileHandlingPanelOKButton {
                selectedFile = panel.urls[0]
                print(selectedFile)
                //read from file
                do{
                    //convert to list
                    let decoder = JSONDecoder()
                    let json = try Data(contentsOf: selectedFile)
                    let list = try decoder.decode([UInt8].self, from: json)
                    print(list)
                    //apply to view
                    var j = 0
                    for i in 0..<70 {
                        if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                            let c = NSColor(red: CGFloat(Double(list[(i * 3 + 0) + 4]) / 255.0), green: CGFloat(Double(list[(i * 3 + 1) + 4]) / 255.0), blue: CGFloat(Double(list[(i * 3 + 2) + 4]) / 255.0), alpha: 1.0)
                            self.allList[j].color = c
                            j += 1
                        }
                    }
                } catch {
                    self.showErrorDialogIn(window: window, title: "Unable to read file", message: error.localizedDescription)
                }
            }
        }
    }
    func showErrorDialogIn(window: NSWindow, title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
    @IBAction func brightnessChanged(_ sender: NSSlider) {
        let br = UInt8(min(max(1, self.brightnessSlider.integerValue), 10))
        StatusMenuController.keyboardController.setLightingBrightness(brightness: br)
    }
}
