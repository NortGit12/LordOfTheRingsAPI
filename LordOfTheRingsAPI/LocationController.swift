//
//  LocationController.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

class LocationController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let baseURL = URL(string: "https://lordoftherings-f4f43.firebaseio.com/locations")
    
    static let getAllLocationsURL = LocationController.baseURL?.appendingPathExtension("json")
    
    //==================================================
    // MARK: - Initializer
    //==================================================
    
    init() {
        
        getFromAPI()
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func addToAPI(newLocationName name: String, andDescription description: String) {
        
        let newLocation = Location(name: name, description: description)
        
        guard let addNewLocationURL = newLocation.addNewLocationURL else { return }
        
        NetworkController.performRequest(for: addNewLocationURL, httpMethod: .Put) { (data, error) in
            
            if let error = error {
                
                NSLog("Erorr: \(error.localizedDescription)")
                return
            }
            
            if let _ = data {
                
                NSLog("New location \"\(newLocation.name)\" successfully added to the API.")
            }
        }
    }
    
    func getFromAPI(allLocations completion: (_ locations: [Location]) -> Void = { _ in }) {
        
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
                
                let locations = arrayOfLocationDictionaries.flatMap{ Location(identifier: $0, dictionary: $1) }
                
                completion(locations)
            }
        }
    }
}
























