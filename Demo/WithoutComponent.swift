//
//  ViewController.swift
//  Demo
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

class ViewControllerWithoutComponent: UIViewController {
    
    var treeView: UIView? = nil
    var toggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewHierarchy()
    }
    
    func prepareViewHierarchy() {
        
        self.treeView?.removeFromSuperview()
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        self.treeView =  UIView().configure({
            $0.backgroundColor = UIColor.whiteColor()
            $0.layer.borderColor = UIColor.b.CGColor
            $0.layer.borderWidth = 2.0
            $0.style.justifyContent = .Center
            $0.style.alignSelf = .Stretch
            $0.style.margin = defaultMargin
            $0.style.flexDirection = .Row
            $0.style.maxDimensions.width = ~(self.view.bounds.width - 40)
            }, children: [
                
                UIView().configure({
                    $0.backgroundColor = UIColor.a
                    $0.layer.cornerRadius = 27.0
                    $0.style.dimensions = (54, 54)
                    $0.style.margin = defaultMargin
                    $0.style.alignSelf = .FlexStart
                    $0.style.justifyContent = .FlexStart
                }),
                
                UIView().configure({
                    $0.backgroundColor = UIColor.a
                    $0.style.alignSelf = .Center
                    $0.style.flex = 0.8
                    }, children: [
                        UILabel().configure({
                            $0.text = "Lorem Ipsum"
                            $0.textAlignment = .Center
                            $0.font = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                        }),
                        
                        UILabel().configure({
                            $0.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet consectetur adipisci velit. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Neque porro quisquam est qui dolorem ipsum quia dolor sit amet consectetur adipisci velit."
                            $0.textAlignment = .Left
                            $0.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
                            $0.numberOfLines = 0
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0, 6.0, 0, 0, 8.0, 0)
                            $0.style.maxDimensions.height = 96
                            $0.style.margin = defaultMargin
                        })
                        
                    ]),
                
                UILabel().configure({
                    $0.backgroundColor = UIColor.f
                    $0.text = "88:88"
                    $0.textColor = UIColor.a
                    $0.textAlignment = .Center
                    $0.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
                    $0.style.minDimensions = (54, 54)
                    $0.style.alignSelf = .FlexEnd
                    $0.style.flex = 0.2
                    $0.style.margin = defaultMargin
                })
        ])

        self.view.addSubview(self.treeView!)
    }
    
    override func viewDidLayoutSubviews() {
        self.render()
    }
    
    func render() {
        self.treeView?.render()
        self.treeView?.center = self.view.center
    }
    
    
}


