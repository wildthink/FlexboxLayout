//
//  ViewController.swift
//  Demo
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

class ViewController: UIViewController {
    
    var treeView: UIView? = nil
    var toggle = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewHierarchy()
    }
    
    func prepareViewHierarchy() {
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        let horizontal: (Void) -> (UIUserInterfaceSizeClass) = { return UIScreen.mainScreen().traitCollection.horizontalSizeClass };
        
        self.treeView = UIView().configure({ (view, style) in
            view.backgroundColor = UIColor.a
            style.minDimensions = (horizontal() == .Regular ? 480 : 320, 420)
            style.flex = 1
            style.alignSelf = .Stretch
            
        }, children: [
            
            UIView().configure({ (view, style) in
                style.flex = 1
                style.alignSelf = .Stretch
                style.flexDirection = horizontal() == .Regular ? .Row : .Column

            }, children: [
            
                UIView().configure({ (view, style) in
                    view.backgroundColor = UIColor.b
                    view.hidden = self.toggle
                    style.minDimensions = (150,50)
                    style.justifyContent = .Center
                    style.alignSelf = .Stretch
                    style.margin = defaultMargin
                }),
                
                UIView().configure({ (view, style) in
                    view.backgroundColor = UIColor.c
                    style.minDimensions = (50,50)
                    style.flexDirection = .Row
                    style.flex = 1
                    style.margin = defaultMargin
                    style.flexDirection = horizontal() == .Regular ? .Column : .Row

                    }, children: [
                        
                        UIView().configure({ (view, style) in
                            view.backgroundColor = UIColor.d
                            style.flex = self.toggle ? 0.3 : 0.8
                            style.margin = defaultMargin
                        }),
                        
                        UIView().configure({ (view, style) in
                            view.backgroundColor = UIColor.e
                            style.flex = self.toggle ? 0.7 : 0.2
                            style.margin = defaultMargin
                        })
                    ]),
                
                UIButton().configure({ (view, style) in
                    view.backgroundColor = UIColor.f
                    view.setTitle("Press me", forState: .Normal)
                    view.addTarget(self, action: "didPressButton:", forControlEvents: .TouchUpInside)
                    style.minDimensions = (100,50)
                    style.justifyContent = .FlexEnd
                    style.alignSelf = .FlexEnd
                    style.margin = defaultMargin
                })
                
            ]),
            
            UILabel().configure({ (label, style) -> Void in
                label.backgroundColor = UIColor.g
                label.numberOfLines = 0
                label.text = "Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
                style.margin = defaultMargin
            })
        ])
        
        self.view.addSubview(self.treeView!)
    }
    
    dynamic func didPressButton(sender: UIButton) {
        self.toggle = !self.toggle
        
        UIView.animateWithDuration(1) { () -> Void in
            self.render()
        }
    }

    override func viewDidLayoutSubviews() {
        render()
    }
    
    func render() {
        self.treeView!.render(self.view.bounds.size)
        self.treeView!.center = self.view.center
    }

}

