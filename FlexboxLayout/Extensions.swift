//
//  Extensions.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 30/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//


#if os(iOS)
    
    import UIKit
        
    extension FlexboxView where Self: ViewType {
        
        /// Called before the configure block is called
        /// - Note: Subclasses to implement this method if required
        internal func preRender() {
            
            // The volatile component view will recreate is subviews at every render call
            // Therefore the old subviews have to be removed
            if let volatileComponentView = self as? VolatileComponentView {
                volatileComponentView.preRender()
            }
        }
        
        /// Called before the layout is performed
        /// - Note: Subclasses to implement this method if required
        internal func postRender() {
            
            // content-size calculation for the scrollview should be applied after the layout
            if let scrollView = self as? UIScrollView {
                
                //failsafe
                if let _ = self as? UITableView { return }
                if let _ = self as? UICollectionView { return }
                
                scrollView.postRender()
            }
        }
    }

    extension UIScrollView {
        
        /// Calculates the new 'contentSize'
        func postRender() {
            
            var x: CGFloat = 0
            var y: CGFloat = 0
            
            for subview in self.subviews {
                x = CGRectGetMaxX(subview.frame) > x ? CGRectGetMaxX(subview.frame) : x
                y = CGRectGetMaxY(subview.frame) > y ? CGRectGetMaxY(subview.frame) : y
            }
            
            self.contentSize = CGSize(width: x, height: y)
            self.scrollEnabled = true
        }
    }
            
    private var __internalStoreHandle: UInt8 = 0
    private var __cacheHandle: UInt8 = 0

    extension UITableView {
        
        /// Refreshes the component at the given index path
        public func renderComponentAtIndexPath(indexPath: NSIndexPath) {
            self.beginUpdates()
            self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.endUpdates()
        }
        
        /// Re-renders all the compoents currently visible on screen.
        /// - Note: Call this method whenever the table view changes its bounds/size.
        public func renderVisibleComponents() {
            for cell in self.visibleCells {
                if let componentCell = cell as? ComponentCell {
                    componentCell.render(CGSize(self.bounds.width))
                }
            }
        }
        
        /// Internal store for this view
        /// - Note: It contains all the component prototypes used to calculate the height
        /// of the cells. 
        /// It is recommended to implement 'estimatedHeightForRowAtIndexPath' in your data-source in order to 
        /// improve the performance when loading the cells.
        private var prototypes: [String: ComponentView] {
            get {
                guard let store = objc_getAssociatedObject(self, &__internalStoreHandle) as? [String: ComponentView] else {
                    
                    //lazily creates the node
                    let store = [String: ComponentView]()
                    objc_setAssociatedObject(self, &__internalStoreHandle, store, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    return store
                }
                return store
            }
            set {
                objc_setAssociatedObject(self, &__internalStoreHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
            }
        }
        
        /// Register the component for the given identifier.
        /// - Note: This means that this instance will be used as prototype for calculating the height of the 
        /// cells with the same reuse identifier.
        public func registerPrototype(reuseIdentifier: String, component: ComponentView) {
            self.prototypes[reuseIdentifier] = component
        }
        
        /// Returns the height for the component with the given reused identifier
        ///- Note: Make sure the method 'registerPrototype' has been called before with the desired reuse identifier
        public func heightForCellWithState(reuseIdentifier: String, state: ComponentStateType) -> CGFloat {
            
            // no prototype
            guard let prototype = prototypes[reuseIdentifier] else { return 0 }
            
            //use the prototype to calculate the height
            prototype.state = state
            prototype.render(CGSize(width: self.bounds.size.width, height: CGFloat(Undefined)))
            var size = prototype.bounds.size
            size.height += prototype.frame.origin.y + CGFloat(prototype.style.margin.top) + CGFloat(prototype.style.margin.bottom)
            let height = size.height
            
            return height
        }
    }
    
    public class ComponentTableView: UITableView {
        
        /// Re-render the visible elements when the table view has changed its size
        override public func layoutSubviews() {
            super.layoutSubviews()
            self.renderVisibleComponents()
        }
        
    }

#endif