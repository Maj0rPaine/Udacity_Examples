//
//  DogImage.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/22/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import Foundation

struct DogImage: Codable {
    var status: String?
    var message: String?
    
    var breedType: String? {
        guard let url = URL(string: message ?? "")  else { return nil }
        
        // Parse breed from path
        guard !url.pathComponents.isEmpty, url.pathComponents.count > 1 else { return nil }
        let index = url.pathComponents.count - 2
        return url.pathComponents[index]
    }
}
