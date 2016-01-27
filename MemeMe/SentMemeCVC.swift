//
//  SentMemesCollectionViewController.swift
//
//
//  Created by Rahul Sarna on 8/23/15.
//
//

import UIKit

let reuseIdentifier = "CustomMemeCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let space: CGFloat = 3.0
        
        var dim = self.view.frame.size.height-self.view.frame.size.width
        if(dim<0){ //landscape
            dim = self.view.frame.size.width-self.view.frame.size.height-20 // Navigation bar
        }
        
        let dimension = dim / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CustomMemeCollectionViewCell
        let meme = self.appDelegate.memes[indexPath.item]
        cell.setTopBottomText(meme.top, bottomText: meme.bottom)
        let imageView = UIImageView(image: meme.memeImage)
        imageView.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleRightMargin , UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleTopMargin , UIViewAutoresizing.FlexibleWidth]
        imageView.contentMode = UIViewContentMode.Center
        cell.backgroundView = imageView

        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = appDelegate.memes[indexPath.item];
        
        memeDetailController.detailMeme = meme;
        memeDetailController.indexPath = indexPath.item;
        
        self.navigationController!.pushViewController(memeDetailController, animated: true)
        
    }
    
    @IBAction func addMemeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
