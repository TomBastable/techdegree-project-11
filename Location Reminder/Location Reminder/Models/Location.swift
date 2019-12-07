//
//  Location.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Location: NSObject {
    var locationName: String
    var location: String
    var coordinate: CLLocationCoordinate2D
    
    init(locationName: String, location: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.location = location
        self.coordinate = coordinate
    }
    
}
