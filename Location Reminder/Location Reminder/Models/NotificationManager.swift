//
//  NoticiationManager.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation
import MapKit

class NotificationManager {
    
    //MARK: - Create Notification
    ///If notification creation is succesful, this function will return the notifications unique id (For removal later on)
    
    func createNotificationWith(title: String, subtitle: String, whenEntering:Bool, coordinate: CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void){
        
        //init notificationCenter
        let notificationCenter = UNUserNotificationCenter.current()
        //create unique id
        let uniqueId = UUID()
        //Begin setup of local notification payload
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = UNNotificationSound.default
        
        //setup region
        let region = CLCircularRegion(center: coordinate, radius: 10, identifier: uniqueId.uuidString)
        
        //setup entering / leaving choice
        if whenEntering{
            
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
        }else if !whenEntering{
            
            region.notifyOnEntry = false
            region.notifyOnExit = true
            
        }
        
        //setup trigger
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        //setup request
        let request = UNNotificationRequest(identifier: uniqueId.uuidString, content: content, trigger: trigger)
        //start the request
        notificationCenter.add(request) { (error) in
            
            //if error, complete as such
            if let error = error {
                completion(nil, error)
            //otherwise complete with the uuid
            }else{
                completion(uniqueId.uuidString, nil)
            }
            
        }
        
    }
    
    //MARK: - Remove Notification
    ///this function requires a notifications uuid to successfully work.
     
    func removeNotificationWith(uuid: String){
        
        //init notificationCenter
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [uuid])
        
    }
    
}
