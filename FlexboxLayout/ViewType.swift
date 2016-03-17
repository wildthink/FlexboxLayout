//
//  UIView+Flexbox.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias ViewType = UIView
    public typealias LabelType = UILabel
    public typealias EdgeInsets = UIEdgeInsets

#else
    import AppKit
    public typealias ViewType = NSView
    public typealias LabelType = NSTextView
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

public protocol FlexboxView { }

extension FlexboxView where Self: ViewType {
    
    /// Configure the view and its flexbox style.
    ///- Note: The configuration closure is stored away and called again in the render function
    public func configure(closure: ((Self, Style) -> Void), children: [ViewType]? = nil) -> Self {
        
        //runs the configuration closure and stores it away
        closure(self, self.flexNode.style)
        self.internalStore.configureClosure = { [weak self] in
            if let _self = self {
                closure(_self, _self.flexNode.style)
            }
        }
        
        //adds the children as subviews
        if let children = children {
            for child in children {
                self.addSubview(child)
            }
        }
        
        return self
    }
    
    /// Recursively apply the configuration closure to this view tree
    public func configure() {
        
        func configure(view: ViewType) {
            
            //runs the configure closure
            view.internalStore.configureClosure?()
            
            //calls it recursively on the subviews
            for subview in view.subviews {
                configure(subview)
            }
        }
        
        //the view is configured before the layout
        configure(self)
    }
    
    /// Re-configure the view and re-compute the flexbox layout
    public func render(boundingBox: CGSize) {
    
        let startTime = CFAbsoluteTimeGetCurrent()
    
        //configure the view tree
        self.configure()

        //runs the flexbox engine
        self.layout(boundingBox)
        
        let timeElapsed = (CFAbsoluteTimeGetCurrent() - startTime)*1000
        print(String(format: "▯ render (%2f) ms.", arguments: [timeElapsed]))
    }
}

extension ViewType: FlexboxView {
    
    ///Wether this view has or not a flexbox node associated
    public var hasFlexNode: Bool {
        return (objc_getAssociatedObject(self, &__flexNodeHandle) != nil)
    }

    /// Returns the associated node for this view.
    public var flexNode: Node {
        get {
            guard let node = objc_getAssociatedObject(self, &__flexNodeHandle) as? Node else {
                
                //lazily creates the node
                let newNode = Node()
                
                //default measure bloc
                newNode.measure = { (node, width, height) -> Dimension in
                    if self.hidden || self.alpha < CGFloat(FLT_EPSILON) {
                        return (0,0) //no size for an hidden element
                    }
                    
                    //get the intrinsic size of the element if applicable
                    var size = self.intrinsicContentSize()
                    
                    if size == CGSize.zero {
                        size = self.sizeThatFits(CGSize(width:CGFloat(width), height:CGFloat(height)))
                    }
                    
                    let width: Float = clamp(Float(size.width), lower: node.style.minDimensions.width, upper: width)
                    let height: Float = clamp(Float(size.height), lower: node.style.minDimensions.height, upper: height)
                    return (width, height)
                }
                
                objc_setAssociatedObject(self, &__flexNodeHandle, newNode, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newNode
            }
            
            return node
        }
        
        set {
            objc_setAssociatedObject(self, &__flexNodeHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    ///Left for subclasses to implement some specific logic prior to the layout
    public func beforeLayout() {
        ///implement this in your subview
    }
    
    /// Recursively computes the layout of this view
    public func layout(boundingBox: CGSize) {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        func prepare(view: ViewType) {
            view.beforeLayout()
            for subview in view.subviews.filter({ return $0.hasFlexNode }) {
                prepare(subview)
            }
        }

        prepare(self)
        
        func compute() {
            self.recursivelyAddChildren()
            self.flexNode.layout(Float(boundingBox.width), maxHeight: Float(boundingBox.height), parentDirection: .Inherit)
            self.flexNode.apply(self)
        }
        
        compute()
        
        let timeElapsed = (CFAbsoluteTimeGetCurrent() - startTime)*1000
        print(String(format: "▮ flexbox-layout (%2f) ms.", arguments: [timeElapsed]))
    }
    
    private func recursivelyAddChildren() {
        
        //adds the children at this level
        var children = [Node]()
        for subview in self.subviews.filter({ return $0.hasFlexNode }) {
            children.append(subview.flexNode)
        }
        self.flexNode.children = children
        
        //adds the childrens in the subiews
        for subview in self.subviews.filter({ return $0.hasFlexNode }) {
            subview.recursivelyAddChildren()
        }
    }
}

private var __flexNodeHandle: UInt8 = 0

 func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}

prefix operator ~ {}

public prefix func ~(number: CGFloat) -> Float {
    return Float(number)
}

public prefix func ~(size: CGSize) -> Dimension {
    return (width: Float(size.width), height: Float(size.height))
}

public prefix func ~(insets: EdgeInsets) -> Inset {
    return (left: Float(insets.left), top: Float(insets.top), right: Float(insets.right), bottom: Float(insets.bottom), start: Float(insets.left), end: Float(insets.right))
}


