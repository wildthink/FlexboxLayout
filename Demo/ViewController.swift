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
        
        self.treeView = UIView().configure({
            $0.backgroundColor = UIColor.a
            $0.style.minDimensions = DeviceScreen.ScreenSize() - Dim(16.0, 32.0)
            $0.style.flex = 1
            $0.style.alignSelf = .Stretch
            
            }, children: [
                
                UIView().configure({
                    $0.style.flex = 1
                    $0.style.alignSelf = .Stretch
                    $0.style.flexDirection = DeviceScreen.HorizontalSizeClass() == .Regular ? .Row : .Column
                    
                    }, children: [
                        
                        //cell
                        UIView().configure({
                            $0.backgroundColor = UIColor.whiteColor()
                            $0.alpha = self.toggle || DeviceScreen.HorizontalSizeClass() == .Regular ? 0 : 1
                            $0.style.justifyContent = .Center
                            $0.style.alignSelf = .Stretch
                            $0.style.margin = defaultMargin
                            $0.style.flexDirection = .Row
                            
                            }, children: [
                                
                                UIView().configure({
                                    $0.backgroundColor = UIColor.g
                                    $0.layer.cornerRadius = 27.0
                                    $0.style.dimensions = (54, 54)
                                    $0.style.margin = defaultMargin
                                    $0.style.alignSelf = .Center
                                    $0.style.justifyContent = .FlexStart
                                }),
                                
                                UIView().configure({
                                    $0.backgroundColor = UIColor.a
                                    $0.style.minDimensions = (100, 54)
                                    $0.style.alignSelf = .Center
                                    $0.style.flex = 0.8
                                    }, children: [
                                        UILabel().configure({
                                            $0.text = "I'm a cell title!"
                                            $0.textAlignment = .Center
                                            $0.font = UIFont.systemFontOfSize(18, weight: UIFontWeightBold)
                                            $0.style.alignSelf = .FlexStart
                                            $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                                        }),
                                        
                                        UILabel().configure({
                                            $0.text = "We're going to disappear"
                                            $0.textAlignment = .Center
                                            $0.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
                                            $0.style.alignSelf = .FlexStart
                                            $0.style.margin = (0, 6.0, 0, 0, 8.0, 0)
                                        })
                                        
                                    ]),
                                
                                UILabel().configure({
                                    $0.backgroundColor = UIColor.f
                                    $0.text = "88:88"
                                    $0.textColor = UIColor.a
                                    $0.textAlignment = .Center
                                    $0.style.minDimensions = (54, 54)
                                    $0.style.alignSelf = .Center
                                    $0.style.flex = 0.2
                                    $0.style.margin = defaultMargin
                                })
                            ]),
                        
                        //green box
                        UIView().configure({
                            $0.backgroundColor = UIColor.c
                            $0.style.minDimensions = (50,50)
                            $0.style.flexDirection = .Row
                            $0.style.flex = 1
                            $0.style.margin = defaultMargin
                            $0.style.flexDirection = DeviceScreen.HorizontalSizeClass() == .Regular ? .Column : .Row
                            
                            }, children: [
                                
                                UIView().configure({
                                    $0.backgroundColor = UIColor.d
                                    $0.style.flex = self.toggle ? 0.1 : 0.7
                                    $0.style.margin = defaultMargin
                                }),
                                
                                UIView().configure({
                                    $0.backgroundColor = UIColor.e
                                    $0.style.flex = self.toggle ? 0.6 : 0.1
                                    $0.style.margin = defaultMargin
                                }),
                                
                                UIView().configure({
                                    $0.backgroundColor = UIColor.d
                                    $0.style.flex = 0.1
                                    $0.style.margin = defaultMargin
                                })
                            ]),
                        
                        //button
                        UIButton().configure({
                            $0.backgroundColor = UIColor.f
                            $0.setTitle("Press me", forState: .Normal)
                            $0.addTarget(self, action: "didPressButton:", forControlEvents: .TouchUpInside)
                            $0.style.minDimensions = DeviceScreen.HorizontalSizeClass() == .Compact ? (250,50) : (100,50)
                            $0.style.justifyContent = .FlexEnd
                            $0.style.alignSelf = .FlexEnd
                            $0.style.margin = defaultMargin
                        })
                        
                    ]),
                
                //label
                UILabel().configure({
                    $0.backgroundColor = UIColor.g
                    $0.numberOfLines = 0
                    $0.text = randomString(random() % 100)
                    $0.textColor = UIColor.a
                    $0.style.margin = defaultMargin
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


