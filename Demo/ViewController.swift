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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewHierarchy()
    }
    
    func prepareViewHierarchy() {
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        
        self.treeView = UIView().configure({ (view, style) in
            view.backgroundColor = UIColor.a
            style.minDimensions = (320, 420)
            style.flex = 1
            style.alignSelf = .Stretch
        }, children: [
            
            UIView().configure({ (view, style) in
                view.backgroundColor = UIColor.b
                style.minDimensions = (150,50)
                style.justifyContent = .FlexStart
                style.alignSelf = .FlexStart
                style.margin = defaultMargin
            }),
            
            UIView().configure({ (view, style) in
                view.backgroundColor = UIColor.c
                style.minDimensions = (50,50)
                style.flexDirection = .Row
                style.flex = 1
                style.margin = defaultMargin
            }, children: [
            
                UIView().configure({ (view, style) in
                    view.backgroundColor = UIColor.d
                    style.flex = 0.3
                    style.margin = defaultMargin
                }),
                
                UIView().configure({ (view, style) in
                    view.backgroundColor = UIColor.e
                    style.flex = 0.7
                    style.margin = defaultMargin
                })
            ]),
            
            UIView().configure({ (view, style) in
                view.backgroundColor = UIColor.f
                style.minDimensions = (100,50)
                style.justifyContent = .FlexEnd
                style.alignSelf = .FlexEnd
                style.margin = defaultMargin
            }),
            
            UILabel().configure({ (label, style) -> Void in
                label.backgroundColor = UIColor.g
                label.numberOfLines = 0
                label.text = "Lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
                style.margin = defaultMargin
            })
        ])
        
        self.view.addSubview(self.treeView!)
    }

    override func viewDidLayoutSubviews() {
        self.treeView!.render(self.view.bounds.size)
        self.treeView!.center = self.view.center
    }

}

