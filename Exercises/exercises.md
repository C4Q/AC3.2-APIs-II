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