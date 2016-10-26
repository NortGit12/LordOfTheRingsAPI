//
//  CharacterController.swift
//  LordOfTheRingsAPI
//
//  Created by Jeff Norton on 10/25/16.
//  Copyright © 2016 JeffCryst. All rights reserved.
//

import Foundation

protocol CharacterControllerDelegate {
    
    func charactersUpdated(characters: [Character])
}

class CharacterController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    
    static let baseURL = URL(string: "https://lordoftherings-f4f43.firebaseio.com/characters")
    
    static let getAllCharactersURL = CharacterController.baseURL?.appendingPathExtension("json")
    
    var characters = [Character]() {
        
        didSet {
            
            DispatchQueue.main.async {
            
                self.delegate?.charactersUpdated(characters: self.characters)
            }
        }
    }
    
    var delegate: CharacterControllerDelegate?
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    init() {
        
        getFromAPI { (characters) in
            
            if characters.count > 0 {
                
                self.characters = characters
            }
        }
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
            
            self.getFromAPI { (characters) in
                
                if characters.count > 0 {
                    
                    self.characters = characters
                }
            }
        }
    }
    
    func getFromAPI(allCharacters completion: @escaping (_ characters: [Character]) -> Void = { _ in }) {
        
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
                
                print("arrayOfCharacterDictionaries = \(arrayOfCharacterDictionaries)")
                
                let characters = arrayOfCharacterDictionaries.flatMap{ Character(identifier: $0.0, dictionary: $0.1) }
                
                let sortedCharacters = characters.sorted(by: { $0.name < $1.name })
                
                completion(sortedCharacters)
            }
        }
    }
}















