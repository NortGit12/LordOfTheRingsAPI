//
//  Character.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

struct Character {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    var identifier: UUID
    var name: String
    var description: String
    
    fileprivate let identifierKey = "identifier"
    fileprivate let nameKey = "name"
    fileprivate let descriptionKey = "description"
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init(name: String, description: String) {
        
        self.identifier = UUID()
        self.name = name
        self.description = description
    }
    
}

// Purpose: Firebase API support 

extension Character {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    var addNewCharacterURL: URL? {
        
        return CharacterController.baseURL?.appendingPathComponent(self.identifier.uuidString).appendingPathExtension("json")
    }
    
    var deleteCharacterURL: URL? {
        
        return CharacterController.baseURL?.appendingPathComponent(self.identifier.uuidString).appendingPathExtension("json")
    }
    
    var dictionary: [String : Any] {
        
        return [nameKey: self.name, descriptionKey: self.description]
    }
    
    var jsonData: Data? {
        
        return try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init?(identifier: String, dictionary: [ String : Any ]) {
        
        guard let identifier = UUID(uuidString: identifier)
            , let name = dictionary[nameKey] as? String
            , let description = dictionary[descriptionKey] as? String
            else {
                
                NSLog("Error creating Character instance from a dictionary.")
                return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.description = description
    }
}























