//
//  View+Identifiers.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 16/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation

/// Support structure for the view
internal class InternalViewStore {
    
    /// The identifier for this view in the tree
    var viewIdentifier: String?
    
    /// The traits for this view
    var traits: [String] = [String]()
    
    /// The configuration closure passed as argument
    var configureClosure: ((Void) -> (Void))?
}

extension ViewType {
    
    /// Internal store for this view
    internal var internalStore: InternalViewStore{
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
    
    /// A view can be marked with a string identifier, so that it can be retrieved afterwards
    public var identifier: String? {
        get { return self.internalStore.viewIdentifier }
        set { self.internalStore.viewIdentifier = newValue }
    }
    
    /// Simmetrically a view can be marked with traits
    public var traits: [String] {
        get { return self.internalStore.traits }
        set { self.internalStore.traits = newValue }
    }
    
    /// Recursively searches for the view with the given identifier
    public func findViewWithIdentifier(identifier: String) -> ViewType? {
        if self.identifier == identifier {
            return self
        }
        for subview in self.subviews {
            return subview.findViewWithIdentifier(identifier)
        }
        return nil
    }
    
    /// Recursively searches for the views that have the traits passed as arguments
    public func findViewsWithTraits(traits: [String]) -> [ViewType] {
        
        func find(view: ViewType, traits: [String], inout result: [ViewType]) {
            if arrayContainsArray(view.traits, lookFor: traits) {
                result.append(view)
            }
            for subview in subviews {
                find(subview, traits: traits, result: &result)
            }
        }
        
        var result = [ViewType]()
        find(self, traits: traits, result: &result)
        return result
    }
}

private func arrayContainsArray<S : SequenceType where S.Generator.Element : Equatable>(src:S, lookFor:S) -> Bool {
    for v:S.Generator.Element in lookFor{
        if src.contains(v) == false {
            return false
        }
    }
    return true
}

private var __internalStoreHandle: UInt8 = 0

