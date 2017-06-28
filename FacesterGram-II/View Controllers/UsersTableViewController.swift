//
//  UsersTableViewController.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    // Describe what these three keywords indicate about UserTableViewCellIdentifier
    private static let UserTableViewCellIdentifier: String = "UserTableViewCellIdentifier"
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refreshRequested(_:)), for: .valueChanged)
        self.loadUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Pull to Refresh
    func refreshRequested(_ sender: UIRefreshControl) {
        self.loadUsers()
    }
    
    func loadUsers() {
        APIManager.shared.getRandomUserData { (data: Data?) in
            if data != nil {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    
                    if let resultsJSON = json["results"] as? [[String : AnyObject]] {
                        for results in resultsJSON {
                            let newUser = User(json: results)
                            
                            self.users.append(newUser)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.refreshControl?.endRefreshing()
                            }
                        }
                    }
                }
                catch {
                    print("Error Occurred: \(error.localizedDescription)")
                }
                
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewController.UserTableViewCellIdentifier, for: indexPath)

        guard self.users.count >= indexPath.row + 1 else {
            return cell
        }
        
        let user = self.users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = "\(user.username)"
        
        return cell
    }
 

}
