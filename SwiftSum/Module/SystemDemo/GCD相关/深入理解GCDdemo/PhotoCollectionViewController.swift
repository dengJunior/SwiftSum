//
//  PhotoCollectionViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import AssetsLibrary

// MARK: - GCD深入理解demo

private let CellImageViewTag = 3
private let BackgroundImageOpacity: CGFloat = 0.1

private let reuseIdentifier = "photoCell"

class PhotoCollectionViewController: UICollectionViewController {

    private var contentUpdateObserver: NSObjectProtocol!
    private var contentAddObserver: NSObjectProtocol!
    
    private var popController: UIPopoverController!
    var libaray: ALAssetsLibrary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Background image setup
        let backgroundImageView = UIImageView(image: UIImage(named:"background"))
        backgroundImageView.alpha = BackgroundImageOpacity
        backgroundImageView.contentMode = .Center
        collectionView?.backgroundView = backgroundImageView
        
        contentUpdateObserver = NSNotificationCenter.defaultCenter().addObserverForName(PhotoManagerContentUpdateNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) in
            self.contentChangedNotification(notification)
        })
        contentAddObserver = NSNotificationCenter.defaultCenter().addObserverForName(PhotoManagerAddedContentNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) in
            self.contentChangedNotification(notification)
        })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(contentUpdateObserver)
        NSNotificationCenter.defaultCenter().removeObserver(contentAddObserver)
    }

    func contentChangedNotification(notification: NSNotification!) {
        collectionView?.reloadData()
    }

    @IBAction func addPhotoAssets(sender: AnyObject!)  {
        // Close popover if it is visible
        if popController?.popoverVisible == true {
            popController.dismissPopoverAnimated(true)
            popController = nil
            return
        }
        
        let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .ActionSheet)
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let libraryAction = UIAlertAction(title: "相册选择", style: .Default) {
            action in
            self.showPhotoLibrary()
        }
        alert.addAction(libraryAction)
        
        // Internet button
        let internetAction = UIAlertAction(title: "网上下载", style: .Default) {
            action in
            self.downloadImageAssets()
        }
        alert.addAction(internetAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func downloadImageAssets() {
        PhotoManager.sharedManager.downloadPhotosCompletion { (error) in
            let message = error?.localizedDescription ?? "The images have finished downloading"
            let alert = UIAlertController(title: "Download Complete", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

extension PhotoCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        
        //指定使用照相机模式,可以指定使用相册／照片库
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true) {
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let photo = AssetPhoto(image: image)
        PhotoManager.sharedManager.addPhoto(photo)
        picker.dismissViewControllerAnimated(true) { 
            
        }
    }
}

extension PhotoCollectionViewController {
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.sharedManager.photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(CellImageViewTag) as! UIImageView
        let photo = PhotoManager.sharedManager.photos[indexPath.row]
        
        switch photo.status {
        case .GoodToGo:
            imageView.image = photo.thumbnail
        case .Downloading:
            imageView.image = UIImage(named: "photoDownloading")
        case .Failed:
            imageView.image = UIImage(named: "photoDownloadError")
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = PhotoManager.sharedManager.photos[indexPath.row]
        
        switch photo.status {
        case .GoodToGo:
            if let detailVc = PhotoDetailViewController.newInstanceFromStoryboard("GooglyPuff") as? PhotoDetailViewController {
                detailVc.image = photo.image
                navigationController?.pushViewController(detailVc, animated: true)
            }
        case .Downloading:
            let alert = UIAlertController(title: "Downloading",
                                          message: "The image is currently downloading",
                                          preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        case .Failed:
            let alert = UIAlertController(title: "Image Failed",
                                          message: "The image failed to be created",
                                          preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}

