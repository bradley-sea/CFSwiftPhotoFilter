//
//  Filter.swift
//  CFImageFilterSwift
//
//  Created by Bradley Johnson on 9/22/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import Foundation
import CoreData

class Filter: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var inputEV: Float
    @NSManaged var inputIntensity: Float
    @NSManaged var inputPower: Float
    @NSManaged var inputScale: Float
    @NSManaged var red: Float
    @NSManaged var blue: Float
    @NSManaged var green: Float
    @NSManaged var inputTextureName: String?
    @NSManaged var favorited: Bool

}
