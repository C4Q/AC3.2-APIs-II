//
//  APIRequestManager.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIManager {
    private static let randomAPIEndpoint: URL = URL(string: "https://api.randomuser.me")!
    
    static let shared: APIManager = APIManager()
    private init() {}
    
    
    // MARK: - In class example
    func getRandomUserData(results: Int = 10, completion: @escaping ((Data?)->Void)) {
//        let queryURL = URL(string: "?results=\(results)", relativeTo: APIManager.randomAPIEndpoint)!
        
        let queryString = APIManager.randomAPIEndpoint.absoluteString + "?results=\(results)"
        let queryURL = URL(string: queryString)!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: queryURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(String(describing: error?.localizedDescription))")
            }
            
            if data != nil {
                print("Data returned in response")
                completion(data)
            }
            
            }.resume()
    }
}
