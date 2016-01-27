//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Rahul Sarna on 8/26/15.
//  Copyright (c) 2015 Rahul Sarna. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController{
    
    var detailMeme: Meme!
    var indexPath: Int!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme:")
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        // Set the image
        if let myMeme = detailMeme {
            self.memeDetailImageView.image = myMeme.memeImage
        }
    }
    
    func editMeme(sender: UIBarButtonItem!){
        self.performSegueWithIdentifier("editingMeme", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "editingMeme"){
            let memeEditorVC:ViewController!
            
            var navController = segue.destinationViewController as! UINavigationController
            
            memeEditorVC = navController.viewControllers.first as! ViewController
        
            memeEditorVC.editingMeme = detailMeme
        }
    }
    
    @IBAction func deleteButton(sender: AnyObject) {
        
        appDelegate.memes.removeAtIndex(indexPath)
        
        self.navigationController?.popToRootViewControllerAnimated(true);
        
    }
    
//    @IBAction func editButton(sender: AnyObject) {
//        
//        let memeEditController = self.storyboard!.instantiateViewControllerWithIdentifier("EditMemeViewController") as! ViewController
//        let meme = appDelegate.memes[indexPath.item];
//        
//        memeDetailController.detailMeme = meme;
//        memeDetailController.indexPath = indexPath.item;
//        
//        self.navigationController!.pushViewController(memeDetailController, animated: true)
//        
//    }
    
    
}