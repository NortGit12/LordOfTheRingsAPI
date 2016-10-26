//
//  LocationListTableViewController.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import UIKit

class LocationListTableViewController: UITableViewController, LocationControllerDelegate {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var locationController = LocationController()
    
    //==================================================
    // MARK: - General
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()

        locationController.delegate = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    //==================================================
    // MARK: - Table view data source
    //==================================================

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationController.locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)

        let location = locationController.locations[indexPath.row]
        cell.textLabel?.text = location.name
        cell.detailTextLabel?.text = location.description

        return cell
    }
    
    //==================================================
    // MARK: - LocationControllerDelegate
    //==================================================
    
    func locationsUpdated(locations: [Location]) {
        
        tableView.reloadData()
    }
    
    //==================================================
    // MARK: - Actions
    //==================================================
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let name = nameTextField.text, name.characters.count > 0
            , let description = descriptionTextField.text, description.characters.count > 0
            else {
                
                NSLog("Error getting required location name and description.")
                
                let alertController = UIAlertController(title: "Missing Required Information", message: "Make sure you have entered both a name and description and try again.", preferredStyle: .alert
                )
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        locationController.addToAPI(newLocationName: name, andDescription: description)
        
        nameTextField.text = ""
        descriptionTextField.text = ""
        
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}
























