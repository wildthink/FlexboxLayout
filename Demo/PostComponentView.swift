//
//  PostComponentView.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 30/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation
import UIKit
import FlexboxLayout

/// An example model used as state for the component
struct Post: ComponentStateType {
    
    let title, text, time: String

    // generates a new random post
    init() {
        self.title = "TITLE"
        self.text = randomString(randomInt(20, max: 200))
        self.time = "88:88"
    }
}

@objc protocol PostComponentDelegate: class {
    
    /// The 'GO' button is being pressed in the component
    func postComponentDidPressButton(sender: UIButton)
}

class PostComponentView: ComponentView {
    
    /// The associated component delegate
    weak var delegate: PostComponentDelegate?
    
    /// The interanl state
    private var post: Post?  { return self.state as? Post }
    
    /// The configuration of this root node.
    /// - Note: Only the appearance and the node's style configuration should
    /// specified in here
    override func defaultConfiguration() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.b.CGColor
        self.layer.borderWidth = 2.0
        self.style.justifyContent = .Center
        self.style.alignSelf = .Stretch
        self.style.flexDirection = .Row
        self.style.margin = (0.0, 8.0, 0.0, 8.0, 0.0, 0.0)
        self.style.maxDimensions.width = 320
    }
    
    /// - Note: This method is left for the subclasses to implement
    override func constructComponent(state: ComponentStateType)  {
        
        self.configure({ _ in
            self.defaultConfiguration()
            
            }, children: [
                
                UIView().configure({
                    $0.backgroundColor = UIColor.g
                    $0.layer.cornerRadius = 27.0
                    $0.style.dimensions = (54, 54)
                    $0.style.margin = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
                    $0.style.alignSelf = .FlexStart
                    $0.style.justifyContent = .FlexStart
                }),
                
                UIView().configure({
                    $0.backgroundColor = UIColor.a
                    $0.style.alignSelf = .Center
                    $0.style.flex = 0.8
                    }, children: [
                        UILabel().configure({
                            $0.text = self.post?.title
                            $0.textAlignment = .Center
                            $0.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                        }),
                        
                        UILabel().configure({
                            $0.text = self.post?.text
                            $0.textAlignment = .Left
                            $0.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
                            $0.numberOfLines = 0
                            $0.style.alignSelf = .Stretch
                            $0.style.margin = (0, 6.0, 0, 0, 8.0, 0)
                            $0.style.maxDimensions.height = 96
                            $0.style.margin = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
                        })
                    ]),
                
                UIButton().configure({
                    $0.backgroundColor = UIColor.f
                    $0.setTitle("GO", forState: .Normal)
                    $0.titleLabel!.textColor = UIColor.a
                    $0.titleLabel!.textAlignment = .Center
                    $0.titleLabel!.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
                    $0.addTarget(self.delegate, action: #selector(PostComponentDelegate.postComponentDidPressButton(_:)), forControlEvents: .TouchUpInside)
                    $0.style.minDimensions = (54, 54)
                    $0.style.alignSelf = .FlexEnd
                    $0.style.flex = 0.2
                    $0.style.margin = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
                })
            ])
    }
}
