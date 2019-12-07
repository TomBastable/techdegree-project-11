//
//  CreateViewController.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CreateViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var editReminderLocation: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reminderSubtitle: UITextField!
    @IBOutlet weak var reminderTitle: UITextField!
    let locationManager = CLLocationManager()
    var whenEnteringLocation: Bool = true
    let locationSearch = LocationSearch()
    let notificationManager = NotificationManager()
    var managedObjectContext:NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).context
    //presence indicates user is editing an existing reminder
    var editReminder: Reminder?
    //will contain a location once selected for the reminder
    var setLocation:Location?
    //array of locations returned by the API
    var locations = [Location](){
        //if did set, reload table view
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //setUI to dark
        self.mapView.delegate = self
        self.overrideUserInterfaceStyle = .dark
        //set map to device location
        guard let coordinate = locationManager.location?.coordinate else { return }
        self.mapView.moveMapWith(coordinate: coordinate, andScale: 50000)
        //check for edit
        if let reminder = editReminder{
            //is editing, so setup with existing reminder.
            setupEditWith(reminder: reminder)
        }
    }
    
    //MARK: - Save Reminder
    ///Adds a location request to the users device and stores the request in Core Data.
    
    @IBAction func saveReminder(_ sender: Any) {
        
        //safely unwrap key properties
        guard let titleText = reminderTitle.text, !titleText.isEmpty, let subtitleText = reminderSubtitle.text, !subtitleText.isEmpty, let reminderLocation = setLocation, let locationName =  setLocation?.locationName, !locationName.isEmpty else{
            self.displayAlertWith(error: LocationError.fillOutAllFields)
            return
        }
        
        //temp reminder property
        var tempReminder: Reminder?
        
        //check for edit
        if let reminder = editReminder{
            //is edit - set tempreminder
            tempReminder = reminder
            //unwrap uuid
            guard let currentUUID = tempReminder!.uuid else { return }
            //delete notification that was scheduled
            notificationManager.removeNotificationWith(uuid: currentUUID)
            
        }else{
            //is new - setup fresh property
            tempReminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: self.managedObjectContext) as? Reminder
        }
            //unwrap reminder
            guard let reminder = tempReminder else{ return }
            //create notification
            notificationManager.createNotificationWith(title: titleText, subtitle: subtitleText, whenEntering: whenEnteringLocation, coordinate: reminderLocation.coordinate) { (uuid, error) in
                
                if error == nil{
                //if notification creation was successful, save reminder to coredata
                reminder.title = titleText
                reminder.subtitle = subtitleText
                reminder.uuid = uuid
                reminder.latitude = "\(reminderLocation.coordinate.latitude)"
                reminder.longitude = "\(reminderLocation.coordinate.longitude)"
                reminder.locationName = locationName
                reminder.whenEntering = self.whenEnteringLocation
                    
                self.managedObjectContext.saveChanges()
                //pop the view (dispatch required due to background thread)
                DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                }
                }else if error != nil {
                    //error creating notification, most likely due to user permissions
                    self.displayAlertWith(error: LocationError.notificationCreationError)
                }
            }
    }
    
    //MARK: - Search Bar Delegate
    ///performs operation after 0.5 seconds - limiting api calls for MKLocalSearch
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            // to limit network activity, reload half a second after last key press.
           NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
           perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
            
    }
    
    //MARK: - Reload search bar
    ///This func is called 0.5 seconds after user inputs text into searchbar. Func will also deal with empty search bar.
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            
            //bar is empty, empty array.
            self.locations.removeAll()
            //reset map
            guard let coordinate = locationManager.location?.coordinate else { return }
            self.mapView.moveMapWith(coordinate: coordinate, andScale: 50000)
            return
        }
        //query is present = perform search
        locationSearch.performSearchRequest(withQuery: query) { (locations, error) in

            if error == nil{
                self.locations = locations
            }else{
                self.displayAlertWith(error: error!)
            }
            
        }
    }
    
    //MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //initialise cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        // Configure the cell...
        let location = locations[indexPath.row]
        cell.configureLocationCell(locationName: location.locationName, location: location.location)
        return cell
        
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //get location
        let location = locations[indexPath.row]
        //set location
        setLocation = location
        //move map
        self.mapView.moveMapWith(coordinate: location.coordinate, andScale: 300)
        //set edit location label blank
        self.editReminderLocation.text = ""
        
    }
    
    //MARK: - Entering / Leaving Location Choice Func
    ///Every time the user changes the segmented control, this function reflects that change in the WhenEntering Bool.
    @IBAction func segmentedDidChange(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0{
            //when entering location
            whenEnteringLocation = true
            
        }else if segmentedControl.selectedSegmentIndex == 1{
            //when leaving location
            whenEnteringLocation = false
        }
        
    }
    
    //MARK: - Setup Edit With Reminder
    ///This function takes a reminder and displays the relevant settings for it in the UI, ready for the user to manipulate it and indicating it's an edit as opposed to a creation.
    
    func setupEditWith(reminder: Reminder){
        
        //change navigation title
        self.navigationItem.title = "Edit Reminder"
        //set title
        self.reminderTitle.text = reminder.title
        //set subtitle
        self.reminderSubtitle.text = reminder.subtitle
        //set location label
        self.editReminderLocation.text = "Currently: \(whenEnteringLocation.whenEnteringString) \(reminder.locationName ?? "Unkown")."
        //safely get lat and long
        guard let lat = reminder.latitude?.toDouble(), let long = reminder.longitude?.toDouble() else { return }
        //set the user chosen location
        setLocation = Location(locationName: reminder.locationName!, location: "", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
        //move the map
        self.mapView.moveMapWith(coordinate: (setLocation?.coordinate)!, andScale: 300)
        
    }

}
