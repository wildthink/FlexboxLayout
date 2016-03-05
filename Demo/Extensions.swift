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

extension UIColor {
    
    class public var a: UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    class public var b: UIColor {
        return UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1)
    }
    
    class public var c: UIColor {
        return UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
    }
    
    class public var d: UIColor {
        return UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
    }
    
    class public var e: UIColor {
        return UIColor(red: 46/255, green: 125/255, blue: 50/255, alpha: 1)
    }
    
    class public var f: UIColor {
        return UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
    }
    
    class public var g: UIColor {
        return UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
    }
}
