//
//  LayoutViewController.swift
//  AnnePro
//
//  Created by Michiel Visser on 07/12/2017.
//  Copyright © 2017 Michiel Visser. MIT license, see LICENSE.
//

import Cocoa

class LayoutViewController: NSViewController {
    
    let keymap = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
        [1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5],
        [1.75, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.25],
        [2.25, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.75],
        [1.25, 1.25, 1.25, 6.25, 1.25, 1.25, 1.25, 1.25]
    ]
    
    let default1: [UInt8] = [
        41, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 45, 46, 42, 43, 20, 26, 8, 21, 23, 28, 24, 12, 18, 19, 47, 48, 49, 57, 4, 22, 7, 9, 10, 11, 13, 14, 15, 51, 52, 0, 40, 225, 29, 27, 6, 25, 5, 17, 16, 54, 55, 56, 0, 0, 229, 224, 227, 226, 0, 0, 44, 0, 0, 0, 0, 230, 254, 250, 228, 53, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 0, 0, 0, 82, 0, 0, 0, 0, 0, 82, 71, 72, 74, 77, 70, 0, 80, 81, 79, 0, 0, 0, 80, 81, 79, 75, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 73, 76, 0, 0, 0, 0, 227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 254, 250, 0
    ]
    let default2: [UInt8] = [
        41, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 45, 46, 42, 43, 20, 26, 8, 21, 23, 28, 24, 12, 18, 19, 47, 48, 49, 57, 4, 22, 7, 9, 10, 11, 13, 14, 15, 51, 52, 0, 40, 225, 29, 27, 6, 25, 5, 17, 16, 54, 55, 82, 0, 0, 229, 224, 250, 226, 0, 0, 44, 0, 0, 0, 0, 80, 81, 79, 254, 53, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 0, 0, 0, 82, 0, 0, 0, 0, 0, 82, 71, 72, 74, 77, 70, 0, 80, 81, 79, 0, 0, 0, 80, 81, 79, 75, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 73, 56, 0, 0, 0, 0, 250, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 254
    ]
    let default3: [UInt8] = [
        41, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 45, 46, 42, 43, 20, 26, 8, 21, 23, 28, 24, 12, 18, 19, 47, 48, 49, 57, 4, 22, 7, 9, 10, 11, 13, 14, 15, 51, 52, 0, 40, 225, 29, 27, 6, 25, 5, 17, 16, 54, 55, 56, 0, 0, 229, 224, 226, 227, 0, 0, 44, 0, 0, 0, 0, 230, 254, 250, 228, 53, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 0, 0, 0, 82, 0, 0, 0, 0, 0, 82, 71, 72, 74, 77, 70, 0, 80, 81, 79, 0, 0, 0, 80, 81, 79, 75, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 73, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 254, 250, 0
    ]
    
    let keyNames = [
        "", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "][",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "][",
        "`~", "-_", "=+", "[{", "]}", "\\|", ";:", "'\"", ",<", ".>", "/?", "][",
        "Esc", "Tab", "Caps", "Space", "Enter", "Bkspc", "LSHIFT", "RSHIFT", "LCTRL", "RCTRL", "LWIN", "RWIN", "LALT", "RALT", "][",
        "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "][",
        "PrtSc", "ScrLk", "Pause", "Ins", "Del", "Home", "End", "PgDn", "PgUp", "Left", "Up", "Down", "Right", "][",
        "FN", "Anne", "VolUp", "VolDn", "Mute",
    ]
    let keyCodes: [UInt8] = [
        0, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 0, // A-Z
        39, 30, 31, 32, 33, 34, 35, 36, 37, 38, 0, // 0-9
        53, 45, 46, 47, 48, 49, 51, 52, 54, 55, 56, 0, // punctuation
        41, 43, 57, 44, 40, 42, 225, 229, 224, 228, 227, 231, 226, 230, 0, // modifiers
        58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 0, // f-keys
        70, 71, 72, 73, 76, 74, 77, 78, 75, 80, 82, 81, 79, 0, // special keys
        254, 250, 128, 129, 127, // fn+anne+media
    ]
    
    var normalKeys: [NSPopUpButton] = []
    var fnKeys: [NSPopUpButton] = []
    
    var downloadButton: NSButton!
    var uploadButton: NSButton!
    var default1Button: NSButton!
    var default2Button: NSButton!
    var default3Button: NSButton!
    
    var validating = false
    var uploadingData: [UInt8]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeys()
        setupButtons()
        fillMenus()
        
        for i in [18, 19, 20, 21, 46] {
            self.fnKeys[i].isEnabled = false
        }
    }
    
    func setControlsEnabled(_ enable: Bool) {
        self.downloadButton.isEnabled = enable
        self.uploadButton.isEnabled = enable
    }
    
    func updateLayoutDataSet() {
        self.validating = true
        usleep(100000)
        StatusMenuController.keyboardController.requestCustomLayoutData()
    }
    
    @objc func downloadClick() {
        StatusMenuController.keyboardController.requestCustomLayoutData()
    }
    
    @objc func uploadClick() {
        if !verifyLayout() {
            return
        }
        
        self.uploadButton.isEnabled = false
        self.downloadButton.isEnabled = false
        
        var layoutData: [UInt8] = []
        for _ in 0..<144 {
            layoutData.append(0)
        }
        
        var j = 0
        for i in 0..<70 {
            if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                layoutData[i + 4] = keyCodes[normalKeys[j].indexOfSelectedItem]
                layoutData[i + 74] = keyCodes[fnKeys[j].indexOfSelectedItem]
                j += 1
            }
        }
        
        let checksum = CRC16.calculateCRC16(layoutData, start: 4, length: 140)
        layoutData[3] = UInt8(checksum & 0xff);
        layoutData[2] = UInt8((checksum >> 8) & 0xff);
        
        self.uploadingData = layoutData
        StatusMenuController.keyboardController.setCustomLayoutData(data: layoutData)
    }
    
    @objc func setDefault1() {
        updateLayoutData(default1)
    }
    @objc func setDefault2() {
        updateLayoutData(default2)
    }
    @objc func setDefault3() {
        updateLayoutData(default3)
    }
    
    func verifyLayout() -> Bool {
        var normalFn = -1
        var normalAnne = -1
        var fnFn = -1
        var fnAnne = -1
        for j in 0..<61 {
            let normalKeycode = keyCodes[normalKeys[j].indexOfSelectedItem]
            if normalKeycode == 254 {
                if normalFn != -1 {
                    print("Duplicate fn key in normal layer")
                    return false
                }
                normalFn = j
            }
            if normalKeycode == 250 {
                if normalAnne != -1 {
                    print("Duplicate anne key in normal layer")
                    return false
                }
                normalAnne = j
            }
            let fnKeycode = keyCodes[fnKeys[j].indexOfSelectedItem]
            if fnKeycode == 254 {
                if fnFn != -1 {
                    print("Duplicate fn key in fn layer")
                    return false
                }
                fnFn = j
            }
            if fnKeycode == 250 {
                if fnAnne != -1{
                    return false
                }
                fnAnne = j
            }
        }
        
        if !(normalFn != -1 && normalAnne != -1 && fnFn != -1 && fnAnne != -1) {
            print("Missing fn/anne keys!")
            return false
        }
        if !(normalFn == fnFn && normalAnne == fnAnne) {
            print("FN/Anne keys are not aligned on both layers")
            return false
        }
        
        return true
    }
    
    @objc func selectionChanged() {
        var normalFn = -1
        var normalAnne = -1
        for j in 0...60 {
            let normalKeycode = keyCodes[normalKeys[j].indexOfSelectedItem]
            if normalKeycode == 254 {
                if normalFn != -1 {
                    normalKeys[j].selectItem(at: 0)
                } else {
                    normalFn = j
                }
            }
            if normalKeycode == 250 {
                if normalAnne != -1 {
                    normalKeys[j].selectItem(at: 0)
                } else {
                    normalAnne = j
                }
            }
        }
        
        for j in 0...60 {
            let fnKeycode = keyCodes[fnKeys[j].indexOfSelectedItem]
            if fnKeycode == 254 || fnKeycode == 250 {
                fnKeys[j].selectItem(at: 0)
            }
            fnKeys[j].isEnabled = true
        }
        
        if normalFn != -1 {
            fnKeys[normalFn].selectItem(withTag: 254)
            fnKeys[normalFn].isEnabled = false
        }
        if normalAnne != -1 {
            fnKeys[normalAnne].selectItem(withTag: 250)
            fnKeys[normalAnne].isEnabled = false
        }
        for i in [18, 19, 20, 21, 46] {
            self.fnKeys[i].isEnabled = false
        }
    }
    
    func updateLayoutData(_ data: [UInt8]) {
        if data.count != 140 {
            print("Incorrect update layout data len")
            return
        }
        
        if self.validating {
            var correct = true
            for i in 0..<70 {
                if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                    if data[i] != uploadingData[i+4] || data[i+70] != uploadingData[i+74] {
                        correct = false
                        break
                    }
                }
            }
            if correct {
                validating = false
                self.uploadButton.isEnabled = true
                self.downloadButton.isEnabled = true
            } else {
                usleep(500000)
                StatusMenuController.keyboardController.setCustomLayoutData(data: self.uploadingData)
            }
        } else {
            var j = 0
            for i in 0..<70 {
                if !(i == 40 || i == 53 || i == 54 || i == 59 || i == 60 || i == 62 || i == 63 || i == 64 || i == 65) {
                    normalKeys[j].selectItem(withTag: Int(data[i]))
                    fnKeys[j].selectItem(withTag: Int(data[i+70]))
                    j += 1
                }
            }
            selectionChanged()
        }
    }
    
    func setupButtons() {
        self.downloadButton = NSButton(frame: NSRect(x: 18, y: 164, width: 100, height: 26))
        self.downloadButton.title = "Download"
        self.downloadButton.bezelStyle = NSButton.BezelStyle.rounded
        self.downloadButton.cell?.controlTint = NSControlTint.blueControlTint
        self.downloadButton.action = #selector(downloadClick)
        self.view.addSubview(self.downloadButton)
        
        self.uploadButton = NSButton(frame: NSRect(x: 118, y: 164, width: 100, height: 26))
        self.uploadButton.title = "Upload"
        self.uploadButton.bezelStyle = NSButton.BezelStyle.rounded
        self.uploadButton.cell?.controlTint = NSControlTint.blueControlTint
        self.uploadButton.action = #selector(uploadClick)
        self.view.addSubview(self.uploadButton)
        
        self.default1Button = NSButton(frame: NSRect(x: 218, y: 164, width: 100, height: 26))
        self.default1Button.title = "Windows"
        self.default1Button.bezelStyle = NSButton.BezelStyle.rounded
        self.default1Button.cell?.controlTint = NSControlTint.blueControlTint
        self.default1Button.action = #selector(setDefault1)
        self.view.addSubview(self.default1Button)
        
        self.default2Button = NSButton(frame: NSRect(x: 318, y: 164, width: 100, height: 26))
        self.default2Button.title = "Arrows"
        self.default2Button.bezelStyle = NSButton.BezelStyle.rounded
        self.default2Button.cell?.controlTint = NSControlTint.blueControlTint
        self.default2Button.action = #selector(setDefault2)
        self.view.addSubview(self.default2Button)
        
        self.default3Button = NSButton(frame: NSRect(x: 418, y: 164, width: 100, height: 26))
        self.default3Button.title = "MAC"
        self.default3Button.bezelStyle = NSButton.BezelStyle.rounded
        self.default3Button.cell?.controlTint = NSControlTint.blueControlTint
        self.default3Button.action = #selector(setDefault3)
        self.view.addSubview(self.default3Button)
    }
    
    func setupKeys() {
        let keyWidth = 80.0
        let font = NSFont(name: "Courier", size: 13.0)
        
        var xpos = 18
        var ypos = 332
        
        for row in keymap {
            for key in row {
                let popup = NSPopUpButton(frame: NSRect(x: xpos, y: ypos, width: Int(keyWidth * key), height: 26))
                popup.font = font
                popup.alignment = NSTextAlignment.center
                popup.action = #selector(selectionChanged)
                self.normalKeys.append(popup)
                self.view.addSubview(popup)
                xpos += Int(keyWidth * key)
            }
            xpos = 18
            ypos -= 30
        }
        
        ypos = 134
        for row in keymap {
            for key in row {
                let popup = NSPopUpButton(frame: NSRect(x: xpos, y: ypos, width: Int(keyWidth * key), height: 26))
                popup.font = font
                popup.alignment = NSTextAlignment.center
                popup.action = #selector(selectionChanged)
                self.fnKeys.append(popup)
                self.view.addSubview(popup)
                xpos += Int(keyWidth * key)
            }
            xpos = 18
            ypos -= 30
        }
    }
    
    func fillMenus() {
        let menu = NSMenu()
        for (i, key) in keyNames.enumerated() {
            if key == "][" {
                menu.addItem(NSMenuItem.separator())
            } else {
                let item = NSMenuItem(title: key, action: nil, keyEquivalent: "")
                item.tag = Int(keyCodes[i])
                menu.addItem(item)
            }
        }
        
        for key in normalKeys {
            key.menu = menu.copy() as? NSMenu
        }
        for key in fnKeys {
            key.menu = menu.copy() as? NSMenu
        }
    }
    
}
