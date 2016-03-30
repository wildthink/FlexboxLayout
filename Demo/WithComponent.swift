//
//  WithComponent.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 30/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation
import UIKit
import FlexboxLayout

/// A 'ComponentView' can be used as a normal view at any point.
/// Also you don't need to set a frame for it since it has its intrinsic content size.
class ViewControllerWithComponent: UIViewController, PostComponentDelegate {
    
    var state = Post()
    var component: PostComponentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates the component with the get-state closure and set this obj as delegate
        self.component = PostComponentView().configure({
            $0.state = self.state
            $0.defaultConfiguration()
        })
        
        self.component.delegate = self
        self.view.addSubview(self.component)
        self.render()
    }
    
    override func viewDidLayoutSubviews() {
        self.render()
    }
    
    func render() {
        
        // render the component
        self.component.render()
        self.component.center = self.view.center
    }
    
    dynamic func postComponentDidPressButton(sender: UIButton) {
        
        // a new random post
        self.state = Post()
        
        // when the button is pressed we generate another post and re-render the component
        self.render()
    }
}
