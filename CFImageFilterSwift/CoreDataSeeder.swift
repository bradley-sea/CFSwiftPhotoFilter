//
//  CoreDataSeeder.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/22/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder {
    
    var managedObjectContext : NSManagedObjectContext!
    
    init (context : NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func seedCoreData () {
        
        var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        sepia.name = "CISepiaTone"
        sepia.inputIntensity = 0.8
        
        var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        
        var pixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        pixellate.name = "CIPixellate"
        pixellate.favorited = true
        
        var gammaAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        gammaAdjust.name = "CIGammaAdjust"
        gammaAdjust.inputPower = 3.0
        
        var exposureAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        exposureAdjust.name = "CIExposureAdjust"
        exposureAdjust.inputEV = 2.0
        
        var glassDistortion = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        glassDistortion.name = "CIGlassDistortion"
        glassDistortion.inputTextureName = "glassdistortion"
        glassDistortion.favorited = true
        
        var photoEffectChrome = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        photoEffectChrome.name = "CIPhotoEffectChrome"
        
        var photoEffectInstant = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        photoEffectInstant.name = "CIPhotoEffectInstant"
        
        var photoEffectMono = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        photoEffectMono.name = "CIPhotoEffectMono"
        photoEffectMono.favorited = true
        
        var photoEffectNoir = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        photoEffectNoir.name = "CIPhotoEffectNoir"
        photoEffectNoir.favorited = true
        
        var photoEffectTonal = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        photoEffectTonal.name = "CIPhotoEffectTonal"
        photoEffectTonal.favorited = true
        
        var photoEffectTransfer = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        photoEffectTransfer.name = "CIPhotoEffectTransfer"
        photoEffectTransfer.favorited = true
        
        var error : NSError?
        self.managedObjectContext?.save(&error)
        
        if error != nil {
            println(error?.localizedDescription)
        }
    }

    
    
    
}
