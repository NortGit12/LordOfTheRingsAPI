//
//  CharacterController.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

class CharacterController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let baseURL = URL(string: "https://lordoftherings-f4f43.firebaseio.com/characters")
    
    static let getAllCharactersURL = CharacterController.baseURL?.appendingPathExtension("json")
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init() {
        
        getFromAPI()
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func addToAPI(newCharacterName name: String, andDescription description: String) {
        
        let newCharacter = Character(name: name, description: description)
        
        guard let addNewCharacterURL = newCharacter.addNewCharacterURL else { return }
        
        NetworkController.performRequest(for: addNewCharacterURL, httpMethod: .Put, body: newCharacter.jsonData) { (data, error) in
            
            if let error = error {
                
                NSLog("Erorr: \(error.localizedDescription)")
                return
            }
            
            if let _ = data {
                
                NSLog("New character \"\(newCharacter.name)\" successfully added to the API.")
            }
        }
    }
    
    func getFromAPI(allCharacters completion: (_ characters: [Character]) -> Void = { _ in }) {
        
        guard let getAllCharactersURL = CharacterController.getAllCharactersURL else { return }
        
        NetworkController.performRequest(for: getAllCharactersURL, httpMethod: .Get) { (data, error) in
            
            var characters = [Character]()
            
            defer {
                
                completion(characters)
            }
            
            if let error = error {
                
                NSLog("Erorr: \(error.localizedDescription)")
                return
            }
            
            if let data = data
                , let responseDataString = String(data: data, encoding: .utf8) {
                
                if responseDataString.contains("error") {
                    
                    NSLog("Error: \(responseDataString)")
                    return
                }
                
                guard let arrayOfCharacterDictionaries = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : [String: Any]]
                    else {
                        
                        NSLog("Error parsing the JSON")
                        return
                }
                
                let characters = arrayOfCharacterDictionaries.flatMap{ Character(identifier: $0, dictionary: $1) }
                
                completion(characters)
            }
        }
    }
}















