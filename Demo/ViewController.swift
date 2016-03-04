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
    
    var node: Node?
    
    let containerView = UIView(color: UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1))
    let firstView = UIView(color: UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1))
    lazy var secondView: UIView = {
        let view = UIView(color: UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))
        view.addSubview(UIView(color: UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)))
        view.addSubview(UIView(color: UIColor(red: 46/255, green: 125/255, blue: 50/255, alpha: 1)))
        return view
    }()
    let thirdView = UIView(color: UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1))
    let fourthView = UILabel(color: UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1), text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViewHierarchy()
    }
    
    func prepareViewHierarchy() {
        self.view.addSubview(containerView)
        self.containerView.addSubview(firstView)
        self.containerView.addSubview(secondView)
        self.containerView.addSubview(thirdView)
        self.containerView.addSubview(fourthView)
        flexboxLayout()
    }
    
    func flexboxLayout() {
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        
        self.containerView.flexNode.style.minDimensions = (320, 420)
        self.containerView.flexNode.style.flex = 1
        self.containerView.flexNode.style.alignSelf = .Stretch
        
        self.firstView.flexNode.style.minDimensions = (150,50)
        self.firstView.flexNode.style.justifyContent = .FlexStart
        self.firstView.flexNode.style.alignSelf = .FlexStart
        self.firstView.flexNode.style.margin = defaultMargin
        
        self.secondView.flexNode.style.minDimensions = (50,50)
        self.secondView.flexNode.style.flexDirection = .Row
        self.secondView.flexNode.style.flex = 1
        self.secondView.flexNode.style.margin = defaultMargin
        
        self.secondView.subviews[0].flexNode.style.flex = 0.3
        self.secondView.subviews[0].flexNode.style.margin = defaultMargin

        self.secondView.subviews[1].flexNode.style.flex = 0.7
        self.secondView.subviews[1].flexNode.style.margin = defaultMargin
        
        self.thirdView.flexNode.style.minDimensions = (100,50)
        self.thirdView.flexNode.style.justifyContent = .FlexEnd
        self.thirdView.flexNode.style.alignSelf = .FlexEnd
        self.thirdView.flexNode.style.margin = defaultMargin
        
        self.fourthView.flexNode.style.minDimensions = (100,50)
        self.fourthView.flexNode.style.justifyContent = .FlexStart
        self.fourthView.flexNode.style.alignSelf = .Center
        self.fourthView.flexNode.style.margin = defaultMargin
    }

    override func viewDidLayoutSubviews() {
        self.containerView.computeFlexboxLayout(self.view.bounds.size)
        self.containerView.center = self.view.center
    }

}

