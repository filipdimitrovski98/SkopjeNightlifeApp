//
//  AdminRequestsTableViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/31/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class AdminRequestsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        
    }
    override func viewDidAppear(_ animated: Bool) {
            updateTable()
    }
    var objectIds = [String]()
    var names = [String]()
    var lastnames = [String]()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectIds.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "menadzerkelija", for: indexPath)
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "menadzerkelija")
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = lastnames[indexPath.row]

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendobjectId = objectIds[indexPath.row]
        performSegue(withIdentifier: "toRequestDetail", sender: nil)
    }
    
    @objc func updateTable() {
        self.names.removeAll()
        self.objectIds.removeAll()
        self.lastnames.removeAll()
        
        
        let query = PFUser.query()
        query?.whereKey("apliciral", equalTo: "Da")
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let users = users {
                if users.count > 0 {
                   // print(users.count)
                    for user in users{
                        
                        self.objectIds.append(user.objectId!)
                        self.names.append(user["name"] as! String)
                        self.lastnames.append(user["lastName"] as! String)
                       
                        
                    }
                }
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    
 

}
