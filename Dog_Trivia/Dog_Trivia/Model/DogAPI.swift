//
//  DogAPI.swift
//  Dog_Trivia
//
//  Created by Chris Paine on 2/22/19.
//  Copyright © 2019 Chris Paine. All rights reserved.
//

import UIKit

class DogAPI {
    enum Endpoint: String {
        case allBreeds
        case randomImageFromAllDogsCollections
        
        var path: String {
            switch self {
            case .allBreeds: return "/list/all"
            case .randomImageFromAllDogsCollections: return "/image/random"
            }
        }
        
        var url: URL? {
            return URL(string: "https://dog.ceo/api/breeds\(self.path)")
        }
    }
}

extension DogAPI {
    class func requestAllBreeds(completionHandler: @escaping (DogBreeds?, Error?) -> Void) {
        guard let url = Endpoint.allBreeds.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let dogBreeds = try JSONDecoder().decode(DogBreeds.self, from: data)
                completionHandler(dogBreeds, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void) {
        guard let url = Endpoint.randomImageFromAllDogsCollections.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let imageData = try JSONDecoder().decode(DogImage.self, from: data)
                completionHandler(imageData, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
}
