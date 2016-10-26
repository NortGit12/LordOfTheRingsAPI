//
//  LocationController.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

protocol LocationControllerDelegate {
    
    func locationsUpdated(locations: [Location])
}

class LocationController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let baseURL = URL(string: "https://lordoftherings-f4f43.firebaseio.com/locations")
    
    static let getAllLocationsURL = LocationController.baseURL?.appendingPathExtension("json")
    
    var locations = [Location]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.delegate?.locationsUpdated(locations: self.locations)
            }
        }
    }
    
    var delegate: LocationControllerDelegate?
    
    //==================================================
    // MARK: - Initializer
    //==================================================
    
    init() {
        
        getFromAPI { (locations) in
            
            if locations.count > 0 {
                
                self.locations = locations
            }
        }
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func addToAPI(newLocationName name: String, andDescription description: String) {
        
        let newLocation = Location(name: name, description: description)
        
        guard let addNewLocationURL = newLocation.addNewLocationURL else { return }
        
        NetworkController.performRequest(for: addNewLocationURL, httpMethod: .Put, body: newLocation.jsonData) { (data, error) in
            
            if let error = error {
                
                NSLog("Erorr: \(error.localizedDescription)")
                return
            }
            
            if let _ = data {
                
                NSLog("New location \"\(newLocation.name)\" successfully added to the API.")
            }
            
            self.getFromAPI()
        }
    }
    
    func deleteFromAPI(location: Location) {
        
        guard let deleteLocationURL = location.deleteLocationURL else {
            
            NSLog("Error getting delete endpoint for location \(location.name).")
            return
        }
        
        NetworkController.performRequest(for: deleteLocationURL, httpMethod: .Delete) { (data, error) in
            
            if let error = error {
                
                NSLog("Error: \(error.localizedDescription)")
                return
            }
            
            if let _ = data {
                
                NSLog("Location \(location.name) successfully deleted from the API.")
            }
            
            self.getFromAPI()
        }
    }
    
    func getFromAPI(allLocations completion: @escaping (_ locations: [Location]) -> Void = { _ in }) {
        
        guard let getAllLocationsURL = LocationController.getAllLocationsURL else { return }
        
        NetworkController.performRequest(for: getAllLocationsURL, httpMethod: .Get) { (data, error) in
            
            var locations = [Location]()
            
            defer {
                
                completion(locations)
            }
            
            if let error = error {
                
                NSLog("Error: \(error.localizedDescription)")
            }
            
            if let data = data
                , let responseDataString = String(data: data, encoding: .utf8) {
                
                if responseDataString.contains("error") {
                    
                    NSLog("Error: \(responseDataString)")
                    return
                }
                
                guard let arrayOfLocationDictionaries = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : [String : Any]]
                    else {
                        
                        NSLog("Error parsing the JSON.")
                        return
                }
                
                let locations = arrayOfLocationDictionaries.flatMap{ Location(identifier: $0.0, dictionary: $0.1) }
                let sortedLocations = locations.sorted(by: { $0.name < $1.name })
                
                self.locations = sortedLocations
                
                completion(sortedLocations)
            }
        }
    }
}
























