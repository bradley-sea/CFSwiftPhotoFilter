//
//  FilterThumbnail.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/22/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class FilterThumbnail {
    
    var originalThumbnail : UIImage
    var filteredThumbnail : UIImage?
    var filter : Filter
    var imageQueue : NSOperationQueue
    var gpuContext : CIContext
    var ciFilter : CIFilter?
    
    init(filter : Filter, thumbNail : UIImage, queue : NSOperationQueue, context : CIContext) {
        self.filter = filter
        self.originalThumbnail = thumbNail
        self.imageQueue = queue
        self.gpuContext = context
    }
    
    func generateFilterThumbnail(completionHandler : (filteredThumb : UIImage) -> (Void)) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            //setup filter
            var image = CIImage(image: self.originalThumbnail)
            var imgFilter = CIFilter(name:self.filter.name)
            imgFilter.setDefaults()
            imgFilter.setValue(image, forKey: kCIInputImageKey)
            
               //add the input values, different for different types of filters
            var keys = imgFilter.inputKeys() as [String]
            for key in keys {
                switch key {
                case "inputPower":
                    imgFilter.setValue(self.filter.inputPower, forKey: "inputPower")
                case "inputEV":
                    imgFilter.setValue(self.filter.inputEV, forKey: "inputEV")
                case "inputIntensity":
                    imgFilter.setValue(self.filter.inputIntensity, forKey: "inputIntensity")
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
            var imgRef = self.gpuContext.createCGImage(result, fromRect: extent)
            self.ciFilter =  imgFilter
            
            //run callback on main thread
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.filteredThumbnail = UIImage(CGImage: imgRef)
                 completionHandler(filteredThumb: self.filteredThumbnail!)
            })
        }
    }
}
