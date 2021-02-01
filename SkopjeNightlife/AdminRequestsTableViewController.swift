//
//  AdminRequestsTableViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/31/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var sendaplikacijaId = String()
var sendlokalId = String()
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
    var aplikacii = [String]()
    var lokali = [String]()

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
        sendaplikacijaId = aplikacii[indexPath.row]
        sendlokalId = lokali[indexPath.row]
        print("Aplikacija \(sendaplikacijaId)")
        performSegue(withIdentifier: "toRequestDetail", sender: nil)
    }
    
    @objc func updateTable() {
        self.names.removeAll()
        self.objectIds.removeAll()
        self.lastnames.removeAll()
        self.objectIds.removeAll()
        
        
        let query = PFQuery(className: "Aplikacija")
        query.whereKey("status", equalTo: "Ne potvrdena")
        query.findObjectsInBackground(block: {
            (objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects { //print(objects.count)
                for object in objects {
                    let queryy = PFUser.query()
                    queryy?.whereKey("objectId", equalTo: object["menadzerId"])
                    queryy?.findObjectsInBackground(block: {
                        (users,error2) in
                        if error2 != nil {
                            print(error2?.localizedDescription ?? "")
                        }
                        else if let users = users { //print(users.count)
                            let user = users[0]
                            self.names.append(user["name"] as! String)
                            self.lastnames.append(user["lastName"] as! String)
                            self.objectIds.append(user.objectId!)
                            self.aplikacii.append(object.objectId!)
                            self.lokali.append(object["lokalId"] as! String)
                            
                            
                        }
                        OperationQueue.main.addOperation {
                            self.tableView.reloadData()
                        }
                    })
                }
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    
 

}
