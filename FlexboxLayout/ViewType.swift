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

//MARK: Layout

public protocol FlexboxView { }

extension FlexboxView where Self: ViewType {
    
    /// Configure the view and its flexbox style.
    ///- Note: The configuration closure is stored away and called again in the render function
    public func configure(closure: ((Self) -> Void), children: [ViewType]? = nil) -> Self {
        
        //runs the configuration closure and stores it away
        closure(self)
        self.internalStore.configureClosure = { [weak self] in
            if let _self = self {
                closure(_self)
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
    public func render(boundingBox: CGSize = CGSize.undefined) {
        
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
                    var size = self.sizeThatFits(CGSize(width: CGFloat(width), height: CGFloat(height)))
                    if size.isZero {
                        size = self.intrinsicContentSize()
                    }
                    
                    var w: Float = width
                    var h: Float = height
                    if node.style.minDimensions.width.isNormal || size.width > CGFloat(FLT_EPSILON) {
                        w = clamp(~size.width, lower: node.style.minDimensions.width, upper: min(width, node.style.maxDimensions.width))
                    }
                    
                    if node.style.minDimensions.height.isNormal || size.height > CGFloat(FLT_EPSILON) {
                        h = clamp(~size.height, lower: node.style.minDimensions.height, upper: min(height, node.style.maxDimensions.height))
                    }

                    return (w, h)
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
    
    /// The style for this flexbox node
    public var style: Style {
        return self.flexNode.style
    }
    
    /// Left for subclasses to implement some specific logic prior to the layout
    public func beforeLayout() {
        ///implement this in your subview
    }
    
    /// Recursively computes the layout of this view
    public func layout(boundingBox: CGSize = CGSize.undefined) {
        
        func prepare(view: ViewType) {
            view.beforeLayout()
            for subview in view.subviews.filter({ return $0.hasFlexNode }) {
                prepare(subview)
            }
        }
        
        prepare(self)
        
        func compute() {
            self.recursivelyAddChildren()
            self.flexNode.layout(~boundingBox.width, maxHeight: ~boundingBox.height, parentDirection: .Inherit)
            self.flexNode.apply(self)
        }
        
        compute()
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

//MARK: Internals

/// Support structure for the view
internal class InternalViewStore {
    
    /// The configuration closure passed as argument
    var configureClosure: ((Void) -> (Void))?
}

extension ViewType {
    
    /// Internal store for this view
    internal var internalStore: InternalViewStore {
        get {
            guard let store = objc_getAssociatedObject(self, &__internalStoreHandle) as? InternalViewStore else {
                
                //lazily creates the node
                let store = InternalViewStore()
                objc_setAssociatedObject(self, &__internalStoreHandle, store, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return store
            }
            return store
        }
    }
}

private var __internalStoreHandle: UInt8 = 0
private var __flexNodeHandle: UInt8 = 0

