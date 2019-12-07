//
//  LocationManager.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation
import MapKit

class LocationSearch {
    
    //MARK: - Perform Search Request
    // Use this function to perform a local search request with a string.

    func performSearchRequest(withQuery query:String, completion: @escaping ([Location], Error?) -> Void) {
        
        //initialise location array
        var locationArray: [Location] = []
        //initialise local search request
        let request = MKLocalSearch.Request()
        //initialise location manager
        let locationManager = CLLocationManager()
        //safely retrieve devices current location
        guard let coordinate = locationManager.location?.coordinate else { completion([], LocationError.coordinateError) ; return }
        //apply search query to request
        request.naturalLanguageQuery = "\(query)"
        //set the current device region / distance
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3200, longitudinalMeters: 3200)
        //call the API
        MKLocalSearch(request: request).start { (response, error) in
        
            //safely check for error
        guard error == nil else { completion([], error) ; return }
            //safely check response
        guard let response = response else { completion([], error) ; return }
            //check response size
        guard response.mapItems.count > 0 else { completion([], error) ; return }
        
            //loop through MKMapItems
        for location in response.mapItems {
            
            
            //safely get mapitem coordinate
            guard let coordinate = location.placemark.location?.coordinate else{
                completion([], LocationError.coordinateError)
                return
            }
            //Setup new location
            let newLocation = Location(locationName: location.name!, location: self.parseAddress(selectedItem: location.placemark), coordinate: coordinate)
            //append location to final array
            locationArray.append(newLocation)
        
        }
        //complete request
        completion(locationArray, nil)
    }
    
    }
    
    //MARK: - Parse Address
    //Use this function to turn an MKPlacemark into an address string.
    
    private func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        //return address string
        return addressLine
    }

}
