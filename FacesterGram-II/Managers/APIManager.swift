//
//  APIRequestManager.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIManager {
    private static let randomAPIEndpoint: URL = URL(string: "https://randomuser.me/api/")!
    
    static let shared: APIManager = APIManager()
    private init() {}
    
    
    // MARK: - In class example
    func getRandomUserData(completion: @escaping ((Data?)->Void)) {
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: APIManager.randomAPIEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
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
