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

    //MARK: - ComponentView
    
    public class ComponentView: ViewType {
        
        /// The state of this component
        public var state: ComponentStateType? {
            didSet {
                self._updateState()
            }
        }
        
        /// The configuration of this root node.
        /// - Note: Only the appearance and the node's style configuration should
        /// specified in here
        public func defaultConfiguration() {
            
        }
        
        /// - Note: This method is left for the subclasses to implement
        public func constructComponent(state: ComponentStateType)  {
            
        }

        public init() {
            super.init(frame: CGRect.zero)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        /// Update the state closure
        private func _updateState() {
            guard let state = self.state else {
                return
            }
            
            //not initialised yet
            if !self.hasFlexNode {
                self.constructComponent(state)
            }
            
            return
        }
        
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
        

    public class VolatileComponentView: ComponentView {
        
        /// The volatile component view will recreate is subviews at every render call
        /// Therefore the old subviews have to be removed
        func __preRender() {
            //TODO
        }
    }


    public class ComponentCell: UITableViewCell {
        
        /// The internal component
        public let component: ComponentView
        
        /// The state of this component
        public var state: ComponentStateType? {
            didSet {
                self.component.state = state
            }
        }
        
        /// Initialise a new cell with the given component
        public init(reuseIdentifier: String, component: ComponentView) {
            self.component = component
            super.init(style: .Default, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(self.component)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Specialisation of 'render'
        internal func renderComponent(size: CGSize? = nil) {
            let s = size ?? self.superview?.bounds.size ?? CGSize.undefined
            self.component._updateState()
            self.component.render(s)
        }
        
    }

#endif


