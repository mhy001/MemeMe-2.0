//
//  TableViewController.swift
//  MemeMe-2.0
//
//  Created by Mark Yang on 8/10/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var allMemes: [Meme]!
    
    // UIViewController methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        allMemes = appDelegate.memes
        tableView.reloadData()
    }
    
    // UITableViewDataSource protocol methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableMemeCell") as! MemeTableViewCell
        let meme = allMemes[indexPath.row]
        
        cell.memeText?.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    // UITableViewDelegate protocol methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = allMemes[indexPath.row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
}
