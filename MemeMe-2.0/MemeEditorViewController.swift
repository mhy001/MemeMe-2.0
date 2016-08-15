//
//  ViewController.swift
//  MemeMe-2.0
//
//  Created by Mark Yang on 8/10/16.
//  Copyright © 2016 Myang. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -1.0
    ]
    
    // IBActions
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        presentImagePickerWith(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        presentImagePickerWith(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let meme = generateMeme()
        let activityViewController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activityType, completed: Bool, returnItems: [AnyObject]?, error: NSError?) in
            if !completed {
                return
            }
            self.save(meme)
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func resetApp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        enableMemeItems(false)
    }
    
    // UIViewController methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(topText)
        configureTextField(bottomText)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
    }
    
    // UIImagePickerControllerDelegate protocol methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITextFieldDelegate protocol methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if ((textField.tag == 0 && textField.text == "TOP") ||
            (textField.tag == 1 && textField.text == "BOTTOM")) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField.tag == 0 {
                textField.text = "TOP"
            } else {
                textField.text = "BOTTOM"
            }
        }
    }

    // Keyboard manipulation functions
    // Moves the view when keyboard covers the text field
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }

    // Meme utility functions
    func configureTextField(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.enabled = false
        
        textField.text = (textField == topText) ? "TOP" : "BOTTOM"
        textField.tag = (textField == topText) ? 0 : 1
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
        enableMemeItems(true)
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // Add meme to memes array in Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func enableMemeItems(enable: Bool) {
        shareButton.enabled = enable
        topText.enabled = enable
        bottomText.enabled = enable
    }
    
    func generateMeme() -> UIImage {
        hideToolbars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }
    
    func hideToolbars(hidden: Bool) {
        topToolbar.hidden = hidden
        bottomToolbar.hidden = hidden
    }
}

