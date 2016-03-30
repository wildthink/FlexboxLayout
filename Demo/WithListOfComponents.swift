//
//  ViewControllerWithComponent.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 29/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

class ViewControllerWithListOfComponents: UIViewController, PostComponentDelegate {
    
    var wrapper: UIView!
    var postState1 = Post()
    var postState2 = Post()
    var postState3 = Post()

    override func viewDidLoad() {
        super.viewDidLoad()

        // we layout the component view as part of a flexbox tree
        self.wrapper = UIView().configure({
            $0.style.flexDirection = .Column
            $0.style.justifyContent = .Center
            $0.style.alignItems = .Center
            $0.style.margin = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
            
        }, children:[
            
            PostComponentView(withState: { return self.postState1 }).configure({
                
                // we can ovverride the default configuration of the component in here
                $0.defaultConfiguration()
                $0.style.maxDimensions = (Undefined, Undefined)
            }),
            PostComponentView(withState: { return self.postState2 }).configure({
                $0.defaultConfiguration()
                $0.style.maxDimensions = (Undefined, Undefined)
            }),

            PostComponentView(withState: { return self.postState3 }).configure({
                $0.defaultConfiguration()
                $0.style.maxDimensions = (Undefined, Undefined)
            })

        ])
        
        self.view.addSubview(wrapper)
    }
    
    override func viewDidLayoutSubviews() {
        self.render()
    }
    
    func render() {
        
        // we re-render the whole tree
        self.wrapper?.render(self.view.bounds.size)
        self.wrapper?.center = self.view.center
    }
    
    dynamic func postComponentDidPressButton(sender: UIButton) {
        
        // when the button is pressed we generate another post and re-render the component
        postState1 = Post()
        postState2 = Post()
        postState3 = Post()
        
        self.render()
    }
}
