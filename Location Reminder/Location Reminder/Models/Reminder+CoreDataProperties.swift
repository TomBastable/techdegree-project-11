//
//  Reminder+CoreDataProperties.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        
       let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        
        return request
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var uuid: String?
    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?
    @NSManaged public var locationName: String?
    @NSManaged public var whenEntering: Bool

}
