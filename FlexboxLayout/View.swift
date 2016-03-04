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

#else
    import AppKit
    public typealias ViewType = NSView
    public typealias LabelType = NSTextView

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

var __flexNodeHandle: UInt8 = 0

extension ViewType {
    
    ///Wether this view has or not a flexbox node associated
    public var hasFlexNode: Bool {
        return (objc_getAssociatedObject(self, &__flexNodeHandle) != nil)
    }
    
    ///Returns the associated node for this view
    public var flexNode: Node {
        get {
            guard let node = objc_getAssociatedObject(self, &__flexNodeHandle) as? Node else {
                
                //lazily creates the node
                let newNode = Node()
                
                ///automatically returns the subview at the give index
                newNode.getChild = { (node, index) -> Node in
                    return self.subviews[index].flexNode
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
    
    ///Left for subclasses to implement some specific logic
    public func prepareForFlexboxLayout() {
        
    }
    
    ///Recursively computes the
    public func computeFlexboxLayout(boundingBox: CGSize) {
        
        func prepare(view: ViewType) {
            view.prepareForFlexboxLayout()
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
        
        compute() //1st pass
        compute() //2nd pass
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

#if os(iOS)

extension UILabel {
    
    public override func prepareForFlexboxLayout() {
        self.flexNode.measure = { (node, width, height) -> Dimension in
            let size = self.sizeThatFits(CGSize(width: CGFloat(width), height: CGFloat(height)))
            return (Float(size.width), Float(size.height))
        }
    }
}
    
    
#endif


