//
//  DogBreeds.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/23/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import Foundation

struct DogBreeds: Codable {
    var status: String?
    var message: [String: [String]]?
    
    var breeds: [String] {
        guard let message = message else { return [] }
        return message.keys.map({ $0 })
    }
}

extension Array {
    
    /**
     Create random answers for trivia questions.
     
     - Parameter breedType: The correct breed type
     
     - Returns: Array of string answers
     */
    func randomBreeds(breedType: String) -> [String] {
        var randomBreeds: [String] = [breedType]
        
        while randomBreeds.count < 4 {
            if let randomBreed = self.randomElement() as? String,
                !randomBreeds.contains(randomBreed) {
                randomBreeds.append(randomBreed)
            }
        }
        
        return randomBreeds.shuffled()
    }
}
