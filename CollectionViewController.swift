//
//  CollectionViewController.swift
//  MemeMe-2.0
//
//  Created by Mark Yang on 8/11/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var allMemes: [Meme]!
    
    // UIViewController methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        allMemes = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat
        let dimension: CGFloat
        
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            space = 3.0
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        } else {
            space = 5.0
            dimension = (view.frame.size.width - (2 * space)) / 5.0
        }
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }

    
    // UICollectionViewController Data Source methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = allMemes[indexPath.row]
        
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    // UICollectionViewController Delegate methods
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = allMemes[indexPath.row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
}
