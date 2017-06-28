//
//  APIRequestManager.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum UserGender {
    case male, female, both
}

enum UserNationality {
    case us, nl, tr, any
}

enum UserGenderTyped: String {
    case male, female
    case both = ""
}

enum UserNationalityTyped: String {
    case us, nl, tr
    case any = ""
}

class APIManager {
    private static let randomAPIEndpoint: URL = URL(string: "https://api.randomuser.me")!
    
    static let shared: APIManager = APIManager()
    private init() {}
    
    
    // MARK: - In class example
    func getRandomUserData(results: Int, gender: String, nationality: String, completion: @escaping ((Data?)->Void)) {
        let queryString = "?results=\(results)&" +
                          "gender=\(gender)&" +
                          "nat=\(nationality)"
        let queryURL = URL(string: queryString, relativeTo: APIManager.randomAPIEndpoint)!
        
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
    
    func getRandomUserData(results: Int, gender: UserGender, nationality: UserNationality, completion: @escaping ((Data?)->Void)) {
        var gen: String
        var nat: String
        
        switch gender {
        case .male: gen = "male"
        case .female: gen = "female"
        case .both: gen = ""
        }
        
        switch nationality {
        case .us: nat = "us"
        case .nl: nat = "nl"
        case .tr: nat = "tr"
        case .any: nat = ""
        }
        
        getRandomUserData(results: results, gender: gen, nationality: nat, completion: completion)
    }
    
    func getRandomUserData(results: Int, gender: UserGenderTyped, nationality: UserNationalityTyped, completion: @escaping ((Data?)->Void)) {
        print("Gender, Nationality: ", gender.rawValue, nationality.rawValue)
        getRandomUserData(results: results, gender: gender.rawValue, nationality: nationality.rawValue, completion: completion)
    }
}
