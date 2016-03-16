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
        
        self.treeView?.removeFromSuperview()
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        
        self.treeView = UIView().configure({ (view, style) in
            view.backgroundColor = UIColor.a
            style.minDimensions = DeviceScreen.ScreenSize() - Dim(16.0, 32.0)
            style.flex = 1
            style.alignSelf = .Stretch
            
        }, children: [
            
            UIView().configure({ (view, style) in
                style.flex = 1
                style.alignSelf = .Stretch
                style.flexDirection = DeviceScreen.HorizontalSizeClass() == .Regular ? .Row : .Column

            }, children: [
            
                //cell
                UIView().configure({ (view, style) in
                    view.backgroundColor = UIColor.whiteColor()
                    view.alpha = self.toggle || DeviceScreen.HorizontalSizeClass() == .Regular ? 0 : 1
                    style.minDimensions = (150,68)
                    style.justifyContent = .Center
                    style.alignSelf = .Stretch
                    style.margin = defaultMargin
                    style.flexDirection = .Row
                    
                }, children: [
                    
                    UIView().configure({ (view, style) in
                        view.backgroundColor = UIColor.g
                        view.layer.cornerRadius = 27.0
                        style.dimensions = (54, 54)
                        style.margin = defaultMargin
                        style.alignSelf = .Center
                        style.justifyContent = .FlexStart
                    }),
                    
                    UIView().configure({ (view, style) in
                        view.backgroundColor = UIColor.a
                        style.minDimensions = (100, 54)
                        style.alignSelf = .Center
                        style.flex = 0.8
                    }, children: [
                        UILabel().configure({ (view, style) in
                            view.text = "I'm a cell title!"
                            view.textAlignment = .Center
                            view.font = UIFont.systemFontOfSize(18, weight: UIFontWeightBold)
                            style.alignSelf = .FlexStart
                            style.margin = (0, 4.0, 0, 0, 8.0, 0)
                        }),
                        
                        UILabel().configure({ (view, style) in
                            view.text = "We're going to disappear"
                            view.textAlignment = .Center
                            view.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
                            style.alignSelf = .FlexStart
                            style.margin = (0, 6.0, 0, 0, 8.0, 0)
                        })
                        
                    ]),
                    
                    UILabel().configure({ (view, style) in
                        view.backgroundColor = UIColor.f
                        view.text = "88:88"
                        view.textColor = UIColor.a
                        view.textAlignment = .Center
                        style.minDimensions = (54, 54)
                        style.alignSelf = .Center
                        style.flex = 0.2
                        style.margin = defaultMargin
                    })
                ]),
                
                //green box
                UIView().configure({ (view, style) in
                    view.backgroundColor = UIColor.c
                    style.minDimensions = (50,50)
                    style.flexDirection = .Row
                    style.flex = 1
                    style.margin = defaultMargin
                    style.flexDirection = DeviceScreen.HorizontalSizeClass() == .Regular ? .Column : .Row

                    }, children: [
                        
                        UIView().configure({ (view, style) in
                            view.backgroundColor = UIColor.d
                            style.flex = self.toggle ? 0.1 : 0.7
                            style.margin = defaultMargin
                        }),
                        
                        UIView().configure({ (view, style) in
                            view.backgroundColor = UIColor.e
                            style.flex = self.toggle ? 0.6 : 0.1
                            style.margin = defaultMargin
                        }),
                        
                        UIView().configure({ (view, style) in
                            view.backgroundColor = UIColor.d
                            style.flex = 0.1
                            style.margin = defaultMargin
                        })
                    ]),
                
                //button
                UIButton().configure({ (view, style) in
                    view.backgroundColor = UIColor.f
                    view.setTitle("Press me", forState: .Normal)
                    view.addTarget(self, action: "didPressButton:", forControlEvents: .TouchUpInside)
                    style.minDimensions = DeviceScreen.HorizontalSizeClass() == .Compact ? (250,50) : (100,50)
                    style.justifyContent = .FlexEnd
                    style.alignSelf = .FlexEnd
                    style.margin = defaultMargin
                })
                
            ]),
            
            //label
            UILabel().configure({ (label, style) -> Void in
                label.backgroundColor = UIColor.g
                label.numberOfLines = 0
                label.text = randomString(random() % 100)
                label.textColor = UIColor.a
                style.margin = defaultMargin
            })
        ])
        
        self.view.addSubview(self.treeView!)
    }
    
    dynamic func didPressButton(sender: UIButton) {
        self.toggle = !self.toggle
        
        self.treeView?.configure()
        UIView.animateWithDuration(0.1) { () -> Void in
            self.layout()
        }
    }

    override func viewDidLayoutSubviews() {
        self.render()
    }
    
    func layout() {
        self.treeView?.layout(self.view.bounds.size)
        self.treeView?.center = self.view.center
    }
    
    func render() {
        self.treeView?.configure()
        self.layout()
    }

    func injected() {
        prepareViewHierarchy()
        render()
    }
    
}


