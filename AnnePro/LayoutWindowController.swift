//
//  LayoutWindowController.swift
//  AnnePro
//
//  Created by Michiel Visser on 07/12/2017.
//  Copyright © 2017 Michiel Visser. All rights reserved.
//

import Cocoa

class LayoutWindowController: NSWindowController {

    convenience init() {
        self.init(windowNibName: NSNib.Name("LayoutWindowController"))
        self.contentViewController = LayoutViewController()
    }
    
}
