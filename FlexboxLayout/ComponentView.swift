//
//  ComponentView.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 29/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
    
public protocol ComponentStateType { }

//MARK: - ComponentView
    
public class ComponentView: ViewType {
    
    /// The state of this component
    public var state: ComponentStateType? {
        didSet {
            self.didUpdateState()
        }
    }
    
    //MARK: Abstract
    
    /// The configuration of this root node.
    /// - Note: Only the appearance and the node's style configuration should
    /// specified in here
    public func defaultConfiguration() {
        
    }
    
    /// - Note: This method is left for the subclasses to implement
    public func constructComponent(state: ComponentStateType)  {
        
    }

    //MARK: State

    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Update the state closure
    private func didUpdateState() {
        
        guard let state = self.state else {
            return
        }
        
        //not initialised yet
        if !self.hasFlexNode {
            self.constructComponent(state)
        }
        
        return
    }
    
    //MARK: Layout
    
    /// Asks the view to calculate and return the size that best fits the specified size
    public override func sizeThatFits(size: CGSize) -> CGSize {
        self.render(size)
        return self.bounds.size ?? CGSize.undefined
    }
    
    /// Returns the natural size for the receiving view, considering only properties of the view itself.
    public override func intrinsicContentSize() -> CGSize {
        self.render(CGSize.undefined)
        return self.bounds.size ?? CGSize.undefined
    }
}
    
//MARK: - VolatileComponentView

public class VolatileComponentView: ComponentView {
    
}
    

