//
//  StatusMenuController.swift
//  AnnePro
//
//  Created by Michiel Visser on 04/12/2017.
//  Copyright © 2017 Michiel Visser. All rights reserved.
//

import Cocoa

class StatusMenuController: NSViewController {
    static var keyboardController: KeyboardController!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var statusMenu: NSMenu!
    
    var menuItemList: [NSMenuItem] = []
    var profileItemList: [NSMenuItem] = []
    
    var infoMenuItem: NSMenuItem!
    var testMenuItem: NSMenuItem!
    var bluetoothCacheMenuItem: NSMenuItem!
    
    var lightingMenuItem: NSMenuItem!
    var layoutMenuItem: NSMenuItem!
    
    var lightingWindowController: LightingWindowController!
    var layoutWindowController: LayoutWindowController!
    
    override func awakeFromNib() {
        StatusMenuController.keyboardController = KeyboardController(self)
        self.lightingWindowController = LightingWindowController()
        self.layoutWindowController = LayoutWindowController()
        
        self.statusMenu = NSMenu()
        self.statusMenu.autoenablesItems = false
        
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        
        self.statusItem.image = icon
        self.statusItem.menu = self.statusMenu
        
        self.infoMenuItem = NSMenuItem(title: "Not Connected", action: nil, keyEquivalent: "")
        self.infoMenuItem.isEnabled = false
        self.testMenuItem = NSMenuItem(title: "Send test", action: #selector(testClicked(_:)), keyEquivalent: "")
        self.testMenuItem.isHidden = true // Hide test button
        self.bluetoothCacheMenuItem = NSMenuItem(title: "Clean bluetooth cache", action: #selector(bluetoothClicked(_:)), keyEquivalent: "")
        
        setupLightingMenu()
        setupLayoutMenu()
        
        self.profileItemList = []
        
        updateStatusMenu(false)
    }
    
    @objc func bluetoothClicked(_ sender: NSMenuItem) {
        StatusMenuController.keyboardController.bluetoothController.cleanBluetoothCache()
    }
    
    func setupLightingMenu() {
        self.lightingMenuItem = NSMenuItem(title: "Lighting", action: nil, keyEquivalent: "")
        self.lightingMenuItem.submenu = NSMenu()
        
        let lsm = self.lightingMenuItem.submenu!
        lsm.addItem(ClosureMenuItem(title: "Custom lighting", action: { (_) in
            self.lightingWindowController.showWindow(self)
            NSApp.activate(ignoringOtherApps: true)
            self.lightingWindowController.window?.makeKeyAndOrderFront(self)
        }, keyEquivalent: ""))
        lsm.addItem(NSMenuItem.separator())
        lsm.addItem(ClosureMenuItem(title: "Brightness Low", action: { (_) in
            StatusMenuController.keyboardController.setLightingBrightness(brightness: 1)
        }, keyEquivalent: ""))
        lsm.addItem(ClosureMenuItem(title: "Brightness High", action: { (_) in
            StatusMenuController.keyboardController.setLightingBrightness(brightness: 10)
        }, keyEquivalent: ""))
        lsm.addItem(NSMenuItem.separator())
        
        let lightingOptions = [
            (128, "Custom"),
            (0, "Off"),
            (1, "Red"),
            (2, "Yellow"),
            (3, "Green"),
            (4, "Cyan"),
            (5, "Blue"),
            (6, "Purple"),
            (7, "Pink"),
            (8, "Orange"),
            (9, "White"),
            (13, "Breathing"),
            (14, "Rainbow"),
            (15, "Single light"),
            (16, "Single light (long)"),
            (17, "Poptang"),
            (18, "Colorful"),
            ]
        
        func lightClosure(_ index: UInt8) -> ((NSMenuItem) -> ()) {
            func realClosure(sender: NSMenuItem) {
                StatusMenuController.keyboardController.setLightingMode(mode: index)
            }
            return realClosure
        }
        
        var last_key = 127
        for (key, name) in lightingOptions {
            if key - 1 != last_key {
                lsm.addItem(NSMenuItem.separator())
            }
            lsm.addItem(ClosureMenuItem(title: name, action: lightClosure(UInt8(key)), keyEquivalent: ""))
            last_key = key
        }
    }
    
    func setupLayoutMenu() {
        self.layoutMenuItem = NSMenuItem(title: "Layout", action: nil, keyEquivalent: "")
        self.layoutMenuItem.submenu = NSMenu()
        
        let lsm = self.layoutMenuItem.submenu!
        lsm.addItem(ClosureMenuItem(title: "Custom layout", action: { (_) in
            self.layoutWindowController.showWindow(self)
            NSApp.activate(ignoringOtherApps: true)
            self.layoutWindowController.window?.makeKeyAndOrderFront(self)
        }, keyEquivalent: ""))
        lsm.addItem(NSMenuItem.separator())
        
        let layoutOptions = [
            (1, "Windows"),
            (2, "Windows (arrows)"),
            (3, "Mac"),
            (128, "Custom"),
        ]
        
        func layoutClosure(_ index: UInt8) -> ((NSMenuItem) -> ()) {
            func realClosure(sender: NSMenuItem) {
                StatusMenuController.keyboardController.setLayoutMode(mode: index)
            }
            return realClosure
        }
        
        for (key, name) in layoutOptions {
            self.layoutMenuItem.submenu!.addItem(ClosureMenuItem(title: name, action: layoutClosure(UInt8(key)), keyEquivalent: ""))
        }
    }
    
    func updateStatusMenu(_ enable: Bool) {
        self.menuItemList = [
            self.infoMenuItem,
            self.testMenuItem,
            NSMenuItem.separator(),
            self.lightingMenuItem,
            self.layoutMenuItem,
            NSMenuItem.separator(),
            self.bluetoothCacheMenuItem,
            NSMenuItem(title: "Quit Anne Pro Settings", action: #selector(quitClicked(_:)), keyEquivalent: ""),
        ]
        
        if self.profileItemList.count > 0 {
            let start = self.menuItemList.count - 3
            self.menuItemList.insert(NSMenuItem.separator(), at: start)
            for (i, profile) in self.profileItemList.enumerated() {
                profile.isEnabled = enable
                self.menuItemList.insert(profile, at: start + 1 + i)
            }
        }
        
        self.testMenuItem.isEnabled = enable
        self.lightingMenuItem.isEnabled = enable
        self.layoutMenuItem.isEnabled = enable
        
        self.statusMenu.removeAllItems()
        for item in self.menuItemList {
            item.target = self
            self.statusMenu.addItem(item)
        }
    }
    
    func setInfoMessage(_ str: String) {
        self.infoMenuItem.title = str
    }
    
    func setControlsEnabled(_ enable: Bool) {
        updateStatusMenu(enable)
        let light = self.lightingWindowController.window?.contentViewController as! LightingViewController?
        light?.setControlsEnabled(enable)
        let layout = self.layoutWindowController.window?.contentViewController as! LayoutViewController?
        layout?.setControlsEnabled(enable)
    }
    
    @objc func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.stop(self)
    }
    @objc func testClicked(_ sender: NSMenuItem) {
        let kbc = StatusMenuController.keyboardController!
//        kbc.setLightingMode(mode: 14)
//        kbc.setLightingBrightness(brightness: 1)
//        kbc.requestLayoutMode()
//        kbc.requestCustomLayoutData()
        kbc.requestCustomLightingId()
    }
    
}

class ClosureMenuItem: NSMenuItem {
    var actionClosure: (NSMenuItem) -> ()
    
    init(title string: String, action closure: @escaping (NSMenuItem) -> (), keyEquivalent charCode: String) {
        self.actionClosure = closure
        super.init(title: string, action: #selector(callClosure), keyEquivalent: charCode)
        self.target = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func callClosure() {
        self.actionClosure(self)
    }
    
}
