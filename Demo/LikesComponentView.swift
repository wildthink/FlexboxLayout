//
//  LikesComponentView.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 30/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

class LikesComponentView: VolatileComponentView {

    /// The interanl state
    private var post: Post?  { return self.state as? Post }
    
    /// The configuration of this root node.
    /// - Note: Only the appearance and the node's style configuration should
    /// specified in here
    override func defaultConfiguration() {
        self.style.flexDirection = .Row
        self.style.alignItems = .Center
        self.style.justifyContent = .FlexStart
    }
    
    /// - Note: This method is left for the subclasses to implement
    override func constructComponent(state: ComponentStateType)  {
        
        var children = [UIView]()
        
        children.append(UILabel().configure({
            $0.text = "\(self.post!.likes) LIKES "
            $0.textAlignment = .Left
            $0.font = UIFont.systemFontOfSize(12, weight: UIFontWeightBold)
            $0.hidden = self.post!.likes <= 0
            $0.style.alignSelf = .Center
            $0.style.justifyContent = .FlexStart
            $0.style.margin.start = 16.0
        }))
        
        for _ in 0..<(self.post?.likes ?? 0) {
            children.append(UIView().configure({
                $0.backgroundColor = [UIColor.d, UIColor.b, UIColor.c, UIColor.f][randomInt(0, max: 3)]
                $0.layer.cornerRadius = 12.0
                $0.style.dimensions = (24, 24)
                $0.style.justifyContent = .Center
                $0.style.margin = (4.0, 0.0, 0, 0, 4.0, 0)
            }))
        }
        
        self.configure({
            $0.defaultConfiguration()
            $0.hidden = children.count == 0
            
        }, children:children)
    }
}
