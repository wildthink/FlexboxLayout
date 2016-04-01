//
//  WithTableView.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 31/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation
import UIKit
import FlexboxLayout

/// A 'ComponentView' can be used as a normal view at any point.
/// Also you don't need to set a frame for it since it has its intrinsic content size.
class ViewControllerWithTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let n = 100
    let reuseIdentifier = "post"
    var tableView: UITableView!
    
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
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.backgroundColor = UIColor.a
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView )
        
        self.tableView.registerPrototype(reuseIdentifier, component: PostComponentView())
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = self.view.bounds
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.n
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.posts[indexPath.row] = Post()
        self.tableView.refreshComponentAtIndexPath(indexPath)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ComponentCell! = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? ComponentCell ?? ComponentCell(reuseIdentifier: reuseIdentifier, component: PostComponentView())
        cell.state = self.posts[indexPath.row]
        cell.render(CGSize(tableView.bounds.size.width))
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.heightForCellWithState(reuseIdentifier, state: self.posts[indexPath.row])
    }

    

}
