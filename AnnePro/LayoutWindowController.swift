//
//  LayoutWindowController.swift
//  AnnePro
//
//  Created by Michiel Visser on 07/12/2017.
//  Copyright © 2017 Michiel Visser. MIT license, see LICENSE.
//

import Cocoa

class LayoutWindowController: NSWindowController {

    convenience init() {
        self.init(windowNibName: NSNib.Name("LayoutWindowController"))
        self.contentViewController = LayoutViewController()
    }
    
}
