//
//  ViewControllerWithComponent.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 29/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

/// An example view controller that implements a scrollable list of controllers
/// - Note: Use this approach only for list with a small number of components.
/// - See the tableview example if you want to implement a list is scalable
class ViewControllerWithListOfComponents: UIViewController, PostComponentDelegate {
    
    let n = 6
    var wrapper: UIView!
    var posts: [Post]!
    
    private func createPosts() {
        
        // creates 'n' random posts
        var posts = [Post]()
        for _ in 0..<n {
            posts.append(Post())
        }
        self.posts = posts
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createPosts()
        
        // creates 'n' components
        var children = [ComponentView]()
        for i in 0..<n {
            children.append(PostComponentView().configure({
                
                $0.state = self.posts[i]

                // we can ovverride the default configuration of the component in here
                $0.defaultConfiguration()
                $0.style.margin = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
                $0.style.maxDimensions = (Undefined, Undefined)
                $0.delegate = self
            }))
            
            children.append(LikesComponentView().configure({
                $0.state = self.posts[i]

                // we can ovverride the default configuration of the component in here
                $0.defaultConfiguration()
            }))
            
        }
        
        // we layout the component view as part of a flexbox tree
        self.wrapper = UIScrollView().configure({
            
            $0.style.flexDirection = .Column
            $0.style.justifyContent = .FlexStart
            $0.style.alignItems = .FlexStart
            $0.style.dimensions = ~self.view.bounds.size
            
        }, children:children)
        
        self.view.addSubview(wrapper)
    }
    
    override func viewDidLayoutSubviews() {
        self.render()
    }
    
    func render() {
        
        // we re-render the whole tree
        self.wrapper?.render(self.view.bounds.size)
    }
    
    func componentDidPressButton(component: PostComponentView, state: Post) {
        
        if let index = self.posts.indexOf({ $0.text == state.text }) {
            self.posts[index] = Post()
        }
       
        UIView.animateWithDuration(0.3) {
            self.wrapper.render()
        }
    }
}
