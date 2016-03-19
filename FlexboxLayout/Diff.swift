//
//  Diff.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 18/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation

extension ViewType {
    
    public func applyTreeDiff(source: ViewType?, diff: ViewType?) -> ViewType? {
        _applyTreeDiff(source, diff: diff)
        return _applyTreeDiff(source, diff: diff)
    }
    
    private func _applyTreeDiff(source: ViewType?, diff: ViewType?) -> ViewType? {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        func _diff(parent: ViewType, source: ViewType?, diff: ViewType?) -> ViewType? {
            
            guard let diff = diff else {
                source?.removeFromSuperview()
                return nil
            }
            guard let source = source else {
                parent.addSubview(diff)
                return diff
            }
            
            if !siblings(source, object2: diff) {
                let parent = source.superview
                source.removeFromSuperview()
                parent?.addSubview(diff)
                
            } else {
                
                let count = max(source.subviews.count, diff.subviews.count)
                for var i = 0; i < count; i++ {
                    _diff(source, source: i < source.subviews.count ? source.subviews[i] : nil, diff: i < diff.subviews.count ? diff.subviews[i] : nil)
                }
            }
            
            return source
        }
        
        let view = _diff(self, source: source, diff: diff)
        
        let timeElapsed = (CFAbsoluteTimeGetCurrent() - startTime)*1000
        print(String(format: "▮ diff (%2f) ms.", arguments: [timeElapsed]))
        
        return view
    }    
}

private func siblings(object1: AnyObject!, object2: AnyObject!) -> Bool {
    return object_getClassName(object1) == object_getClassName(object2)
}