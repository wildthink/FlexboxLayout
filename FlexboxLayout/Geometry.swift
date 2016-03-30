//
//  Geometry.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 28/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(iOS)
    import UIKit
    public typealias EdgeInsets = UIEdgeInsets
#else
    import AppKit
    public typealias EdgeInsets = NSEdgeInsets
#endif

extension Node {
    
    ///Apply the layout to the given view hierarchy.
    public func apply(view: ViewType) {
        
        let x = layout.position.left.isNormal ? CGFloat(layout.position.left) : 0
        let y = layout.position.top.isNormal ? CGFloat(layout.position.top) : 0
        let w = layout.dimension.width.isNormal ? CGFloat(layout.dimension.width) : 0
        let h = layout.dimension.height.isNormal ? CGFloat(layout.dimension.height) : 0
        view.frame = CGRectIntegral(CGRect(x: x, y: y, width: w, height: h))
        
        if let children = self.children {
            for (s, node) in Zip2Sequence(view.subviews, children ?? [Node]()) {
                let subview = s as ViewType
                node.apply(subview)
            }
        }
    }
}

public extension CGSize {
    
    /// Undefined size
    public static let undefined = CGSize(width: CGFloat(Undefined), height: CGFloat(Undefined))
    
    /// Returns true is this value is less than .19209290E-07F
    var isZero: Bool {
        return self.width < CGFloat(FLT_EPSILON) && self.height < CGFloat(FLT_EPSILON)
    }
}

public extension Float {

    var isDefined: Bool {
        return self > 0 && self < 4096
    }
}

//MARK: Utils

func zeroIfNan(value: Float) -> CGFloat {
    return value.isDefined ? CGFloat(value) : 0
}

func zeroIfNan(value: CGFloat) -> CGFloat {
    return Float(value).isDefined ? value : 0
}

func maxIfNaN(value: Float) -> CGFloat {
    return value.isDefined ? CGFloat(value) : CGFloat(FLT_MAX)
}

func sizeZeroIfNan(size: Dimension) -> CGSize {
    return CGSize(width: CGFloat(zeroIfNan(size.0)), height: CGFloat(zeroIfNan(size.1)))
}

func sizeZeroIfNan(size: CGSize) -> CGSize {
    return CGSize(width: CGFloat(zeroIfNan(size.width)), height: CGFloat(zeroIfNan(size.height)))
}

func sizeMaxIfNan(size: Dimension) -> CGSize {
    return CGSize(width: CGFloat(maxIfNaN(size.0)), height: CGFloat(maxIfNaN(size.1)))
}

prefix operator ~ {}

public prefix func ~(number: CGFloat) -> Float {
    return Float(number)
}

public prefix func ~(size: CGSize) -> Dimension {
    return (width: ~size.width, height: ~size.height)
}

public prefix func ~(insets: EdgeInsets) -> Inset {
    return (left: ~insets.left, top: ~insets.top, right: ~insets.right, bottom: ~insets.bottom, start: ~insets.left, end: ~insets.right)
}

#if os(iOS)
    
    extension FlexboxView where Self: ViewType {
        
        /// Called before the configure block is called
        /// - Note: Subclasses to implement this method if required
        internal func preRender() {

        }
        
        /// Called before the layout is performed
        /// - Note: Subclasses to implement this method if required
        internal func postRender() {
            
            guard let scrollView = self as? UIScrollView else {
                return
            }
            
            var x: CGFloat = 0
            var y: CGFloat = 0
            
            for subview in scrollView.subviews {
                x = CGRectGetMaxX(subview.frame) > x ? CGRectGetMaxX(subview.frame) : x
                y = CGRectGetMaxY(subview.frame) > y ? CGRectGetMaxY(subview.frame) : y
            }
            
            scrollView.contentSize = CGSize(width: x, height: y)
            scrollView.scrollEnabled = true
        }
    }
    
#endif

