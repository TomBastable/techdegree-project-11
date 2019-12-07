//
//  MasterViewController.swift
//  Location Reminder
//
//  Created by Tom Bastable on 05/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MasterViewController: UITableViewController, CLLocationManagerDelegate {
    
    //MARK: - Properties
    
    let locationManager = CLLocationManager()
    let notificationManager = NotificationManager()
    let managedObjectContext:NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).context
    //fetched results controller
    lazy var fetchedResultsController: FetchedResultsController = {
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.tableView, request: Reminder.fetchRequest())
    }()
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //get user permission for notifications and location
        let center =  UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (result, error) in
            self.displayAlertWith(error: LocationError.locationPermissionsError)
        }
        self.locationManager.requestWhenInUseAuthorization()

    }
    
    //MARK: - VWA
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //reload tableview for cell reuse accuracy
        self.tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //initialise cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as! ReminderTableViewCell
        //configure cell
        cell.configureReminderCellWith(reminder: fetchedResultsController.object(at: indexPath))
        //return cell
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //setup delete swipe option
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //remove entry and save
        let reminder = fetchedResultsController.object(at: indexPath)
        guard let uuid = reminder.uuid else { return }
        notificationManager.removeNotificationWith(uuid: uuid)
        managedObjectContext.delete(reminder)
        managedObjectContext.saveChanges()
    }
    
    //MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewReminder"{
            
            let DetailVC = segue.destination as! DetailViewController
            let cell = sender as! ReminderTableViewCell
            //find index for selected cell
            let index = self.tableView.indexPath(for: cell)
            //retrieve relevant entry
            let reminder = fetchedResultsController.object(at: index!)
            //set entry to VC
            DetailVC.reminder = reminder
            
        }
    }
}
