//
//  ViewController.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/21/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit
import CoreImage
import OpenGLES
import CoreData

class ViewController: UIViewController, SelectPhotoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let alertController = UIAlertController(title: "Action", message: "Choose an Action", preferredStyle: UIAlertControllerStyle.ActionSheet)
    var originalImage : UIImage?
    var originalThumbnail : UIImage?
    var filteredThumbnails = [FilterThumbnail]()
    var context : CIContext?
    var gpuContext : CIContext?
    var imageQueue = NSOperationQueue()
    
    var managedObjectContext : NSManagedObjectContext?
    var filters : [Filter]?

    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    //filter collectionview constraints
    @IBOutlet weak var bottomCollectionViewContraint: NSLayoutConstraint!
    //main imageView constraints
    @IBOutlet weak var topImageViewContraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get gpu context
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.gpuContext = CIContext(EAGLContext: myEAGLContext, options: options)
        
        self.setupAlertController()
        
        if self.imageView.image != nil {
            self.originalImage = self.imageView.image
        }
        
        //get our managed object context
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        var coreDataSeeder = CoreDataSeeder(context: self.managedObjectContext!)
        coreDataSeeder.seedCoreData()
        
        self.fetchFilters()
        self.generateThumbnail()
        self.resetFilteredThumbnails()

        //start filter collectionview off screen
        self.bottomCollectionViewContraint.constant = -200
        
        self.filterCollectionView.dataSource = self
        self.filterCollectionView.delegate = self
    }
 
    func setupAlertController() {
        //add photos option
        var photoLibraryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("ShowPhotos", sender: self)
        }
         self.alertController.addAction(photoLibraryAction)
        //add cameras option
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                let picker = UIImagePickerController()
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                picker.allowsEditing = true
                picker.delegate = self
                self.presentViewController(picker, animated: true, completion: { () -> Void in
                })
            })
            self.alertController.addAction(cameraAction)
        }
       //add filter option
        var filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
           self.goIntoFilteringMode()
        }
        self.alertController.addAction(filterAction)
        
        //add photos option
        var photoFrameworkAction = UIAlertAction(title:"PhotosFramework", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("ShowPhotosFramework", sender: self)
        }
        self.alertController.addAction(photoFrameworkAction)
        
        var avFoundationAction = UIAlertAction(title: "AVFoundation", style: UIAlertActionStyle.Default) { (alert) -> Void in
             self.performSegueWithIdentifier("ShowAVFoundation", sender: self)
        }
        self.alertController.addAction(avFoundationAction)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhotos" {
            let destination = segue.destinationViewController as PhotosViewController
            destination.delegate = self
        }
    }
    
    func goIntoFilteringMode() {
        
        self.bottomCollectionViewContraint.constant = 50
        self.topImageViewContraint.constant = 50
        self.bottomImageViewConstraint.constant = 200
        self.leftImageViewConstraint.constant = 50
        self.rightImageViewConstraint.constant = -50
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "leaveFilterMode")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func leaveFilterMode() {
        
        self.bottomCollectionViewContraint.constant = -200
        self.topImageViewContraint.constant = 8
        self.bottomImageViewConstraint.constant = 68
        self.leftImageViewConstraint.constant = 0
        self.rightImageViewConstraint.constant = 0
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        self.navigationItem.rightBarButtonItem = nil
    }

    @IBAction func actionPressed(sender: AnyObject) {
        self.presentViewController(self.alertController, animated: true) { () -> Void in
        }
    }

    func userDidSelectPhoto(image : UIImage) -> Void {
        self.imageView.image = image
        self.generateThumbnail()
        self.resetFilteredThumbnails()
        self.filterCollectionView.reloadData()  
    }
    
    func generateThumbnail() {
        var size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func resetFilteredThumbnails () {
        var newFilters = [FilterThumbnail]()
        for var index = 0; index < self.filters?.count; ++index {
            var thumbnail = FilterThumbnail(filter: self.filters![index], thumbNail: self.originalThumbnail!, queue: self.imageQueue, context: self.gpuContext!)
            newFilters.append(thumbnail)
        }
        self.filteredThumbnails = newFilters
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.generateThumbnail()
        self.resetFilteredThumbnails()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func fetchFilters() {
        var fetch = NSFetchRequest(entityName: "Filter")
        let fetchResults = self.managedObjectContext?.executeFetchRequest(fetch, error: nil)
        if let filters = fetchResults as [Filter]? {
           self.filters = filters
        }
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredThumbnails.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as FilterThumbnailCollectionViewCell
        
        var filterThumbnail = self.filteredThumbnails[indexPath.row]
        if filterThumbnail.filteredThumbnail != nil {
            cell.imageView.image = filterThumbnail.filteredThumbnail
        } else {
            cell.imageView.image = filterThumbnail.originalThumbnail
            filterThumbnail.generateFilterThumbnail({ (filteredThumb) -> (Void) in
                self.filterCollectionView.reloadItemsAtIndexPaths([indexPath])
            })
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
        var filter = self.filters![indexPath.row]
        
        var image = CIImage(image: self.imageView.image)
        var imgFilter = CIFilter(name:filter.name)
        imgFilter.setDefaults()
        imgFilter.setValue(image, forKey: kCIInputImageKey)
        
        //add the input values, different for different types of filters
        var keys = imgFilter.inputKeys() as [String]
        for key in keys {
            switch key {
            case "inputPower":
                imgFilter.setValue(filter.inputPower, forKey: "inputPower")
            case "inputEV":
                imgFilter.setValue(filter.inputEV, forKey: "inputEV")
            case "inputIntensity":
                imgFilter.setValue(filter.inputIntensity, forKey: "inputIntensity")
            case "inputTexture":
                var ciTextureImage = CIImage(image: UIImage(named: "glassdistortion"))
                imgFilter.setValue(ciTextureImage, forKey: "inputTexture")
            default:
                println("default")
            }
        }
        //generate result
        var result = imgFilter.valueForKey(kCIOutputImageKey) as CIImage
        var extent = result.extent()
        var imgRef = self.gpuContext!.createCGImage(result, fromRect: extent)
        self.imageView.image = UIImage(CGImage: imgRef)
    }

}

