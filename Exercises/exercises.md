### Solutions to Exercises:

#### Adding a `gender` and `nationality` parameter

> Note: This is the code for the full, basic solution. There are many possible solutions to this, here is but one example that makes use of `URL(string:relativeTo:)

```swift
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
}
```

#### Advanced: Using Enums

There are primarily two ways of approaching this: 

1. Doing a basic enum and using switch statements to get the right string value
2. Doing an enum with a `String` associated value

For the first way, our code could look like (note that Swift convention is that enum cases begin with lowercase letters):

```swift
enum UserGender {
    case male, female, both
}

enum UserNationality {
    case us, nl, tr
}

func getRandomUserData(results: Int, gender: UserGender, nationality: UserNationality, completion: @escaping ((Data?)->Void)) {
        var gen: String
        var nat: String
        
        // note: in the documentation of the randomuser api, a query with an empty string value gets ignored.
        // this is why .both and .any are empty strings (to return all possibilites)
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
        
        // we can simply call our existing getRandomUserData function with our parsed values
        getRandomUserData(results: results, gender: gen, nationality: nat, completion: completion)
    }
```

The second way, associate the enum's `rawValue` as being type `String`. By default, the `rawValue` becomes a `String` with the same name as the case, so `case us` means `UserNationalityTyped.us.rawValue == "us"`. But you can also provide a specific value to the case, as demonstrated below: 

```swift
enum UserGenderTyped: String {
    case male, female
    case both = ""
}

enum UserNationalityTyped: String {
    case us, nl, tr
    case any = ""
}

func getRandomUserData(results: Int, gender: UserGenderTyped, nationality: UserNationalityTyped, completion: @escaping ((Data?)->Void)) {
    getRandomUserData(results: results, gender: gender.rawValue, nationality: nationality.rawValue, completion: completion)
}
```

### Execise Set 2

```swift
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
```

#### Advanced 
```swift
// In APIManager.swift
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

// In UserTableViewController
        APIManager.shared.generatePassword(options: [.upper,.lower,.number.special], minLength: 8, maxLength: 16) { (password: String?) in
            if password != nil {
                let alert = UIAlertController(title: "Password", message: "\(password!)", preferredStyle: .actionSheet)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
```