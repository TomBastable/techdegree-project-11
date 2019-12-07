//
//  Extensions.swift
//  Location Reminder
//
//  Created by Tom Bastable on 07/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    ///simplified function that moves the location of a map, sets a pin and displays a geofenced circle around the location.
    func moveMapWith(coordinate:CLLocationCoordinate2D, andScale scale: Double) {
        
        //create region
        let viewRegion = MKCoordinateRegion(center:coordinate, latitudinalMeters: scale, longitudinalMeters: scale)
        //display region
        self.setRegion(viewRegion, animated: true)
        //add geofenced circle
        let circle = MKCircle(center: coordinate, radius: 50)
        self.addOverlay(circle)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.addAnnotation(annotation)
        
        //show user location
        self.showsUserLocation = true
        
        print(coordinate.latitude)
        print(coordinate.longitude)
        
    }
    
}

extension UIViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? MKCircle else {return MKOverlayRenderer()}

        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        circleRenderer.strokeColor = .black
        circleRenderer.fillColor = .darkGray
        circleRenderer.alpha = 0.2
        return circleRenderer
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension Bool {
    
    ///Provides a string value for the WhenEntering property
    var whenEnteringString: String{
        
        if self == true{
            return "When Entering"
        }else {
            return "When Leaving"
        }
        
    }
    
}

extension UIViewController {
///displays a UIAlert which shows the localised error message. 
func displayAlertWith(error: Error){
    
    let title: String = "Error"
    let subTitle: String = error.localizedDescription
    let buttonTitle: String = "OK"
    
    let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
    
    self.present(alert, animated: true)
    
}

}
