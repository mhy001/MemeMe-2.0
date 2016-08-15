//
//  MemeDetailViewController.swift
//  MemeMe-2.0
//
//  Created by Mark Yang on 8/11/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    // UIViewController methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageView!.image = meme.memedImage
    }
    
}
