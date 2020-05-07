//
//  BaseService.swift
//  ARGallery
//
//  Created by Bassist Zero on 5/6/20.
//  Copyright © 2020 Bassist_Zero. All rights reserved.
//

import Foundation

enum ServerError: Error {
    case noDataProvided
    case failedToDecode
}

class BaseService {
    func loadPhotos(onComplete: @escaping (PhotoModel) -> Void, onError: @escaping (Error) -> Void) {
        let urlString = "https://api.unsplash.com/photos/random?client_id=sS3IvElH15dl6SHhUXJCdnacpxX236CR4XKH9CY1WQI"
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            
            guard let photo = try? JSONDecoder().decode(PhotoModel.self, from: data) else {
                print("Couldn't decode")
                onError(ServerError.failedToDecode)
                return
            }
            onComplete(photo)
        }
        task.resume()
    }
}
