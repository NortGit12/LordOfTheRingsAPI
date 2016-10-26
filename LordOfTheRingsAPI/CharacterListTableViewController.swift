//
//  CharacterListTableViewController.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import UIKit

class CharacterListTableViewController: UITableViewController, CharacterControllerDelegate {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var characterController = CharacterController()
    
    //==================================================
    // MARK: - General
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()

        characterController.delegate = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    //==================================================
    // MARK: - Table view data source
    //==================================================

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return characterController.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "charaterCell", for: indexPath)

        let character = characterController.characters[indexPath.row]
        
        cell.textLabel?.text = character.name
        cell.detailTextLabel?.text = character.description

        return cell
    }
    
    //==================================================
    // MARK: - CharacterControllerDelegate
    //==================================================
    
    func charactersUpdated(characters: [Character]) {
        
        tableView.reloadData()
    }
    
    //==================================================
    // MARK: - Actions
    //==================================================
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let name = nameTextField.text, name.characters.count > 0
            , let description = descriptionTextField.text, description.characters.count > 0
            else {
                
                NSLog("Error getting required character name and description.")
                
                let alertController = UIAlertController(title: "Missing Required Information", message: "Make sure you have entered both a name and description and try again.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                present(alertController, animated: true, completion: nil)
                
                return
        }
        
        characterController.addToAPI(newCharacterName: name, andDescription: description)
        
        nameTextField.text = ""
        descriptionTextField.text = ""
        
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}



























