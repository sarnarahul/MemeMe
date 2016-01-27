//
//  ViewController.swift
//  MemeMe
//
//  Created by Rahul Sarna on 7/18/15.
//  Copyright © 2015 Rahul Sarna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var bottomTextfieldActive = false;
    var memedImage = UIImage()
    var editingMeme:Meme!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.center = self.view.center
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.center = self.view.center
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = false;
        
        view.backgroundColor = UIColor.blackColor()
        
        if((editingMeme) != nil){
            self.imagePickerView.image = editingMeme.originalImage
            self.topTextField.text = editingMeme.top
            self.bottomTextField.text = editingMeme.bottom
            shareButton.enabled = true
        }
            
    }
    override func viewWillAppear(animated: Bool) {
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    //textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        
        if(bottomTextField == textField){
            bottomTextfieldActive = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let rawString = textField.text
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet
        let trimmed = rawString!.stringByTrimmingCharactersInSet(whitespace());
        if (trimmed.isEmpty) {
            // Text was empty or only whitespace.
            if(textField == topTextField){
                textField.text = "TOP"
            }
            else{
                textField.text = "BOTTOM"
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //move view up for keyboard
    
    func keyboardWillShow(notification: NSNotification){
        
        if(bottomTextfieldActive == true){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        
            bottomTextfieldActive = false
            self.view.frame.origin.y = 0
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    //Image Picker Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
        }
        shareButton.enabled = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
                
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Meme Editor
    func save() {
        //Create the meme
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, originalImage:imagePickerView.image!, memeImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage();
        
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) -> Void in
            if(completed){
                self.save()
                self.performSegueWithIdentifier("showTabBarSegue", sender: nil)
            }
        }
        
        self.presentViewController(activityVC, animated: true, completion: {
        })
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.navigationBar.hidden = true
        memeToolbar.hidden = true;
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.navigationController?.navigationBar.hidden = false
        memeToolbar.hidden = false;
        
        return memedImage
    }
}

