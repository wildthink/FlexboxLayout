//
//  ComponentView.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 29/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

#if os(iOS)
import UIKit
    
public protocol ComponentStateType { }

public class ComponentView: ViewType {
    
    /// The state of this component
    public var state: ComponentStateType?
    
    internal var stateClosure: (Void) -> ComponentStateType? = { return nil }
    
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

    public init(withState closure: (Void) -> ComponentStateType?) {
        super.init(frame: CGRect.zero)
        self.state(closure)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    /// Re-run the state closure and renders the component
    public func update(bounds: CGSize = CGSize.undefined) {
        self.updateState()
        self.render(bounds)
    }
    
    /// Update the state closure
    public func state(closure: (Void) -> ComponentStateType?) -> Self {
        self.stateClosure = closure
        self.updateState()
        
        guard let state = self.state else { return self }
        
        //not initialised yet
        if !self.hasFlexNode {
            self.constructComponent(state)
        }
        
        return self
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
    
    //MARK: Internal
    
    internal func updateState() {
        self.state = self.stateClosure()
    }
}
    

#endif
