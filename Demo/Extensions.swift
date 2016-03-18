//
//  Extensions.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

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

func randomString(length: Int) -> String {
    
    let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
    let allowedCharsCount = UInt32(allowedChars.characters.count)
    var randomString = ""
    
    for _ in (0..<length) {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
        randomString += String(newCharacter)
    }
    
    return randomString
}

public struct DeviceScreen {
    
    public static let HorizontalSizeClass: (Void) -> (UIUserInterfaceSizeClass) = {
        return UIScreen.mainScreen().traitCollection.horizontalSizeClass
    }
    
    public static let VerticalSizeClass: (Void) -> (UIUserInterfaceSizeClass) = {
        return UIScreen.mainScreen().traitCollection.verticalSizeClass
    }
    
    public static let LayoutDirection: (Void) -> (UIUserInterfaceLayoutDirection) = {
        return UIApplication.sharedApplication().userInterfaceLayoutDirection
    }
    
    public static let Idiom: (Void) -> (UIUserInterfaceIdiom) = {
        return UIDevice.currentDevice().userInterfaceIdiom
    }
    
    public static let ScreenSize: (Void) -> FlexboxLayout.Dimension = {
        let screen = UIScreen.mainScreen()
        let size = screen.coordinateSpace.convertRect(screen.bounds, toCoordinateSpace: screen.fixedCoordinateSpace).size
        return (Float(size.width), Float(size.height))
    }
    
    public static let ViewSize: (UIView) -> FlexboxLayout.Dimension = {
        let size = $0.bounds.size
        return (Float(size.width), Float(size.height))
    }
    
}