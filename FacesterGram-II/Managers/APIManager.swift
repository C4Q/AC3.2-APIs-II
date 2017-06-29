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

enum UserPassOptions: String {
    case upper, lower, number, special
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
    
    func generatePassword(completion: @escaping (String?) -> Void) {
        let queryString = "?password=upper,lower,number,special,8-16&" +
                          "inc=login"
        let queryURL = URL(string: queryString, relativeTo: APIManager.randomAPIEndpoint)!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: queryURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(String(describing: error?.localizedDescription))")
            }
            
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    
                    if let resultsJSON = json["results"] as? [[String : AnyObject]] {
                        for results in resultsJSON {
                            guard
                                let loginJSON = results["login"] as? [String: String],
                                let passwordString = loginJSON["password"]
                            else {
                                    completion(nil)
                                    return
                            }
                            
                            completion(passwordString)
                        }
                    }
                }
                catch {
                    print("Error Occurred: \(error.localizedDescription)")
                }

            }
            
            }.resume()

    }
    
    func generatePassword(options: [UserPassOptions], minLength: Int, maxLength: Int, completion: @escaping (String?) -> Void) {
        var passwordOptions = "?password="
        for option in options {
            passwordOptions.append(option.rawValue + ",")
        }
        passwordOptions += "\(minLength)-\(maxLength)"
        
        let queryURL = URL(string: passwordOptions, relativeTo: APIManager.randomAPIEndpoint)!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: queryURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(String(describing: error?.localizedDescription))")
            }
            
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    
                    if let resultsJSON = json["results"] as? [[String : AnyObject]] {
                        for results in resultsJSON {
                            guard
                                let loginJSON = results["login"] as? [String: String],
                                let passwordString = loginJSON["password"]
                                else {
                                    completion(nil)
                                    return
                            }
                            
                            completion(passwordString)
                        }
                    }
                }
                catch {
                    print("Error Occurred: \(error.localizedDescription)")
                }
                
            }
            
            }.resume()
    }
}
