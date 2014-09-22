//
//  PhotosViewController.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/21/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

protocol SelectPhotoDelegate {
    func userDidSelectPhoto(UIImage) -> Void
}

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var photos = [UIImage]()
    var delegate : SelectPhotoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPhotos()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func loadPhotos() {
        var photo1 = UIImage(named: "homeImage.jpg")
        var photo2 = UIImage(named: "photo2.jpg")
        var photo3 = UIImage(named: "photo3.jpg")
        var photo4 = UIImage(named: "photo4.jpg")
        var photo5 = UIImage(named: "photo5.jpg")
        var photo6 = UIImage(named: "photo6.jpg")
        var photo7 = UIImage(named: "photo7.jpg")
        var photo8 = UIImage(named: "photo8.jpg")
        self.photos = [photo1,photo2,photo3,photo4,photo5,photo6,photo7,photo8]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as PhotoCollectionViewCell
        cell.imageView.image = self.photos[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.delegate != nil {
            self.delegate?.userDidSelectPhoto(self.photos[indexPath.row])
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

}
