//
//  LocationError.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation

enum LocationError: Error{
    
    case coordinateError
    case fillOutAllFields
    case notificationCreationError
    case locationPermissionsError
}


extension LocationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .coordinateError:
            return NSLocalizedString("Error setting up coodinates.", comment: "Error")
        case .fillOutAllFields:
            return NSLocalizedString("Please ensure all fields are filled out and a Location is chosen", comment: "Error")
        case .notificationCreationError:
            return NSLocalizedString("Error creating notification. Please ensure you have given permission for Notifications - This setting can be found in your app settings.", comment: "")
        case .locationPermissionsError:
            return NSLocalizedString("You will need to grant this app permission to use your location and provide notifications for it to work as designed. You can change this setting in the settings app on your device.", comment: "")
    }
}
}
