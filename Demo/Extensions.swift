//
//  Extensions.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
}

extension UILabel {
    convenience init(color: UIColor, text: String) {
        self.init()
        self.backgroundColor = color
        self.text = text
        self.textColor = UIColor.whiteColor()
        self.numberOfLines = 0
    }
}