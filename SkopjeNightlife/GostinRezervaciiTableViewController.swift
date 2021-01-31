//
//  GostinRezervaciiTableViewController.swift
//  SkopjeNightlife
//
//  Created by Filip Dimitrovski on 1/31/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class GostinRezervaciiTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTable()
    }
    override func viewDidAppear(_ animated: Bool) {
        updateTable()
    }
    var datumi = [String]()
    var statusi = [String]()
    var lokalobjectIds = [String]()
    var brgosti = [String]()
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lokalobjectIds.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rezervacijakelija", for: indexPath) as! GostinRezervacijaTableViewCell
        let query = PFQuery(className: "Lokal")
        query.whereKey("objectId", equalTo: lokalobjectIds[indexPath.row])
               query.findObjectsInBackground(block: { (objects, error) in
                   if error != nil {
                       print(error?.localizedDescription ?? "")
                   }
                   else if let objects = objects {
                     let object = objects[0]
                               
                    cell.imelokalLabel.text = object["name"] as? String
                    cell.tiplokalLabel.text = object["tiplokal"] as? String
                    cell.kontaktLabel.text = object["kontakt"] as? String
                     
                   }
                   
               })
        cell.brgostiLabel.text = brgosti[indexPath.row]
        cell.statusLabel.text = statusi[indexPath.row]
        cell.datumLabel.text = datumi[indexPath.row]
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    @objc func updateTable() {
        
        self.lokalobjectIds.removeAll()
        self.statusi.removeAll()
        self.datumi.removeAll()
        
        
        
        let rezervacijaquery = PFQuery(className: "Rezervacija")
        let current = PFUser.current()?.objectId
        rezervacijaquery.whereKey("gostinId", equalTo: current! )
        rezervacijaquery.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                if objects.count > 0 {
                    print(objects.count)
                    for object in objects{
                        
                        
                        self.datumi.append(object["datum"] as! String)
                        self.statusi.append(object["status"] as! String)
                        
                        self.brgosti.append(object["brojgosti"] as! String)
                        self.lokalobjectIds.append(object["lokalId"] as! String)
                        
 
                    }
                }
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    
    
}
