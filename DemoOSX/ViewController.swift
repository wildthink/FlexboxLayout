//
//  ViewController.swift
//  DemoOSX
//
//  Created by Jason Jobe on 3/28/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Cocoa
import FlexboxLayout

extension NSView {
    var backgroundColor: CGColor? {
        get { return self.layer?.backgroundColor }
        set {
            self.wantsLayer = true
            if self.layer == nil {
                self.layer = CALayer()
            }
            self.layer?.backgroundColor = newValue
        }
    }
}

class ViewController: NSViewController {
    
    var treeView: NSView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewHierarchy()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    func prepareViewHierarchy() {
        
        self.treeView?.removeFromSuperview()
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        self.treeView =  NSView().configure({
            $0.backgroundColor = NSColor.whiteColor().CGColor
            $0.layer?.borderColor = NSColor.redColor().CGColor
            $0.layer?.borderWidth = 2.0
            $0.style.justifyContent = .Center
            $0.style.alignSelf = .Stretch
            $0.style.margin = defaultMargin
            $0.style.flexDirection = .Row
            $0.style.minDimensions.width = 320
            
            }, children: [
                
                NSView().configure({
                    $0.backgroundColor = NSColor.greenColor().CGColor
                    $0.layer?.cornerRadius = 27.0
                    $0.style.dimensions = (54, 54)
                    $0.style.margin = defaultMargin
                    $0.style.alignSelf = .Center
                    $0.style.justifyContent = .FlexStart
                }),
                
                NSView().configure({
                    $0.backgroundColor = NSColor.yellowColor().CGColor
                    $0.style.alignSelf = .Center
                    $0.style.alignItems = .Center
                    $0.style.alignContent = .Center
                    $0.style.flex = 0.8
                    }, children: [
                        NSTextField().configure({
                            $0.stringValue = "TITLE"
                            $0.alignment = .Center
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                        }),
                        
                        NSTextField().configure({
                            $0.stringValue = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                            $0.usesSingleLineMode = false
                            $0.cell?.wraps = true
                            $0.cell?.scrollable = false
                            $0.alignment = .Left
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0, 6.0, 0, 0, 8.0, 0)
                        })
                        
                    ]),
                
                NSTextField().configure({
                    $0.backgroundColor = NSColor.blueColor()
                    $0.stringValue = "88:88"
                    $0.textColor = NSColor.whiteColor()
                    $0.alignment = .Center
                    $0.style.minDimensions = (54, 54)
                    $0.style.alignSelf = .Stretch
                    $0.style.flex = 0.2
                    $0.style.margin = defaultMargin
                })
            ])
        
        self.view.addSubview(self.treeView!)
    }
    
    override func viewDidLayout() {
        self.render()
    }

    func layout() {
//        self.treeView?.layout(self.view.bounds.size)
        self.treeView?.layout()
    }
    
    func render() {
        self.treeView?.configure({ (view) in
        })
//        self.treeView?.layout(self.view.bounds.size)
        self.treeView?.layout()
    }

}

