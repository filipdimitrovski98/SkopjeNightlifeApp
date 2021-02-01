//
//  MenadzerRezervaciiTableViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 2/1/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var sendgostinId = String()
class MenadzerRezervaciiTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()

  }
    override func viewDidAppear(_ animated: Bool) {
            updateTable()
    }
    var objectIds = [String]()
    var datumi = [String]()
    var brGosti = [String]()
    var gostinIds = [String]()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "rezervacija", for: indexPath) as! MenadzerRezervacijaTableViewCell
        
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: gostinIds[indexPath.row])
        query?.findObjectsInBackground(block: {
            (users,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let users = users {
                let user = users[0]
                cell.imeLabel.text = user["name"] as! String
                cell.prezimeLabel.text = user["lastName"] as! String
                cell.brgostiLabel.text = self.brGosti[indexPath.row]
                cell.datumvremeLabel.text = self.datumi[indexPath.row]
                
            }
        })
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendobjectId = objectIds[indexPath.row]
        sendgostinId = gostinIds[indexPath.row]
        performSegue(withIdentifier: "toRezervacijaDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    @IBAction func logoutPressed(_ sender: Any) {
             PFUser.logOut()
             print("Logout Success")
             navigationController?.dismiss(animated: true, completion: nil)
             
         }
    @objc func updateTable() {
        self.datumi.removeAll()
        self.objectIds.removeAll()
        self.gostinIds.removeAll()
        self.brGosti.removeAll()
       
        let query = PFQuery(className: "Rezervacija")
        query.whereKey("status", equalTo: "Ne potvrdena")
        query.whereKey("lokalId", equalTo: sendlokalId)
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                if objects.count > 0 {
                  for object in objects{
                        
                        
                        self.objectIds.append(object.objectId!)
                        self.datumi.append(object["datum"] as! String)
                        self.brGosti.append(object["brojgosti"] as! String)
                        self.gostinIds.append(object["gostinId"] as! String)
                    }
                }
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    
   

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
  */

}
