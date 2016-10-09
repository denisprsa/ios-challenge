//
//  APIManeger.swift
//  iOS challenge
//
//  Created by Denis Prša on 7. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import Foundation
import AFNetworking

class APIManager {
    public static let instance = APIManager()
    private let key = "19588ca1c18b866178b6d78d85915b45"
    
    // MARK: - Get data
    
    private func getResponse(url: String, response: @escaping (Any?) -> Void ) {
        let manager = AFHTTPSessionManager()
        
        manager.get(url + "?api_key=" + key,
                    parameters: nil,
                    progress: nil,
                    success: { (task, respons) in
                        response(respons)
            }
        ){ (dataTask, error) in
            response(error)
        }
    }
    
    private func jsonLoaded(json: String) {
        print("JSON: \(json)")
    }
    
    private func jsonFailed(error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
    
    // MARK: - Public Methods for retrieving data
    
    public func getActors(id: String, response: @escaping (Any?) -> Void) {
        getResponse(url: "https://api.themoviedb.org/3/movie/\(id)"){ dataResponse in
            response(dataResponse)
        }
        
    }
    
    // MARK: - Public Methods for posting data
    
    public func setRating() {
        
    }
}
