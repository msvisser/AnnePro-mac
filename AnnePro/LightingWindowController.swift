//
//  LightingWindowController.swift
//  AnnePro
//
//  Created by Michiel Visser on 05/12/2017.
//  Copyright © 2017 Michiel Visser. All rights reserved.
//

import Cocoa

class LightingWindowController: NSWindowController {

    convenience init() {
        self.init(windowNibName: NSNib.Name("LightingWindowController"))
        self.contentViewController = LightingViewController()
    }

}
