//
//  PhotosFrameworkViewController.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/22/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit
import Photos

class PhotosFrameworkViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var assetsFetchResults : PHFetchResult!
    var assetCollection : PHAssetCollection!
    var imageManager : PHCachingImageManager!
    
    var assetGridThumbnailSize : CGSize!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.imageManager = PHCachingImageManager()
        
        self.assetsFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        var scale = UIScreen.mainScreen().scale
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        var cellSize = flowLayout.itemSize
        self.assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.assetsFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotosCell", forIndexPath: indexPath) as PhotosFrameworkCell
        
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        var asset = self.assetsFetchResults[indexPath.item] as PHAsset
        
        self.imageManager.requestImageForAsset(asset, targetSize:self.assetGridThumbnailSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image : UIImage! ,info : [NSObject : AnyObject]!) -> Void in
            
            if cell.tag == currentTag {
                cell.imageView.image = image
            }
            
        })
        return cell
    }
    
    

}
