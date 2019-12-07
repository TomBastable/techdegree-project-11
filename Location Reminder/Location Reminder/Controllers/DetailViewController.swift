//
//  ViewController.swift
//  Location Reminder
//
//  Created by Tom Bastable on 04/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var reminderSubtitleLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var reminder:Reminder?
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.overrideUserInterfaceStyle = .dark
        //check reminder exists
        if let reminder = reminder {
            //reminder exists, setupview
            setupViewWith(reminder: reminder)
        }
    }
    
    //MARK:- VWA
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //resetup view - used when editing reminders
        if let reminder = reminder{
        setupViewWith(reminder: reminder)
        }
    }
    
    //MARK: - Setup View With Reminder
    ///Use this function to setup the detail view with a reminder.
    
    func setupViewWith(reminder: Reminder) {
        
        self.navigationItem.title = "\(reminder.title!)"
        //location
        self.locationLabel.text = "\(reminder.whenEntering.whenEnteringString) \(reminder.locationName!)"
        //title
        self.reminderLabel.text = reminder.title
        //subtitle
        self.reminderSubtitleLabel.text = reminder.subtitle
        //safely convert to Double
        guard let lat = reminder.latitude?.toDouble(), let long = reminder.longitude?.toDouble() else { return }
        //map setup
        self.mapView.moveMapWith(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), andScale: 200)
        
    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //check for edit segue
        if segue.identifier == "editReminder"{
            //set both when entering and the reminder itself.
            let createVC = segue.destination as! CreateViewController
            createVC.editReminder = reminder
            createVC.whenEnteringLocation = reminder!.whenEntering
            
        }
    }

    
    
}

