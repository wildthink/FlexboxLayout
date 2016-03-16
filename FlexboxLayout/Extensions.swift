//
//  Helpers.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 16/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation

#if os(iOS)
    
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
    
    public static let ScreenSize: (Void) -> Dimension = {
        let screen = UIScreen.mainScreen()
        let size = screen.coordinateSpace.convertRect(screen.bounds, toCoordinateSpace: screen.fixedCoordinateSpace).size
        return (Float(size.width), Float(size.height))
    }
    
    public static let ViewSize: (UIView) -> Dimension = {
        let size = $0.bounds.size
        return (Float(size.width), Float(size.height))
    }
    
}

extension UILabel {
    
    ///  Computes the size of the label.
    ///- Note: The resulting size for a hidden label is zero.
    public override func beforeLayout() {
        
        // it simply calculates the required size for this label
        self.flexNode.measure = { (node, width, height) -> Dimension in
            if self.hidden { return (0,0) }
            let size = self.sizeThatFits(CGSize(width: CGFloat(width), height: CGFloat(height)))
            
            let w: Float = clamp(Float(size.width), lower: node.style.minDimensions.width, upper: min(width, node.style.maxDimensions.width))
            let h: Float = clamp(Float(size.height), lower: node.style.minDimensions.height, upper: min(height, node.style.maxDimensions.height))
            return (w, h)
        }
    }
}
    
#endif